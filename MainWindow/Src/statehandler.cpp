#include "statehandler.h"
#include "A3200Api.h"
#include "GtMotion.h"
#include "inisettings.h"
#include "mainwindow.h"
#include <QTimer>
#include <QDebug>
#include <QtMath>
#include <QEventLoop>
#include <QCoreApplication>
#include <QTime>




StateWorker::StateWorker(QObject *parent)
{

}

StateWorker::~StateWorker()
{
    requestInterruption();
    wait();
    quit();

}



void StateWorker::run()
{

    while (true) {
        if(isInterruptionRequested())
            return;
        StateHandler::GetInstance()->setOutput(Output::Buzzer,true);
        for(int a=0;a<20;a++){
            if(isInterruptionRequested()){
                StateHandler::GetInstance()->setOutput(Output::Buzzer,false);
                return;
            }
            QThread::msleep(100);
        }
        StateHandler::GetInstance()->setOutput(Output::Buzzer,false);
        for(int a=0;a<12;a++){
            if(isInterruptionRequested()){
                StateHandler::GetInstance()->setOutput(Output::Buzzer,false);
                return;
            }
            QThread::msleep(100);
        }
    }

}


StateHandler* StateHandler::m_pInstance = nullptr;

StateHandler *StateHandler::GetInstance()
{
    if(m_pInstance == nullptr)
    {
        m_pInstance = new StateHandler();
        atexit(Release);
    }
    return m_pInstance;
}
void StateHandler::Release()
{
    if(m_pInstance)
    {
        delete m_pInstance;
        m_pInstance = nullptr;
    }
}

void StateHandler::unInit()
{


    timer->stop();
    delete worker;

    StateHandler::GetInstance()->setOutput(Output::Fixtrue_1,false);
    StateHandler::GetInstance()->setOutput(Output::Fixtrue_2,false);
    StateHandler::GetInstance()->setOutput(Output::N2_on_off,false);
    StateHandler::GetInstance()->setOutput(Output::Safegate_locked,false);
    StateHandler::GetInstance()->setOutput(Output::Cleaner_on_off,false);
    StateHandler::GetInstance()->setOutput(Output::Coaxial_lighter,false);
    StateHandler::GetInstance()->setOutput(Output::Red_lamp,false);
    StateHandler::GetInstance()->setOutput(Output::Green_lamp,false);
    StateHandler::GetInstance()->setOutput(Output::Yellow_lamp,false);
    StateHandler::GetInstance()->setOutput(Output::Buzzer,false);

    MainWindow::GetInstance()->laseroff();
    A3200Api::GetInstance()->StopProgramAndWait();
    A3200Api::GetInstance()->StopAllAxis();
    A3200Api::GetInstance()->DisableAllAxis();

    GtMotion::GetInstance()->Stop(1);
    GtMotion::GetInstance()->Close();
}

StateHandler::StateHandler(QObject *parent) : QObject(parent)
{
    isWarning=false;
    isEnableWarning=IniSettings::GetInstance()->getValue(IniType::State_isWarning).toInt();

    temp.append(0);
    temp.append(0);
    temp.append(0);
    worker=new StateWorker(this);

    timer=new QTimer(this);
    timer->setInterval(30);
    connect(timer,&QTimer::timeout,this,&StateHandler::refreshFunc);


}

StateHandler::~StateHandler()
{

}

unsigned short StateHandler::readBit(unsigned short value, int begin, int count)
{
    if(begin+count-1 > 16)
        return 0;//首先保证取值范围不会越界
    begin = begin-1;//外部从1开始，内部从0开始
    if(begin < 0 || count < 1 || count > 16)//7位16-1得到最大索引
        return 0;
    unsigned short tmp = 0xffff;
    unsigned short off = 16-count;
    tmp <<= off;//先左移，得到需要取的位数位置
    off = off-begin;
    tmp >>= off;//再右移，则得到取起始位
    unsigned short ret = value & tmp;
    ret >>= begin;
    return ret;
}


