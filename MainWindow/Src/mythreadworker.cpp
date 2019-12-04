#include "mythreadworker.h"
#include "GtMotion.h"
#include "A3200Api.h"
#include <QCameraInfo>
#include <QCamera>
//#include <QDebug>
#include <QEventLoop>
#include <QTimer>
#include <QCoreApplication>
#include <QTime>

MyThreadWorker* myThread=nullptr;
MyThreadWorker::MyThreadWorker(QObject *parent) : QObject(parent)
{
    setAutoDelete(false);
    pool.setMaxThreadCount(100);
}

void MyThreadWorker::starthomeAll()
{
    if(myMutex.tryLock()){
        funcIndex=MyFuncIndex::type_homeAll;
        pool.start(this);
        myMutex.unlock();
    }
}

void MyThreadWorker::startmoveToPos(short htype, short haxisIndex, double hvel, double hpos)
{
    if(myMutex.tryLock()){
        type=htype;
        axisIndex=haxisIndex;
        vel=hvel;
        pos=hpos;
        funcIndex=MyFuncIndex::type_moveToPos;
        pool.start(this);
        myMutex.unlock();
    }
}



void MyThreadWorker::starthomeAxis(short haxisIndex)
{
    if(myMutex.tryLock()){
        axisIndex=haxisIndex;
        funcIndex=MyFuncIndex::type_homeAxis;
        pool.start(this);
        myMutex.unlock();
    }


}

void MyThreadWorker::startInitCamera()
{
    if(myMutex.tryLock()){
        funcIndex=MyFuncIndex::type_initCamera;
        pool.start(this);
        myMutex.unlock();
    }
}

void MyThreadWorker::startInitA3200()
{
    if(myMutex.tryLock()){
        funcIndex=MyFuncIndex::type_initA3200;
        pool.start(this);
        myMutex.unlock();
    }

}

void MyThreadWorker::startInitGTS()
{
    if(myMutex.tryLock()){
        funcIndex=MyFuncIndex::type_initGTS;
        pool.start(this);
        myMutex.unlock();
    }

}

void MyThreadWorker::startInitLaser()
{
    if(myMutex.tryLock()){
        funcIndex=MyFuncIndex::type_initLaser;
        pool.start(this);
        myMutex.unlock();
    }

}

void MyThreadWorker::run()
{

    switch (funcIndex) {
    case type_homeAll:{
        thread_homeAll();
        break;
    }
    case type_homeAxis:{
        thread_homeAxis();
        break;
    }
    case type_initA3200:{
        thread_initA3200();
        break;
    }
    case type_initCamera:{
        thread_initCamera();
        break;
    }
    case type_initGTS:{
        thread_initGTS();
        break;
    }
    case type_initLaser:{
        thread_initLaser();
        break;
    }
    case type_moveToPos:{
        thread_moveToPos();
        break;
    }

    }
    //    qDebug() << tr("PrintTask run 被调用，调用线程ID为：") << QThread::currentThread() << QTime::currentTime()<<a;
    //   QThread::sleep(1);
}

void MyThreadWorker::thread_homeAll()
{
    bool flag=false;
    if(A3200Api::GetInstance()->HomeAllAxis())
        if(GtMotion::GetInstance()->HomeCapt(1,200,4)){
            flag=true;
        }
    emit homeAllDone(flag);
}

void MyThreadWorker::thread_moveToPos()
{
    bool flag=false;
    //    double pos1=0;
    //    if(axisIndex!=4){
    //        if(type==0)
    //            flag=A3200Api::MoveToPos(static_cast<unsigned short>(axisIndex),vel,pos);
    //        if(type==1){
    //            A3200Api::GetFeedBackPos(static_cast<unsigned short>(axisIndex),pos1);
    //            flag=A3200Api::MoveToPos(static_cast<unsigned short>(axisIndex),vel,pos1+pos);
    //        }
    //        flag=A3200Api::WaitAxisStop(static_cast<unsigned short>(axisIndex));
    //    }
    //    else{
    //        //qDebug()<<axisIndex<<vel<<pos;
    //        if(type==0)
    //            flag=GtMotion::MoveTo(axisIndex,vel,pos);
    //        if(type==1){
    //            GtMotion::GetCurPosMM(axisIndex,pos1);
    //            flag=GtMotion::MoveTo(short(axisIndex),vel,pos+pos1);
    //        }
    //    }
    short a=axisIndex;
    qDebug()<<axisIndex<<123;
    QThread::sleep(5);

    flag=axisIndex%2==0?true:false;
    emit moveDone(a,flag);
}

