#include "stcamera.h"
#include "Common/qtcommon.h"
#include <QTimer>

StCamera* StCamera::m_pInstance = nullptr;


StCamera *StCamera::GetInstance()
{
    if(m_pInstance == nullptr)
    {
        m_pInstance = new StCamera();
        atexit(Release);
    }
    return m_pInstance;
}
void StCamera::Release()
{
    if(m_pInstance)
    {
        delete m_pInstance;
        m_pInstance = nullptr;
    }
}

StCamera::StCamera(QObject *parent) : QObject(parent)
{
    m_pImgProvider = new GrapImageProvider();
    isCameraOpen=false;

}

StCamera::~StCamera()
{
    if(isCameraOpen){
        if(!StTrg_StopTransfer(hCamera))
        {
            //"Can't Stop.\n"));

        }
        StTrg_Close(hCamera);
    }


}


bool StCamera::getImage()
{
    if(!isCameraOpen)
        return false;
    QImage image(640,480,QImage::Format_Indexed8);
    unsigned char*p=image.bits();

    DWORD dwNumberOfBytesTrans = 0;
    DWORD dwFrameNo = 0;
    DWORD dwTimeout = 1000;
    if(!StTrg_TakeRawSnapShot(hCamera, p, static_cast<DWORD>(image.sizeInBytes())/*image.byteCount()*/, &dwNumberOfBytesTrans, &dwFrameNo, dwTimeout))
    {
        //"Couldn't take raw snap shot.\n"));
        return false;
    }


    m_pImgProvider->img = image;
    emit callQmlRefeshImg();
    return true;
}

bool StCamera::openCamera()
{
    hCamera = INVALID_HANDLE_VALUE;
    hCamera = StTrg_Open();
    isCameraOpen=INVALID_HANDLE_VALUE == hCamera?false:true;
    if(isCameraOpen){
        isCameraOpen=StTrg_StartTransfer(hCamera);
        emit isOpenChanged();
        return isCameraOpen;
    }
    isCameraOpen=false;
    emit isOpenChanged();
    return isCameraOpen;
}


void StCamera::closeCamera()
{
    if(isCameraOpen){
        if(!StTrg_StopTransfer(hCamera))
        {
            //"Can't Stop.\n"));
        }
        StTrg_Close(hCamera);
        emit isOpenChanged();
        isCameraOpen=false;
    }
}

void StCamera::closeavCamera()
{
    emit avStop();
}

void StCamera::openavCamera()
{
    emit avStart();
}

bool StCamera::isOpen()
{
    return isCameraOpen;

}

void StCamera::startVideo()
{

}
