#include "motionhandler.h"
#include <QRunnable>
#include "A3200Api.h"
#include "inisettings.h"
#include <QTimer>
#include <QDebug>


void Worker::moveTo(int moveType, unsigned short axisindex, double pos, double vel)
{
    if(moveType==0){
        if(axisindex!=0){
            if(pos<limitArray[(axisindex-1)*2]||pos>limitArray[(axisindex-1)*2+1]){
                emit _moveDone(tr("destination out of senser limit!"),false);
                return;

            }
        }
        if(A3200Api::GetInstance()->MoveToPos(axisindex,
                                              vel,pos,
                                              IniSettings::GetInstance()->getValue(IniType::motion_acc).toDouble(),
                                              IniSettings::GetInstance()->getValue(IniType::motion_dec).toDouble())){
            if( A3200Api::GetInstance()->WaitAxisStop(axisindex)){
                emit _moveDone(tr("point-move done"),true);
                return;
            }
        }
    }
    if(moveType==1){
        double pos1=0;

        if(A3200Api::GetInstance()->GetFeedBackPos(axisindex,pos1)){
            if(axisindex!=0)
                if(pos+pos1<limitArray[(axisindex-1)*2]||pos+pos1>limitArray[(axisindex-1)*2+1]){
                    emit _moveDone(tr("destination out of senser limit!"),false);
                    return;
                }
            if(A3200Api::GetInstance()->MoveToPos(axisindex,
                                                  vel,pos+pos1,
                                                  IniSettings::GetInstance()->getValue(IniType::motion_acc).toDouble(),
                                                  IniSettings::GetInstance()->getValue(IniType::motion_dec).toDouble())){
                if(A3200Api::GetInstance()->WaitAxisStop(axisindex)){
                    emit _moveDone(tr("step-move done"),true);
                    return;
                }
            }
        }
    }
    emit _moveDone(tr("move failed"),false);
    return;
}

void Worker::homeAxis(unsigned short axisindex)
{
    double a=0;
    A3200Api::GetInstance()->GetFeedBackPos(Axis::AXIS_Z,a);
    if(axisindex==2&&a<-16){
        emit _homeDone(tr("position of Z axis is out of safe range!"),false);
        return;
    }
    if(A3200Api::GetInstance()->DisableMotionAxis(axisindex))
        if(A3200Api::GetInstance()->clearAllError())
            if(A3200Api::GetInstance()->EnableMotionAxis(axisindex)){

                QThread::msleep(300);

                if(A3200Api::GetInstance()->HomeAxis(static_cast<unsigned short>(axisindex))){
                    emit _homeDone(tr("axis ")+axisName[axisindex]+tr(" home succeeded!"),true);
                    return;
                }
            }
    emit _homeDone(tr("axis ")+axisName[axisindex]+tr(" home failed!"),false);
    return;

}

void Worker::homeAllAxis()
{
    if(A3200Api::GetInstance()->EnableAllAxis())
        if(A3200Api::GetInstance()->clearAllError())
            if(A3200Api::GetInstance()->HomeAllAxis()){
                emit _homeAllDone(tr("all axises home succeeded!"),true);
                return;
            }
    emit _homeAllDone(tr("motion system home failed!"),false);
    return;
}


MotionHandler::MotionHandler(QObject *parent) : QObject(parent)
{
    Worker *worker = new Worker;
    worker->moveToThread(&workerThread);
    connect(&workerThread, &QThread::finished, worker, &QObject::deleteLater);

    connect(this, &MotionHandler::_startHome, worker, &Worker::homeAxis);
    connect(this, &MotionHandler::_startMove, worker, &Worker::moveTo);
    connect(this, &MotionHandler::_startHomeAll, worker, &Worker::homeAllAxis);

    connect(worker, &Worker::_homeDone, this, [=](QString msg,bool isSucceed){
        emit homeDone(msg,isSucceed);
    });
    connect(worker, &Worker::_moveDone, this, [=](QString msg,bool isSucceed){
        emit moveDone(msg,isSucceed);
    });
    connect(worker, &Worker::_homeAllDone, this, [=](QString msg,bool isSucceed){
        emit homeAllDone(msg,isSucceed);
    });

    workerThread.start();

    //////////////////////////////////////
    QTimer *timer = new QTimer(this);
    connect(timer,&QTimer::timeout,this,[=](){
        static unsigned short index=0;

        double pos=0;
        QString spos="error";

        double vel=0;
        QString svel="error";

        int state=0;

        if(index<3)
            ++index;
        else
            index=0;
        if(A3200Api::GetInstance()->GetFeedBackPos(index,pos))
            spos=QString::number(pos,'f',3);
        if(A3200Api::GetInstance()->GetFeedbackVel(index,vel))
            svel=QString::number(vel,'f',3);
        state=A3200Api::GetInstance()->GetAxisStatus(index);
        emit refreshStatus(index,spos,svel,state);

    });
    timer->start(20);
}

MotionHandler::~MotionHandler()
{
    workerThread.quit();
    workerThread.wait();

}

void MotionHandler::pointMove(unsigned short axisIndex, double pos)
{
    emit _startMove(0,axisIndex,pos,IniSettings::GetInstance()->getValue(IniType::motion_vel).toDouble());
}

void MotionHandler::startMove(int type, unsigned short axisIndex, double pos, double vel)
{

    emit _startMove(type,axisIndex,pos,vel);
}

void MotionHandler::startHome(unsigned short axisIndex)
{
    emit _startHome(axisIndex);
}

void MotionHandler::enableAxis(unsigned short axisIndex,bool value)
{
    value?A3200Api::GetInstance()->EnableMotionAxis(axisIndex):A3200Api::GetInstance()->DisableMotionAxis(axisIndex);
}

void MotionHandler::startHomeAll()
{
    emit _startHomeAll();
}

void MotionHandler::stopMove(unsigned short axisIndex)
{
    A3200Api::GetInstance()->StopAxis(axisIndex);
}

double MotionHandler::getCurrentPos(unsigned short index)
{
    double pos=0;
    A3200Api::GetInstance()->GetFeedBackPos(index,pos);
    return pos;
}


