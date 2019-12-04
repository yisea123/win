#include "mainwindow.h"
#include <QFileDialog>
#include <QDebug>
#include <QMessageBox>
#include <QStandardPaths>
#include <QFile>
#include <QRunnable>
#include <QEventLoop>
#include <QTimer>

#include "A3200Api.h"
#include "GtMotion.h"
#include "statehandler.h"
#include "motionhandler.h"
#include "inisettings.h"
#include "hserialportlaser.h"
#include "laserui.h"


Translator * Translator::m_pInstance = nullptr;

Translator::Translator(QObject *parent)
    : QTranslator(parent)
{
    QWaitCondition a;
}

Translator* Translator::inst()
{
    if (!m_pInstance) {
        m_pInstance = new Translator();
    }
    return m_pInstance;
}

void Translator::loadLanguage(QString iLang)
{
    QString path = "";//load default language when path=""
    if(iLang=="en"){
        path=":/Resource/tr_en.qm";
    }
    else if(iLang=="zh"){
        path=":/Resource/tr_zh.qm";
    }

    QTranslator::load(path);
    emit languageChanged(iLang);
}

RunProgram::RunProgram(QObject *parent)
{
    count=0;
    step=0;
    focusY=0;
    focusZ=0;
    waitY=0;
    waitZ=0;
    isLaser=false;
    ischeckTube=true;
    isAutoBack=false;
    isGas=true;
    iscloseDoor=true;

    mcs=10;
    prf=1;
    psn=1;
    t1s=1;

    connect(&timer, SIGNAL(timeout()), this, SLOT(checkCondition()));

    note.lastNote=tr("unknown reason!!");
    note.type=0;
}

RunProgram::~RunProgram()
{
    requestInterruption();
    quit();
    wait();
}

void RunProgram::checkCondition()
{
    if(StateHandler::GetInstance()->isWarning){
        lastM.lock();
        note.lastNote=tr("device warning!processing termination!");
        note.type=-1;
        lastM.unlock();
        requestInterruption();
        quit();
        wait();
    } else if((ischeckTube||count==-1)?StateHandler::GetInstance()->getInput(Input::Tube_exist):false){
        lastM.lock();
        note.lastNote=tr("tube is not enough!processing termination!");
        note.type=1;
        lastM.unlock();
        requestInterruption();

        quit();
        wait();
    }

}


void RunProgram::unexpectExit(int type, QString code)
{
    timer.stop();
    MainWindow::GetInstance()->laseroff();
    StateHandler::GetInstance()->setOutput(Output::Fixtrue_1,false);
    StateHandler::GetInstance()->setOutput(Output::Fixtrue_2,false);
    StateHandler::GetInstance()->setOutput(Output::N2_on_off,false);
    StateHandler::GetInstance()->setOutput(Output::Safegate_locked,false);
    A3200Api::GetInstance()->StopProgramAndWait();
    A3200Api::GetInstance()->StopAllAxis();
    if(type==-5){
        emit _runDone(note.type,note.lastNote);
    }
    else{
        emit _runDone(type,code);
    }

    QTimer::singleShot(1,this,[=](){
        QEventLoop loop;

        StateHandler::GetInstance()->setOutput(Output::Red_lamp,true);
        StateHandler::GetInstance()->setOutput(Output::Buzzer,true);
        QTimer::singleShot(3000, &loop, SLOT(quit()));
        loop.exec();

        StateHandler::GetInstance()->setOutput(Output::Red_lamp,false);
        StateHandler::GetInstance()->setOutput(Output::Green_lamp,true);
        StateHandler::GetInstance()->setOutput(Output::Buzzer,false);

    });
    return;
}

