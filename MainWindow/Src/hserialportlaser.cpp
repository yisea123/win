#include "hserialportlaser.h"
//#include <QSerialPortInfo>
//#include <QSerialPort>
#include <QDebug>
#include <QTime>

MasterThread::MasterThread(QObject *parent) :
    QThread(parent)
{
    isClose=false;
}


MasterThread::~MasterThread()
{
    m_mutex.lock();
    m_quit = true;
    m_cond.wakeOne();
    m_mutex.unlock();
    wait();
}

void MasterThread::transaction(const QString &portName, int waitTimeout, const QString &request)
{

    const QMutexLocker locker(&m_mutex);
    m_portName = portName;
    m_waitTimeout = waitTimeout;
    m_request = request;
    isClose=false;

    if (!isRunning())
        start();
    else
        m_cond.wakeOne();
}

void MasterThread::closePort()
{
    const QMutexLocker locker(&m_mutex);
    isClose=true;

    if (!isRunning())
        start();
    else
        m_cond.wakeOne();
}

void MasterThread::run()
{
//    bool currentPortNameChanged = false;

//    m_mutex.lock();

//    QString currentPortName;
//    if (currentPortName != m_portName) {
//        currentPortName = m_portName;
//        currentPortNameChanged = true;
//    }

//    int currentWaitTimeout = m_waitTimeout;
//    QString currentRequest = m_request;
//    m_mutex.unlock();

//    QSerialPort serial;

//    if (currentPortName.isEmpty()) {
//        emit error(tr(" No port name specified"));
//        return;
//    }

//    while (!m_quit) {

//        if (currentPortNameChanged) {
//            if(serial.isOpen())
//                serial.close();
//            serial.setPortName(currentPortName);

//            if (!serial.open(QIODevice::ReadWrite)) {
//                emit error(tr(" Can't open %1, error code %2")
//                           .arg(m_portName).arg(serial.error()));
//                return;
//            }
//        }

//        // write request
//        const QByteArray requestData = currentRequest.toUtf8();
//        serial.write(requestData);
//        if (serial.waitForBytesWritten(m_waitTimeout)) {

//            // read response
//            if (serial.waitForReadyRead(currentWaitTimeout)) {
//                QByteArray responseData = serial.readAll();
//                while (serial.waitForReadyRead(10))
//                    responseData += serial.readAll();

//                const QString response = QString::fromUtf8(responseData);

//                emit this->response(response);
//                serial.clear();

//            } else {
//                if(requestData!="ADC=0\r\n"&&requestData!="ADC=1\r\n")
//                    emit timeout(tr(" Wait read response timeout at %1").arg(QTime::currentTime().toString()));
//                serial.clear();
//            }

//        } else {
//            emit timeout(tr(" Wait write request timeout at %1")
//                         .arg(QTime::currentTime().toString()));
//            serial.clear();
//        }

//        m_mutex.lock();
//        m_cond.wait(&m_mutex);
//        if(isClose){
//            emit error(tr("serialPort closed!"));
//            serial.clear();
//            if(serial.isOpen())
//                serial.close();
//            m_mutex.unlock();
//            return;
//        }
//        if (currentPortName != m_portName) {
//            currentPortName = m_portName;
//            currentPortNameChanged = true;
//        } else {
//            currentPortNameChanged = false;
//        }

//        currentWaitTimeout = m_waitTimeout;
//        currentRequest = m_request;
//        m_mutex.unlock();
//    }
//    if(serial.isOpen())
//        serial.close();
}


HSerialportLaser* HSerialportLaser::m_pInstance = nullptr;

HSerialportLaser *HSerialportLaser::GetInstance()
{
    if(m_pInstance == nullptr)
    {
        m_pInstance = new HSerialportLaser();
        atexit(Release);
    }
    return m_pInstance;
}
void HSerialportLaser::Release()
{
    if(m_pInstance)
    {
        delete m_pInstance;
        m_pInstance = nullptr;
    }
}

QStringList HSerialportLaser::getComArray() const
{
//    QStringList str;
//    const auto infos = QSerialPortInfo::availablePorts();
//    for (const QSerialPortInfo &info : infos)
//        str<<info.portName();
//    return str;
    QStringList str;
    str<<"";
    return str;
}

void HSerialportLaser::closePort()
{
    m_thread.closePort();
}




HSerialportLaser::HSerialportLaser(QObject *parent) : QObject(parent)
{
    isReady=true;
    ComName="COM1";
    timeOut=1000;
    connect(&m_thread, &MasterThread::response, this,[=](QString s){
        //QMutexLocker locker(&m_mutex);
        emit responseData(s);
        isReady=true;
    });
    connect(&m_thread, &MasterThread::error, this, [=](QString s){emit errorData(s);});
    connect(&m_thread, &MasterThread::timeout, this,[=](QString s){emit timeOutData(s);});

}



HSerialportLaser::~HSerialportLaser()
{
    m_thread.exit();

}


bool HSerialportLaser::connectSerial(const QString &SerialportName, const int &timeout, const QString &firstRequest)
{
    if(getComArray().contains(SerialportName)){
        ComName=SerialportName;
        timeOut=timeout;
        m_thread.transaction(SerialportName,timeOut,firstRequest);
        return true;
    }
    else{
        return false;
    }
}


void HSerialportLaser::requestData(const QString &requestData, long timeOut)
{
    //QMutexLocker locker(&m_mutex);
    //if(isReady)
    m_thread.transaction(ComName,timeOut,requestData);
    //isReady=false;
}

