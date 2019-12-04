#include "laserui.h"
#include "hserialportlaser.h"
#include <QDebug>
#include <QMessageBox>
#include <QEventLoop>
#include <QTimer>

LaserUI* LaserUI::m_pInstance = nullptr;

LaserUI *LaserUI::GetInstance()
{
    if(m_pInstance == nullptr)
    {
        m_pInstance = new LaserUI();
        atexit(Release);
    }
    return m_pInstance;
}
void LaserUI::Release()
{
    if(m_pInstance)
    {
        delete m_pInstance;
        m_pInstance = nullptr;
    }
}

void LaserUI::reconnectLaser()
{
    emit reConnect();
}

bool LaserUI::setLaser(LaserPara type, long data)
{

    QString str;
    switch (type){
    case MCS:
        str="MCS="+QString::number(data)+"\r\n";
        break;
    case T1S:
        str="T1S="+QString::number(data)+"\r\n";
        break;
    case PRF:
        str="PRF="+QString::number(data)+"\r\n";
        break;
    case PSN:
        str="PSN="+QString::number(data)+"\r\n";
        break;
    case SHT:
        str="SHT="+QString::number(data)+"\r\n";
        break;
    }

    value=-1;
    receive="null";

    HSerialportLaser::GetInstance()->requestData(str);
    currentWrite=str.remove("\r\n");

    int k=0;
    while (k<6) {
        ++k;
        QEventLoop loop;
        QTimer::singleShot(200, &loop, SLOT(quit()));
        loop.exec();
        if(value==-1)
            continue;
        else{
            break;
        }
    }

    if(value==data){
        emit valueChanged(type,value);
        return true;
    }
    else
        return false;

}


LaserUI::LaserUI(QObject *parent) : QObject(parent)
{
    currentWrite="null";
    receive="null";
    value=-1;
    connect(HSerialportLaser::GetInstance(),&HSerialportLaser::responseData,this,[=](QString s){
        //qDebug()<<s<<s.length()<<s.toInt();
        if(s.length()==8){
            receive=s;
            value=s.toInt();
            emit showValue(s.remove("\r\n"));
        }
        else if(s.contains("ERROR")){
            receive=s;
            emit showMessage(tr("initializing..."));
            //QMessageBox::question(nullptr,tr("error"),tr(" operate ")+currentWrite+tr(" failed,return error from laser controller."),QMessageBox::Ok);
        }
        else if(s.contains("BUSY")){
            receive=s;
            emit showMessage(s);
            QMessageBox::question(nullptr,tr("error"),tr(" operate ")+currentWrite+tr(" failed,laser controller is busy."),QMessageBox::Ok);
        }
        else if(s.contains("PCOMER")||s.contains("SCOMER")){
            receive=s;
            emit showMessage(s);
            QMessageBox::question(nullptr,tr("error"),tr(" a Serious error occoured in controller.please contact AOC!!!"),QMessageBox::Ok);
        }
        else if(s.contains("ALARM")){
            receive=s;
            emit showMessage(s);
            QMessageBox::question(nullptr,tr("error"),tr(" a warning occoured in controller.please turn off laser power and check!!!"),QMessageBox::Ok);
        }
        else{
            receive=s;
            emit showMessage(s);
        }
    });


    connect(HSerialportLaser::GetInstance(),&HSerialportLaser::errorData,this,[=](QString s){
        receive=s;
        emit showMessage(s);
    });

    connect(HSerialportLaser::GetInstance(),&HSerialportLaser::timeOutData,this,[=](QString s){
        receive=s;
        emit showMessage(s);
    });


}

LaserUI::~LaserUI()
{

}


bool LaserUI::reConnectCom(QString comName, int timeOut, QString str)
{
    value=-1;
    receive="null";
    HSerialportLaser::GetInstance()->connectSerial(comName,timeOut,str);
    int k=0;
    while (k<6) {
        ++k;
        QEventLoop loop;
        QTimer::singleShot(200, &loop, SLOT(quit()));
        loop.exec();
        if(receive=="null"||receive=="ERROR\r\n")
            continue;
        else if(receive=="REMOTE\r\n"){
            return true;
        }
        else{
            return false;
        }
    }
    return false;

}

void LaserUI::writeData(QString data)
{
    HSerialportLaser::GetInstance()->requestData(data,500);
    QEventLoop loop;
    QTimer::singleShot(700, &loop, SLOT(quit()));
    loop.exec();
}



int LaserUI::setValue(QString data)
{
    value=-1;
    receive="null";
    HSerialportLaser::GetInstance()->requestData(data);
    currentWrite=data.remove("\r\n");

    int k=0;
    while (k<6) {
        ++k;
        QEventLoop loop;
        QTimer::singleShot(200, &loop, SLOT(quit()));
        loop.exec();
        if(value==-1)
            continue;
        else{
            return value;
        }
    }
    return value;
}

void LaserUI::closePort()
{
    HSerialportLaser::GetInstance()->closePort();
}

void LaserUI::closeSerial()
{
    emit serialClosed();
}

QStringList LaserUI::getCom()
{
    return HSerialportLaser::GetInstance()->getComArray();

}

bool LaserUI::isConnected()
{
    receive="null";
    value=-1;

    HSerialportLaser::GetInstance()->requestData("MCH=1\r\n");

    int k=0;

    while (k<20) {
        ++k;
        QEventLoop loop;
        QTimer::singleShot(100, &loop, SLOT(quit()));
        loop.exec();
        if(receive=="null"||receive=="ERROR\r\n")
            continue;
        else if(receive=="REMOTE\r\n"){
            return true;
        }
        else{
            return false;
        }
    }
    return false;
}


