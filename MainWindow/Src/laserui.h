#ifndef LASERUI_H
#define LASERUI_H

#include <QObject>

enum LaserPara{
    MCS=1,
    T1S,
    PRF,
    PSN,
    SHT=9

};


class LaserUI : public QObject
{
    Q_OBJECT
public:
    static LaserUI* GetInstance();
    static void Release();
    void reconnectLaser();
    bool setLaser(LaserPara type, long data);
    void closeSerial();
private:
    explicit LaserUI(QObject *parent = nullptr);
    static LaserUI* m_pInstance;
     ~LaserUI() Q_DECL_OVERRIDE;

signals:
    //void isConnected(bool flag);
    void reConnect();
    void showValue(QString m_value);
    void valueChanged(int type,long m_data);
    void showMessage(QString str);
    void serialClosed();

public slots:
    bool reConnectCom(QString comName,int timeOut=1200,QString str="MCH=1\r\n");
    void writeData(QString data);
    int setValue(QString data);
    void closePort();

    QStringList getCom();
    bool isConnected();

private:
    int value;
    QString receive;
    QString currentWrite;

};

#endif // LASERUI_H