void RunProgram::runCompleted(QString code)
{
    setFixtrue1(false);
    setFixtrue2(false);
    StateHandler::GetInstance()->setOutput(Output::N2_on_off,false);
    emit _runDone(0,code);
    QTimer::singleShot(1,this,[=](){
        QEventLoop loop;

        StateHandler::GetInstance()->setOutput(Output::Yellow_lamp,true);
        StateHandler::GetInstance()->setOutput(Output::Buzzer,true);

        QTimer::singleShot(600, &loop, SLOT(quit()));
        loop.exec();

        StateHandler::GetInstance()->setOutput(Output::Yellow_lamp,false);
        StateHandler::GetInstance()->setOutput(Output::Buzzer,false);

        QTimer::singleShot(600, &loop, SLOT(quit()));
        loop.exec();

        StateHandler::GetInstance()->setOutput(Output::Yellow_lamp,true);
        StateHandler::GetInstance()->setOutput(Output::Buzzer,true);

        QTimer::singleShot(600, &loop, SLOT(quit()));
        loop.exec();

        StateHandler::GetInstance()->setOutput(Output::Yellow_lamp,false);
        StateHandler::GetInstance()->setOutput(Output::Buzzer,false);

        QTimer::singleShot(600, &loop, SLOT(quit()));
        loop.exec();

        StateHandler::GetInstance()->setOutput(Output::Yellow_lamp,true);
        StateHandler::GetInstance()->setOutput(Output::Buzzer,true);

        QTimer::singleShot(600, &loop, SLOT(quit()));
        loop.exec();

        StateHandler::GetInstance()->setOutput(Output::Green_lamp,true);
        StateHandler::GetInstance()->setOutput(Output::Yellow_lamp,false);
        StateHandler::GetInstance()->setOutput(Output::Buzzer,false);});
    return;
}

bool RunProgram::setFixtrue1(bool value)
{
    if(StateHandler::GetInstance()->setOutput(Output::Fixtrue_1,value)){
        for(int k=0;k<100;++k){
            QEventLoop loop;
            QTimer::singleShot(10, &loop, SLOT(quit()));
            loop.exec();
            int t1=StateHandler::GetInstance()->getInput(Input::Fixture_1_clamp);
            if(t1==-1){
                unexpectExit(-1,tr("get Fixtrue_1 signal failed!"));
                return false;
            }
            else if(t1!=static_cast<int>(value))
                return true;
            else{
                if(k==99){
                    unexpectExit(-1,tr("Fixtrue_1 ")+(value?tr("loosen"):tr("clamp"))+tr(" failed!"));
                    return false;
                }
                else{
                    continue;
                }
            }
        }
        unexpectExit(-1,tr("unknown error!"));
        return false;

    }
    else{
        unexpectExit(-1,tr("Fixtrue_1 set failed!"));
        return false;
    }
}

bool RunProgram::setFixtrue2(bool value)
{
    if(StateHandler::GetInstance()->setOutput(Output::Fixtrue_2,value)){
        for(int k=0;k<100;++k){
            QEventLoop loop;
            QTimer::singleShot(10, &loop, SLOT(quit()));
            loop.exec();
            int t1=StateHandler::GetInstance()->getInput(Input::Fixture_2_clamp);
            if(t1==-1){
                unexpectExit(-1,tr("get Fixtrue_2 signal failed!"));
                return false;
            }
            else if(t1!=static_cast<int>(value))
                return true;
            else{
                if(k==99){
                    unexpectExit(-1,tr("Fixtrue_2 ")+(value?tr("clamp"):tr("loosen"))+tr(" failed!"));
                    return false;
                }
                else{
                    continue;
                }
            }
        }
        unexpectExit(-1,tr("unknown error!"));
        return false;

    }
    else{
        unexpectExit(-1,tr("Fixtrue_2 set failed!"));
        return false;
    }
}


