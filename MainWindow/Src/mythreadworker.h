#ifndef MYTHREADWORKER_H
#define MYTHREADWORKER_H

#include <QObject>
#include <QThread>
#include <QMutex>
#include <QRunnable>
#include <QThreadPool>


class MyThreadWorker : public QObject, public QRunnable
{
    Q_OBJECT
public:
    explicit MyThreadWorker(QObject *parent = nullptr);

signals:
    void  moveDone(short axisIndex,bool isSucceed);
    void  homeDone(short axisIndex,int isSucceed);
    void  homeAllDone(bool isSucceed);


    void initCameraDone(int returnCode);
    void initA3200Done(int returnCode);
    void initGTSDone(int returnCode);
    void initLaserDone(int returnCode);


public slots:


    void starthomeAll();
    void startmoveToPos(short type,short axisIndex, double vel, double pos);
    void starthomeAxis(short axisIndex);

    void startInitCamera();
    void startInitA3200();
    void startInitGTS();
    void startInitLaser();

protected:


private:
    QMutex myMutex;
    QThreadPool pool;
    void run();

    short type=0;
    short axisIndex=0;
    double vel=0;
    double pos=0;

    enum MyFuncIndex{
        type_homeAll=0x0,
        type_moveToPos,
        type_homeAxis,
        type_initCamera,
        type_initA3200,
        type_initGTS,
        type_initLaser,
    } funcIndex;

    void thread_homeAll();
    void thread_moveToPos();
    void thread_homeAxis();
    void thread_initCamera();
    void thread_initA3200();
    void thread_initGTS();
    void thread_initLaser();

};
extern MyThreadWorker* myThread;
#endif // MYTHREADWORKER_H
