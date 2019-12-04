#ifndef STCAMERA_H
#define STCAMERA_H

#include <QObject>
#include "grapimageprovider.h"
#include "StTrgApi.h"

class StCamera : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isOpen READ isOpen NOTIFY isOpenChanged)

public:
    static StCamera* GetInstance();
    static void Release();
    GrapImageProvider *m_pImgProvider;

private:
    explicit StCamera(QObject *parent = nullptr);
    ~StCamera();
    static StCamera* m_pInstance;


signals:
      void callQmlRefeshImg();

      void stop();
      void start();
      void isOpenChanged();
      void avStop();
      void avStart();
      void cameraStataus(int index,bool isOK);

public slots:


    bool getImage();
    bool openCamera();
    void closeCamera();
    void closeavCamera();
     void openavCamera();
    bool isOpen();

    void startVideo();

private:
    bool isCameraOpen;
    HANDLE hCamera;
};

#endif // STCAMERA_H