void RunProgram::run()
{
    QMutexLocker locker(&m_mutex);

    if(iscloseDoor){
        if(!StateHandler::GetInstance()->getInput(Input::Safe_gate)){
            if(!StateHandler::GetInstance()->setOutput(Output::Safegate_locked,true)){
                unexpectExit(-1,tr("lock safegate failed!"));
                return;
            }
        }
        else{
            unexpectExit(-1,tr("safegate is not close!"));
            return;
        }
    }

    //    if(isLaser){
    //        if(!LaserUI::GetInstance()->setLaser(LaserPara::SHT,1)){
    //            unexpectExit(-1,tr("laser open failed!"));
    //            return;
    //        }
    //        if(LaserUI::GetInstance()->setLaser(LaserPara::MCS,mcs)){
    //            if(LaserUI::GetInstance()->setLaser(LaserPara::PRF,prf)){
    //                if(LaserUI::GetInstance()->setLaser(LaserPara::PSN,psn)){
    //                    if(LaserUI::GetInstance()->setLaser(LaserPara::T1S,t1s)){

    //                    }
    //                    else{
    //                        unexpectExit(-1,tr("laser T1S set failed!"));
    //                        return;
    //                    }

    //                }
    //                else{
    //                    unexpectExit(-1,tr("laser PSN set failed!"));
    //                    return;
    //                }
    //            }
    //            else{
    //                unexpectExit(-1,tr("laser PRF set failed!"));
    //                return;
    //            }
    //        }
    //        else{
    //            unexpectExit(-1,tr("laser MCS set failed!"));
    //            return;
    //        }
    //    }
    //    else{
    //        if(!LaserUI::GetInstance()->setLaser(LaserPara::SHT,0)){
    //            unexpectExit(-1,tr("laser close failed!"));
    //            return;
    //        }
    //    }

    StateHandler::GetInstance()->setOutput(Output::Green_lamp,false);
    StateHandler::GetInstance()->setOutput(Output::Yellow_lamp,true);

    if(!A3200Api::GetInstance()->MoveToPos(AXIS_Y,IniSettings::GetInstance()->getValue(IniType::motion_vel).toDouble(),focusY,
                                           IniSettings::GetInstance()->getValue(IniType::motion_acc).toDouble(),
                                           IniSettings::GetInstance()->getValue(IniType::motion_dec).toDouble()
                                           )){
        unexpectExit(-1,tr("A3200 move failed!"));
        return;
    }
    A3200Api::GetInstance()->WaitAxisStop(AXIS_Y);

    if(!A3200Api::GetInstance()->MoveToPos(AXIS_Z,IniSettings::GetInstance()->getValue(IniType::motion_vel).toDouble(),focusZ,
                                           IniSettings::GetInstance()->getValue(IniType::motion_acc).toDouble(),
                                           IniSettings::GetInstance()->getValue(IniType::motion_dec).toDouble()
                                           )){
        unexpectExit(-1,tr("A3200 move failed!"));
        return;
    }
    A3200Api::GetInstance()->WaitAxisStop(AXIS_Z);

    timer.start();

    if(!setFixtrue1(false)){
        unexpectExit(-1,tr("set fixtrue1 failed!"));
        return;
    }
    if(!setFixtrue2(false)){
        unexpectExit(-1,tr("set fixtrue2 failed!"));
        return;
    }

    if(isGas)
        StateHandler::GetInstance()->setOutput(Output::N2_on_off,true);
    else
        StateHandler::GetInstance()->setOutput(Output::N2_on_off,false);

    if(isInterruptionRequested()){
        unexpectExit(-5,"");
        return;
    }

    QThread::msleep(1000);
    bool conditon=true;
    for(long m=0;m<count;++m){
        conditon=true;
        if(isInterruptionRequested()){

            unexpectExit(-5,"");
            return;
        }
        if(A3200Api::GetInstance()->RunProgram(const_cast<char*>(runPath.toStdString().data()),1)){
            do
            {
                if(isInterruptionRequested()){
                    unexpectExit(-5,"");
                    return;
                }
                QThread::msleep(20);
                switch (A3200Api::GetInstance()->GetProgramStatus()){
                case 0:{
                    unexpectExit(-1,tr("A3200: The Professional Option is not installed.\nYou cannot use this task!"));
                    return;
                }
                case 1:{
                    unexpectExit(-1,tr("A3200: This task was disabled by the EnabledTasks parameter."));
                    return;
                }
                case 2:{
                    unexpectExit(-1,tr("A3200: No program is associated or running."));
                    return;
                }
                case 3:{//ProgramReady
                    continue;
                }
                case 4:{//ProgramRunning
                    continue;
                }
                case 5:{//ProgramFeedheld
                    continue;
                }
                case 6:{//ProgramPause
                    continue;
                }
                case 7:{//ProgramCompleted
                    conditon=false;
                    break;
                }
                case 8:{//ProgramError
                    unexpectExit(-1,tr("A3200: A task error occurred on this task."));
                    return;
                }
                case 9:{//taskQueue
                    unexpectExit(-1,tr("A3200: This task is running in queue mode."));
                    return;
                }
                default:{
                    unexpectExit(-1,tr("A3200: unknown error!"));
                    return;
                  }
                }
            }
            while(conditon);
            A3200Api::GetInstance()->WaitAllAxisStop();

            if(count-m!=1){//last once
                if(!setFixtrue2(true)){
                    unexpectExit(-1,tr("set fixtrue2 failed!"));
                    return;
                }
                if(isInterruptionRequested()){
                    unexpectExit(-5,"");
                    return;
                }
                QThread::msleep(500);
                if(!setFixtrue1(true)){
                    unexpectExit(-1,tr("set fixtrue1 failed!"));
                    return;
                }

                if(isInterruptionRequested()){
                    unexpectExit(-5,"");
                    return;
                }
                QThread::msleep(800);
                if(A3200Api::GetInstance()->MoveIncStep(AXIS_X,IniSettings::GetInstance()->getValue(IniType::motion_vel).toDouble(),step,
                                                        IniSettings::GetInstance()->getValue(IniType::motion_acc).toDouble(),
                                                        IniSettings::GetInstance()->getValue(IniType::motion_dec).toDouble())){
                    unexpectExit(-1,tr("A3200 move failed!"));
                    return;
                }
                A3200Api::GetInstance()->WaitAxisStop(1);
                QThread::msleep(100);

                if(!setFixtrue1(false)){
                    unexpectExit(-1,tr("set fixtrue1 failed!"));
                    return;
                }

                if(isInterruptionRequested()){
                    unexpectExit(-5,"");
                    return;
                }
                QThread::msleep(500);
                if(!setFixtrue2(false)){
                    unexpectExit(-1,tr("set fixtrue2 failed!"));
                    return;
                }
            }
        }
        else{
            unexpectExit(-1,tr("start A3200 program error!"));
            return;
        }

    }
    if(isAutoBack)
        MainWindow::GetInstance()->moveToWait();

    runCompleted(tr("processing completed!"));
    return;
}