unsigned short StateHandler::writeBit(unsigned short value, int begin, int count, unsigned short src)
{
    if(begin+count-1 > 16)
        return 0;//首先保证取值范围不会越界
    begin = begin-1;//外部从1开始，内部从0开始
    if(begin < 0 || count < 1 || count > 16)//7位16-1得到最大索引
        return 0;
    unsigned short max = qPow(2,count)-1;//幂函数，取得2的n次方的最大值
    if(value > max)
        value = max;//最大值,避免其它位被意外修改
    unsigned short tmp = 0xffff;
    unsigned short off = 16-count;
    tmp <<= off;//先左移，得到需要取的位数位置
    off = off-begin;
    tmp >>= off;//再右移，则得到取起始位
    tmp = ~tmp;
    unsigned short srcTmp = tmp & src;
    value <<= begin;
    unsigned short ret = value | srcTmp;
    return ret;
}

void StateHandler::refreshFunc()
{
    static bool a=true;
    if(!isEnableWarning){
        isWarning=false;
        a=true;

        if(worker->isRunning()){
            worker->requestInterruption();
            worker->wait();
        }

    }
    else{
        bool a1=!getInput(Input::E_Stop);
        bool a2=getInput(Input::Air_pressure);
        bool a3=getInput(Input::Back_gate);
        bool a4=getInput(Input::Front_gate);
        bool a5=getInput(Input::Left_gate);
        bool a6=getInput(Input::Right_gate);
        bool a7=getInput(Input::Safe_gate);
        bool a8=getInput(Input::Lightpath_closed);
        bool a9=getInput(Input::N2_pressure);
        bool a10=getInput(Input::Water_cooling_flow);
        bool a11=getInput(Input::water_cooling_Temp);
        bool a12=getInput(Input::Finished_box_closed);
        bool a13=getInput(Input::Laser_power);

        if(a1||a2||a3||a4||a5||a6||a7||a8||a9||a10||a11||a12||a13){
            if(a){
                setOutput(Output::Red_lamp,true);
                setOutput(Output::Green_lamp,false);
                setOutput(Output::Yellow_lamp,false);
                worker->start();
                a=false;
                StateHandler::GetInstance()->isWarning=true;
            }
        }
        else{
            if(!a){

                setOutput(Output::Red_lamp,false);
                setOutput(Output::Green_lamp,true);
                setOutput(Output::Yellow_lamp,false);
                setOutput(Output::Buzzer,false);
                worker->requestInterruption();
                worker->wait();

                a=true;
                isWarning=false;
            }
        }
    }
}

bool StateHandler::getIsWarning()
{
    return isEnableWarning;
}


void StateHandler::beginMonitor()
{
    timer->start();
}


int StateHandler::getInput(int count )
{
    if(count<17){
        long a=GtMotion::GetInstance()->GetInputBit(4);
        if(a==-1){
            return -1;
        }
        if(count==Input::E_Stop){
            return !readBit(a,count,1);
        }

        static bool k=true;
        if(count==Input::Aspirateur){
            if(!readBit(a,count,1)){
                if(k){
                    setOutput(Output::Cleaner_on_off,!getOutput(Output::Cleaner_on_off));
                    k=false;
                }
            }
            else{
                k=true;
            }
        }

        //qDebug()<<readBit(a,count,1);
        return readBit(a,count,1);
    }
    else{
        unsigned long b=0;
        if(A3200Api::GetInstance()->GetInput(2,0,b)){
            if(count==Input::Tube_exist){
                return !readBit(b,count-8,1);
            }
            return readBit(b,count-8,1);
        }
        else{
            return -1;
        }
    }
}

int StateHandler::getOutput(int count)
{

    if(count<17){
        long a=GtMotion::GetInstance()->GetOutputBit(12);
        if(a==-1){
            return -1;
        }

        return !readBit(a,count,1);
    }
    else{

        return temp[count-17];
    }
}

bool StateHandler::setOutput(int count,bool value)
{
    if(count<17){

        return GtMotion::GetInstance()->SetOutput(12,count,!value);
    }
    else{
        unsigned short src=0;
        src=writeBit(temp[0],9,1,src);
        src=writeBit(temp[1],10,1,src);
        src=writeBit(temp[2],11,1,src);

        if(A3200Api::GetInstance()->SetOutput(2,0, writeBit(value,count-8,1,src))){
            temp[count-17]=value;

            return true;
        }
        else{

            return false;
        }
    }
}

void StateHandler::setMonitor(bool value)
{
    IniSettings::GetInstance()->setValue(IniType::State_isWarning,QString::number(value));
    isEnableWarning=value;
}


