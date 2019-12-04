#include "deviceinit.h"
//#include "mythreadworker.h"
#include <QCoreApplication>
#include "A3200Api.h"
#include "GtMotion.h"
#include "hserialportlaser.h"
#include <QCameraInfo>
#include <QCamera>
#include <QDebug>
#include <QMessageBox>
#include <QTimer>
#include <QTime>
#include "StTrgApi.h"



int DeviceInit::isEXIT=0;

CameraInit::CameraInit(QObject *parent): QObject(parent)
{

}

void CameraInit::run()
{

    const QString camera1 ="STC-MB33USB(18A3618)", camera2="USB Camera DMC-1213";
    const QList<QCameraInfo> availableCameras = QCameraInfo::availableCameras();
    QStringList descr;
    foreach (QCameraInfo a,availableCameras) {
        descr<<a.description();
    }

    if(descr.contains(camera1)&&descr.contains(camera2)){
        HANDLE hCamera = INVALID_HANDLE_VALUE;
        hCamera = StTrg_Open();
        if(INVALID_HANDLE_VALUE == hCamera)
        {
            emit _CameraInitDone(false);//open failed
            return;
        }

        if(!StTrg_StartTransfer(hCamera))
        {
            emit _CameraInitDone(false);//"Couldn't Start.\n"
            return;

        }
        WORD  wScanMode;
        DWORD  dwOffsetX;
        DWORD  dwOffsetY;
        DWORD  dwWidth;
        DWORD  dwHeight;
        if(!StTrg_GetScanMode(hCamera, &wScanMode, &dwOffsetX, &dwOffsetY, &dwWidth , &dwHeight))
        {
            emit _CameraInitDone(false);//"Couldn't get ScanMode.\n
            return;

        }

        DWORD  dwTransferBitsPerPixel;
        if(!StTrg_GetTransferBitsPerPixel(hCamera, &dwTransferBitsPerPixel))
        {
            emit _CameraInitDone(false); //"Couldn't get TransferBitsPerPixel.\n
            return;
        }

        switch(dwTransferBitsPerPixel)
        {
        case(STCAM_TRANSFER_BITS_PER_PIXEL_RAW_08):
        case(STCAM_TRANSFER_BITS_PER_PIXEL_RAW_10):
        case(STCAM_TRANSFER_BITS_PER_PIXEL_RAW_12):
            break;
        default:
            emit _CameraInitDone(false);  //"Not expected TransferBitsPerPixel value.
            return;
        }

        WORD wColorArray = 0;
        if(!StTrg_GetColorArray(hCamera, &wColorArray))
        {
            emit _CameraInitDone(false);//"Couldn't get ColorArray.
            return;
        }
        if(!StTrg_StopTransfer(hCamera))
        {
            emit _CameraInitDone(false);//"Can't Stop.\n"
            return;
        }

        StTrg_Close(hCamera);
        emit _CameraInitDone(true);
        return;
    }

    emit _CameraInitDone(false);
    return;

}

LaserInit::LaserInit( QObject *parent) : QObject(parent)
{

}

void LaserInit::run()
{

    emit _LaserInitDone(false);
    return;
}


A3200Init::A3200Init(QObject *parent) : QObject(parent)
{

}

void A3200Init::run()
{

    if(A3200Api::GetInstance()->InitMotionController()){
        if(A3200Api::GetInstance()->EnableAllAxis()){
            bool st[4]={0,0,0,0};
            bool flag=false;
            for(unsigned short k=0;k<4;++k){
                st[k]=A3200Api::GetInstance()->isAxisHomed(k);
                if(!st[k]){
                    flag=true;
                }
            }

            if(flag){
                QStringList a;
                a<<(st[0]?"":"theta")<<(st[1]?"":"X")<<(st[2]?"":"Y")<<(st[3]?"":"Z");
                QString str=a.join(",");
                if(emit isHome(str))
                {
                    for(int f=3;f>=0;--f){
                        if(!st[f])
                            if(!A3200Api::GetInstance()->HomeAxis(static_cast<unsigned short>(f))){
                                emit _A3200InitDone(false);
                                return;
                            }
                    }
                    emit _A3200InitDone(true);
                    return;
                }
            }
        }
    }
    emit _A3200InitDone(false);
    return;
}



GtsInit::GtsInit( QObject *parent) : QObject(parent)
{


}


void GtsInit::run()
{
    //qDebug()<<QCoreApplication::applicationDirPath()+"/gts/cardConfig.cfg";
    if(GtMotion::GetInstance()->Init(QCoreApplication::applicationDirPath()+"/gtsMotion/cardConfig.cfg",1,1)){
        if(GtMotion::GetInstance()->SetTrapPrm(1,0.5,0,0.125,20)){
            if(GtMotion::GetInstance()->HomeCapt(1,15,15)){
                emit _GtsInitDone(true);
                return;
            }
        }
    }
    emit _GtsInitDone(false);
    return;
}