MainWindow* MainWindow::m_pInstance = nullptr;

MainWindow *MainWindow::GetInstance()
{
    if(m_pInstance == nullptr)
    {
        m_pInstance = new MainWindow();
        atexit(Release);
    }
    return m_pInstance;
}
void MainWindow::Release()
{
    if(m_pInstance)
    {
        delete m_pInstance;
        m_pInstance = nullptr;
    }
}


MainWindow::MainWindow(QObject *parent) : QObject(parent)
{
    program=new ProgramIO(this);
    programFilePath="untitled";
    programRunPath=QStandardPaths::writableLocation(QStandardPaths::TempLocation)+"/hjlA3200temp"+".PGM";

    isModify=false;

    run=new RunProgram(this);
    connect(run, &QThread::finished, this, [=](){emit programEnded();});
    connect(run,&RunProgram::_runDone,this,[=](int msgType,QString msg){
        emit programDone(msgType,msg);
    });

    connect(Translator::inst(),&Translator::languageChanged,this,[=](QString str){emit languageChanged(str);});

    //    HVideo::GetInstance()->startRecord("D:/test.mkv");
    //    QImage *image=new QImage;
    //    image->load("C:/Users/hjl_s/Pictures/1.bmp");
    //    QTimer *timer = new QTimer;
    //    connect(timer, &QTimer::timeout, this, [=](){HVideo::GetInstance()->writeData(*image);});
    //    timer->start(10);
}

MainWindow::~MainWindow()
{
    laseroff();
    delete run;
    delete program;
}
#include <QDebug>
void MainWindow::setValue(long long index, QString value)
{

    program->hashInfo.insert(index,value);
}


QString MainWindow::getValue(long long index)
{
    return program->hashInfo.value(index);
}


int MainWindow::newProgram()
{
    if(isModify){
        QMessageBox::StandardButton button;
        button=QMessageBox::question(nullptr,tr("Warning"),tr("change of program is not saved ,save it now?"),QMessageBox::Yes|QMessageBox::No|QMessageBox::Cancel);
        if(button==QMessageBox::No)
        {
            program->hashInfo.clear();
            programFilePath="untitled";
            isModify=false;
            emit programChanged(programFilePath);
            return 0;
        }
        else if(button==QMessageBox::Yes)
        {
            return 1;
        }
        else if(button==QMessageBox::Cancel)
        {
            return -1;
        }
        else{
            return -1;
        }
    }
    else{
        program->hashInfo.clear();
        programFilePath="untitled";
        isModify=false;
        emit programChanged(programFilePath);
        return 0;
    }

}

