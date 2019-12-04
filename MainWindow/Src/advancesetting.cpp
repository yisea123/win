#include "advancesetting.h"
#include <QCoreApplication>

#include "stcamera.h"

AdvanceSetting::AdvanceSetting(QObject *parent) : QObject(parent)
{

//    connect(stCamera,&QProcess::started,this,[=](){emit StCamera::GetInstance()->cameraStataus(1,false);});
//    connect(stCamera,&QProcess::errorOccurred,this,[=](){emit StCamera::GetInstance()->cameraStataus(1,true);});
    stCamera=new QProcess(this);
    avCamera=new QProcess(this);
    a3200=new QProcess(this);
    connect(stCamera,QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            [=](int exitCode, QProcess::ExitStatus exitStatus){ StCamera::GetInstance()->openCamera();emit StCamera::GetInstance()->cameraStataus(1,true);});

    connect(avCamera,QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            [=](int exitCode, QProcess::ExitStatus exitStatus){StCamera::GetInstance()->openavCamera();emit StCamera::GetInstance()->cameraStataus(0,true);});
//    connect(avCamera,&QProcess::started,this,[=](){emit StCamera::GetInstance()->cameraStataus(0,false);});
    //    connect(avCamera,&QProcess::errorOccurred,this,[=](){emit StCamera::GetInstance()->cameraStataus(0,true);});
}

AdvanceSetting::~AdvanceSetting()
{
    delete stCamera;
    delete avCamera;
    delete a3200;
}

bool AdvanceSetting::openStCamera()
{

    StCamera::GetInstance()->closeCamera();
    QStringList para;
    para<<" ";

    stCamera->start(QCoreApplication::applicationDirPath()+"/StCamera/StCamSWare.exe",para);

    bool a=stCamera->waitForStarted(5000);
    emit StCamera::GetInstance()->cameraStataus(1,!a);
    return a;

}

bool AdvanceSetting::openAVCamera()
{
    StCamera::GetInstance()->closeavCamera();
    QStringList para;
    para<<"USB Camera DMC-1213";
    avCamera->start(QCoreApplication::applicationDirPath()+"/Camera.exe",para);

    bool a=avCamera->waitForStarted(5000);

    emit StCamera::GetInstance()->cameraStataus(0,!a);
    return a;
}

bool AdvanceSetting::openA3200()
{
    a3200=new QProcess(this);
    a3200->start("D:/Program Files (x86)/STcamera/StCamSWare.exe",QStringList("D:/Program Files (x86)/STcamera/StCamSWare.exe"));
    return a3200->waitForStarted(5000);
}