void MyThreadWorker::thread_homeAxis()
{
    //CreateThread(NULL, 0, ThreadFun, &axisIndex, 0, NULL);


    int code=-2;
    if(axisIndex!=4){

        if(A3200Api::GetInstance()->clearAllError()){

            //            QEventLoop loop;
            //            QTimer::singleShot(100, &loop, SLOT(quit()));
            //            loop.exec();
            QThread::msleep(100);

            code=1;
            if(A3200Api::GetInstance()->HomeAxis(axisIndex)){

                code=0;
            }}

    }
    else{
        //qDebug()<<QCoreApplication::applicationDirPath()+"/gts/cardConfig.cfg";
        if(GtMotion::GetInstance()->Init(QCoreApplication::applicationDirPath()+"/gtsMotion/cardConfig.cfg",1,1))
        {
            code=1;
            if(GtMotion::GetInstance()->SetTrapPrm(1,0.25,0.125,25)){
                code=2;
                if(GtMotion::GetInstance()->HomeCapt(1,200,4))
                    code= 0;
                else{
                    code=3;
                }
            }
        }

    }

    emit homeDone(axisIndex,code);
}

void MyThreadWorker::thread_initCamera()
{
    int code=-2;
    const QString camera1 ="STC-MB33USB(18A3618)", camera2="USB Camera DMC-1213";
    const QList<QCameraInfo> availableCameras = QCameraInfo::availableCameras();
    QStringList descr;
    foreach (QCameraInfo a,availableCameras) {
        descr<<a.description();
    }

    if(descr.contains(camera1))
        code=2;
    if(descr.contains(camera2)){
        if(code==2)
            code= 0;
        else
            code=1;}

    emit initCameraDone(code);
    pool.releaseThread();
}

void MyThreadWorker::thread_initA3200()
{
    int code=-2;
    if(A3200Api::GetInstance()->InitMotionController()){
        code=1;

        if(A3200Api::GetInstance()->EnableAllAxis()){

            //A3200Api::HomeAllAxis();
            code= 0;}}
    emit initA3200Done(code);
}

void MyThreadWorker::thread_initGTS()
{
    int code=-2;
    //qDebug()<<QCoreApplication::applicationDirPath()+"/gts/cardConfig.cfg";
    if(GtMotion::GetInstance()->Init(QCoreApplication::applicationDirPath()+"/gtsMotion/cardConfig.cfg",1,1))
    {
        code=1;
        if(GtMotion::GetInstance()->SetTrapPrm(1,0.25,0.125,25)){
            //GtMotion::HomeCapt(1,200,4);
            code= 0;
        }
    }
    emit initGTSDone(code);
}

void MyThreadWorker::thread_initLaser()
{
//    HSerialportLaser laser;
//    int code=-3;
//    if(laser.InitSerialport()){
//        code=-2;
//        if(laser.connectSerial("COM1")){

//            laser.writeData("?STA\n");

//            //for delay
//            QEventLoop loop2;
//            QTimer::singleShot(1000, &loop2, SLOT(quit()));
//            loop2.exec();

//            qDebug()<<laser.lastReadData;

//            if(laser.lastReadData.toInt()==104){
//                 laser.writeData("?ADC\n");

//                 QEventLoop loop2;
//                 QTimer::singleShot(1000, &loop2, SLOT(quit()));
//                 loop2.exec();

//                 if(laser.lastReadData.toInt()==1)
//                    code=0;
//                 else if(laser.lastReadData.toInt()==0){
//                     QTimer::singleShot(1200000, &loop2, SLOT(quit()));
//                     loop2.exec();
//                 }

//            }
//        }
//    }

//    emit initLaserDone(code);
}