bool MainWindow::saveProgram()
{
    if(!(programFilePath=="untitled")){
        isModify=false;
    }
    else{
        QString fileName= QFileDialog::getSaveFileName(nullptr, tr("Save Laser Program File"),nullptr,tr("HLaser Program(*.hpro)"));
        if (fileName.isEmpty())
            return false;
        isModify=false;
        programFilePath=fileName;
    }
    emit programChanged(programFilePath);
    return  program->writeFile(programFilePath);
}

bool MainWindow::saveProgramAs()
{
    QSettings settings("AOC", "userData");
    QString fileName= QFileDialog::getSaveFileName(nullptr, tr("Laser Program File"),settings.value("Laser/programDefaultSaveDir").toString(),tr("HLaser Program(*.hpro)"));
    if (fileName.isEmpty()){

        return false;
    }
    isModify=false;
    settings.setValue("Laser/programDefaultSaveDir", fileName);
    return  program->writeFile(fileName);
}

void MainWindow::openProgramFile(QString filepath)
{

    emit to_openProgram(filepath);
    //    if (filepath.isEmpty())
    //        return false;

    //    bool flag=program->readFile(filepath);
    //    if(flag){

    //        programFilePath=filepath;
    //        emit programChanged(programFilePath);
    //    }
    //    isModify=false;
    //    return  flag;
}

bool MainWindow::openProgram()
{
    QSettings settings("AOC", "userData");
    QString fileName= QFileDialog::getOpenFileName(nullptr, tr("Laser Program File"),settings.value("Laser/programDefaultOpenDir").toString(),tr("HLaser Program(*.hpro)"));
    if (fileName.isEmpty())
        return false;

    bool flag=program->readFile(fileName);
    if(flag){
        settings.setValue("Laser/programDefaultOpenDir", fileName);

        programFilePath=fileName;
        emit programChanged(programFilePath);
    }
    isModify=false;
    return  flag;
}

bool MainWindow::openProgramPath(QString path)
{
    QSettings settings("AOC", "userData");
    if (path.isEmpty())
        return false;

    bool flag=program->readFile(path);
    if(flag){
        settings.setValue("Laser/programDefaultOpenDir", path);

        programFilePath=path;
        emit programChanged(programFilePath);
    }
    isModify=false;
    return  flag;
}

bool MainWindow::laserOn()
{
    QString code="PSOOUTPUT Theta CONTROL 0 1\nLASER_ON\nEND PROGRAM";
    QString filepath=QStandardPaths::writableLocation(QStandardPaths::TempLocation)+"/hjlA3200LaserOnoff"+".PGM";
    QFile file(filepath);

    if (!file.open(QFile::WriteOnly|QFile::Text)){
        return false;
    }

    QTextStream out(&file);
    out << code;
    file.close();
    return A3200Api::GetInstance()->RunProgram(const_cast<char*>(filepath.toStdString().data()),2);
}

bool MainWindow::laseroff()
{
    QString code="PSOOUTPUT Theta CONTROL 0 1\nLASER_OFF\nEND PROGRAM";
    QString filepath=QStandardPaths::writableLocation(QStandardPaths::TempLocation)+"/hjlA3200LaserOnoff"+".PGM";
    QFile file(filepath);
    if (!file.open(QFile::WriteOnly|QFile::Text)){
        return false;
    }
    QTextStream out(&file);
    out << code;
    file.close();
    return A3200Api::GetInstance()->RunProgram(const_cast<char*>(filepath.toStdString().data()),2);
}

void MainWindow::setNew()
{
    programFilePath="untitled";
    isModify=false;
    emit programChanged(programFilePath);
}



void MainWindow::isModified(bool value)
{
    isModify=value;
}

void MainWindow::switchStyle(QString name)
{
    IniSettings::GetInstance()->setValue(IniType::view_style,name);
}

