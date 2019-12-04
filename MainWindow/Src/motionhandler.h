#ifndef MOTIONHANDLER_H
#define MOTIONHANDLER_H

#include <QObject>
#include <QThread>




class Worker : public QObject
{
    Q_OBJECT
public:
    const QStringList axisName={"theta","X","Y","Z"};

    const double limitArray[6]={-252,252,-26,26,-44,21};//X,Y,Z

public slots:
    void moveTo(int moveType, unsigned short axisindex, double pos, double vel);
    void homeAxis(unsigned short axisindex);
    void homeAllAxis();

signals:
    void _moveDone(QString msg,bool flag);
    void _homeDone(QString msg,bool flag);
    void _homeAllDone(QString msg,bool flag);
};



class MotionHandler : public QObject
{
    Q_OBJECT
public:
    explicit MotionHandler(QObject *parent = nullptr);
    ~MotionHandler();
protected:
    QThread workerThread;
Q_SIGNALS:
    void moveDone(QString msg,bool isSucceed);
    void homeDone(QString msg,bool isSucceed);
    void homeAllDone(QString msg,bool isSucceed);
    void refreshStatus(unsigned short axis,QString pos,QString vel,int state);



    void _startHome(const unsigned short &);
    void _startMove(const int &,const unsigned short &,const double &,const double &);
    void _startHomeAll();

public Q_SLOTS:
    void pointMove(unsigned short axisIndex,double pos);
    void startMove(int type,unsigned short axisIndex,double pos,double vel);
    void startHome(unsigned short axisIndex);
    void enableAxis(unsigned short axisIndex, bool value);
    void startHomeAll();
    void stopMove(unsigned short axisIndex);
    double getCurrentPos(unsigned short index);

};

#endif // MOTIONHANDLER_H
