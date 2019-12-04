#ifndef HSERIALPORTLASER_H
#define HSERIALPORTLASER_H
#include <QObject>
#include <QThread>
#include <QMutex>
#include <QWaitCondition>


//! [0]
class MasterThread : public QThread
{
    Q_OBJECT

public:
    explicit MasterThread(QObject *parent = nullptr);
    ~MasterThread() override;

    void transaction(const QString &portName, int waitTimeout, const QString &request);
    void closePort();

signals:
    void response(const QString &s);
    void error(const QString &s);
    void timeout(const QString &s);

private:

    void run() override;


    bool isClose;
    QString m_portName;
    QString m_request;
    int m_waitTimeout = 0;
    QMutex m_mutex;
    QWaitCondition m_cond;
    bool m_quit = false;
};

class HSerialportLaser: public QObject
{
    Q_OBJECT
public:
    static HSerialportLaser* GetInstance();
    static void Release();

public slots:

    QStringList getComArray() const;

    void closePort();
    void requestData(const QString& requestData,long timeOut=1200);
    bool connectSerial(const QString & SerialportName, const int &timeout,const QString& firstRequest);


signals:
    void responseData(QString s);
    void errorData(QString s);
    void timeOutData(QString s);

private:
    explicit HSerialportLaser(QObject *parent = nullptr);
    HSerialportLaser(const HSerialportLaser& that);
    ~HSerialportLaser();
    static HSerialportLaser* m_pInstance;

    QMutex m_mutex;
    bool isReady;

    QString ComName;
    int timeOut;
    MasterThread m_thread;

};


#endif // HSERIALPORTLASER_H