QString MainWindow::getStyle()
{
    return IniSettings::GetInstance()->getValue(IniType::view_style);
}

void MainWindow::setLanguage(QString value)
{
    Translator::inst()->loadLanguage(value);
    IniSettings::GetInstance()->setValue(IniType::view_lang,value);
}

QString MainWindow::getLanguage()
{
    return IniSettings::GetInstance()->getValue(IniType::view_lang);
}



bool MainWindow::runProgram()
{

    if(StateHandler::GetInstance()->isWarning){
        emit programDone(-1,tr("device is warning please check!"));
        return false;
    }

    laseroff();

    QString code=program->hashInfo.value(ParaType::A3200Code);
    run->count=program->hashInfo.value(ParaType::Flow_processCount).toLong();
    run->step=program->hashInfo.value(ParaType::Flow_processLength).toDouble();
    run->ischeckTube=program->hashInfo.value(ParaType::Flow_checkTube).toLong();
    run->isAutoBack=IniSettings::GetInstance()->getValue(IniType::isAutoback).toInt();
    run->waitY=IniSettings::GetInstance()->getValue(IniType::position_wait_y).toDouble();
    run->waitZ=IniSettings::GetInstance()->getValue(IniType::position_wait_z).toDouble();
    // run->isLaser=program->hashInfo.value(ParaType::FlowSTART_openlaser).toLong();
    run->isGas=program->hashInfo.value(ParaType::Flow_useGas).toLong();
    run->iscloseDoor=program->hashInfo.value(ParaType::Flow_closeDoor).toLong();
    run->focusY=program->hashInfo.value(ParaType::Flow_Focus_Y).toDouble();
    run->focusZ=program->hashInfo.value(ParaType::Flow_Focus_Z).toDouble();

    run->runPath=programRunPath;
    //    run->mcs=program->hashInfo.value(ParaType::LaserSTART_mcs).toLong();
    //    run->prf=program->hashInfo.value(ParaType::Laser_prf).toLong()*1000;
    //    run->t1s=program->hashInfo.value(ParaType::LaserOVER_T1S).toLong();
    //    run->psn=program->hashInfo.value(ParaType::Laser_psn).toLong();



    QFile file(programRunPath);
    if (!file.open(QFile::WriteOnly|QFile::Text)){
        emit programDone(-1,tr("A3200: program file opened failed!"));
        return false;
    }

    QTextStream out(&file);
    out << code;
    file.close();



    if(A3200Api::GetInstance()->LoadProgram(const_cast<char*>(programRunPath.toStdString().data()))){
        run->start();
        return true;
    }
    else{
        emit programDone(-1,tr("A3200: program loaded failed!"));
        return false;
    }
}

bool MainWindow::pauseProgram()
{
    if(run->isRunning()){
        if(A3200Api::GetInstance()->GetProgramStatus()==4){
            if(A3200Api::GetInstance()->PauseProgramAndWait(ULONG_MAX)){
                run->sleep(ULONG_MAX);
                return true;
            }
        }
        else{
            return false;
        }
        run->sleep(ULONG_MAX);
    }
    return false;
}

bool MainWindow::continueProgram()
{
    return false;
}

bool MainWindow::stopProgram()
{

    run->requestInterruption();
    run->quit();
    run->lastM.lock();
    run->note.lastNote=tr("processing termination!");
    run->note.type=1;
    run->lastM.unlock();
    return run->wait(5000);
}