DeviceInit::DeviceInit(QObject *parent) : QObject(parent)
{
    //    connect(myThread, &MyThreadWorker::initCameraDone, this, [=](int code){
    //        emit cameraInitCompleted(code);
    //    });

    //    connect(myThread, &MyThreadWorker::initA3200Done, this, [=](int code){
    //        emit a3200InitCompleted(code);
    //    });

    //    connect(myThread, &MyThreadWorker::initGTSDone, this, [=](int code){
    //        emit gtsInitCompleted(code);
    //    });

    //    connect(myThread, &MyThreadWorker::initLaserDone, this, [=](int code){
    //        emit laserInitCompleted(code);
    //    });

    //HSerialportLaser::GetInstance();

//    connect(HSerialportLaser::GetInstance(),&HSerialportLaser::responseData,this,[=](QString s){
//        if(s=="REMOTE\r\n"){
//            HSerialportLaser::GetInstance()->requestData("?STA\r\n");
//        }
//        else if(s=="ERROR\r\n"){
//            int k=0;
//            while (k<30) {
//                ++k;
//                QEventLoop loop;
//                QTimer::singleShot(1000, &loop, SLOT(quit()));
//                loop.exec();
//                if(s=="REMOTE\r\n"){
//                    HSerialportLaser::GetInstance()->requestData("?STA\r\n");
//                    break;
//                }
//                else if(s=="ERROR\r\n"){
//                    HSerialportLaser::GetInstance()->requestData("MCH=1\r\n");
//                    continue;
//                }
//                else{
//                    emit laserInitCompleted(false,tr(" error code:")+s.remove("\r\n"));
//                    return;
//                }
//            }
//            emit laserInitCompleted(true,tr(" return code: wait time out!!)"));
//            return;
//        }
//        else if(s=="000104\r\n"){
//            emit laserInitCompleted(true,tr(" return code:")+s.remove("\n"));
//            return;
//        }
//        else{
//            emit laserInitCompleted(false,tr(" error code:")+s.remove("\n"));
//            return;
//        }
//    });

//    connect(HSerialportLaser::GetInstance(),&HSerialportLaser::errorData,this,[=](QString s){
//        emit laserInitCompleted(false,s.remove("\n"));

//    });

//    connect(HSerialportLaser::GetInstance(),&HSerialportLaser::timeOutData,this,[=](QString s){
//        emit laserInitCompleted(false,s.remove("\n"));

//    });

    pool.setMaxThreadCount(20);

}

DeviceInit::~DeviceInit()
{

}

void DeviceInit::exitApp()
{
    this->deleteLater();
    isEXIT=1;
}

void DeviceInit::initDone()
{
    this->deleteLater();
}

void DeviceInit::initCamera()
{
    CameraInit *camera=new CameraInit;
    connect(camera,&CameraInit::_CameraInitDone,this,[=](bool isSucceed){
        emit cameraInitCompleted(isSucceed);
    });
    pool.start(camera);

    //QTimer::singleShot(10,myThread,&MyThreadWorker::startInitCamera);
}


void DeviceInit::initA3200()
{
    A3200Init *a3200=new A3200Init;
    connect(a3200,&A3200Init::_A3200InitDone,this,[=](bool isSucceed){
        emit a3200InitCompleted(isSucceed);
    });

    connect(a3200, &A3200Init::isHome, this, [=](QString str){
        QMessageBox::StandardButton button;

        button=QMessageBox::question(nullptr,tr("Warning"),tr("Axis ")+str+tr(" is not homed,homing now?"),QMessageBox::Yes|QMessageBox::No);

        if(button==QMessageBox::Yes)
        {
            return true;
        }
        else if(button==QMessageBox::Cancel)
        {
            return false;
        }
        else {
            return false;
        }
    },Qt::BlockingQueuedConnection);

    a3200->setAutoDelete(true);
    pool.start(a3200);


    //QTimer::singleShot(10,myThread,&MyThreadWorker::startInitA3200);
}


void DeviceInit::initGTS()
{
    //QTimer::singleShot(10,myThread,&MyThreadWorker::startInitGTS);

    GtsInit *gts=new GtsInit;
    connect(gts,&GtsInit::_GtsInitDone,this,[=](bool isSucceed){
        emit gtsInitCompleted(isSucceed);
    });
    gts->setAutoDelete(true);
    pool.start(gts);
}


void DeviceInit::initLaser()
{

    if(!HSerialportLaser::GetInstance()->connectSerial("COM1",1200,"MCH=1\n")){
        emit laserInitCompleted(false,tr("COM1 inexistence!!"));
        return;
    }

}