void MainWindow::moveToWait()
{
    A3200Api::GetInstance()->MoveToPos(Axis::AXIS_Z,IniSettings::GetInstance()->getValue(IniType::motion_vel).toDouble(),
                                       IniSettings::GetInstance()->getValue(IniType::position_wait_z).toDouble(),
                                       IniSettings::GetInstance()->getValue(IniType::motion_acc).toDouble(),
                                       IniSettings::GetInstance()->getValue(IniType::motion_dec).toDouble());
    A3200Api::GetInstance()->WaitAxisStop(AXIS_Z);

    A3200Api::GetInstance()->MoveToPos(Axis::AXIS_Y,IniSettings::GetInstance()->getValue(IniType::motion_vel).toDouble(),
                                       IniSettings::GetInstance()->getValue(IniType::position_wait_y).toDouble(),
                                       IniSettings::GetInstance()->getValue(IniType::motion_acc).toDouble(),
                                       IniSettings::GetInstance()->getValue(IniType::motion_dec).toDouble());

    //    A3200Api::GetInstance()->MoveToPos(Axis::AXIS_X,IniSettings::GetInstance()->getValue(IniType::motion_vel).toDouble(),
    //                                       IniSettings::GetInstance()->getValue(IniType::position_start_x).toDouble(),
    //                                       IniSettings::GetInstance()->getValue(IniType::motion_acc).toDouble(),
    //                                       IniSettings::GetInstance()->getValue(IniType::motion_dec).toDouble());

    //    A3200Api::GetInstance()->MoveToPos(Axis::AXIS_THETA,IniSettings::GetInstance()->getValue(IniType::motion_vel).toDouble(),
    //                                       IniSettings::GetInstance()->getValue(IniType::position_start_theta).toDouble(),
    //                                       IniSettings::GetInstance()->getValue(IniType::motion_acc).toDouble(),
    //                                       IniSettings::GetInstance()->getValue(IniType::motion_dec).toDouble());
    A3200Api::GetInstance()->WaitAllAxisStop();

}

void MainWindow::moveToFocus()
{

    A3200Api::GetInstance()->MoveToPos(Axis::AXIS_Y,IniSettings::GetInstance()->getValue(IniType::motion_vel).toDouble(),
                                       program->hashInfo.value(ParaType::Flow_Focus_Y).toDouble(),
                                       IniSettings::GetInstance()->getValue(IniType::motion_acc).toDouble(),
                                       IniSettings::GetInstance()->getValue(IniType::motion_dec).toDouble());
    A3200Api::GetInstance()->WaitAxisStop(AXIS_Y);

    A3200Api::GetInstance()->MoveToPos(Axis::AXIS_Z,IniSettings::GetInstance()->getValue(IniType::motion_vel).toDouble(),
                                       program->hashInfo.value(ParaType::Flow_Focus_Z).toDouble(),
                                       IniSettings::GetInstance()->getValue(IniType::motion_acc).toDouble(),
                                       IniSettings::GetInstance()->getValue(IniType::motion_dec).toDouble());
    A3200Api::GetInstance()->WaitAxisStop(AXIS_Z);


}



bool MainWindow::switchSystem(bool isMain)
{
    if(isMain){
        if(StateHandler::GetInstance()->setOutput(Output::Switch_system,false)){

            //            QEventLoop loop;
            //            QTimer::singleShot(3000, &loop, SLOT(quit()));
            //            loop.exec();
            QThread::msleep(2000);
            //LaserUI::GetInstance()->reconnectLaser();
            if(GtMotion::GetInstance()->MoveTo(1,15,0))
                if(GtMotion::GetInstance()->waitAxisStop(1)){
                    return true;
                }
        }
    }
    else{
        if(GtMotion::GetInstance()->MoveTo(1,15,IniSettings::GetInstance()->getValue(IniType::lightSwitch_pos).toDouble()))
            if(GtMotion::GetInstance()->waitAxisStop(1)){
                //LaserUI::GetInstance()->closeSerial();
                StateHandler::GetInstance()->setOutput(Output::Switch_system,true);
                return true;
            }
    }
    return false;
}

bool MainWindow::switchLaser(bool isGreen)
{
    return StateHandler::GetInstance()->setOutput(Output::Lightpath_switch,!isGreen);
}

bool MainWindow::exitApp()
{
    if(run->isRunning()){
        QMessageBox::StandardButton button;

        button=QMessageBox::question(nullptr,tr("Warning"),tr("process is running now,exit application will terminate process,\nsure to exit?"),QMessageBox::Yes|QMessageBox::Cancel);

        if(button==QMessageBox::Yes)
        {
            run->requestInterruption();
            run->wait();
            run->quit();
            StateHandler::GetInstance()->unInit();
            return true;
        }
        else if(button==QMessageBox::Cancel)
        {
            return false;
        }
        else {
            return false;
        }
    }
    StateHandler::GetInstance()->unInit();
    return true;
}

