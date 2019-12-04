#ifndef STATEHANDLER_H
#define STATEHANDLER_H

#include <QObject>
#include <QMutex>
#include <QList>
#include <QTimer>
#include <QThread>



enum Input{
    Laser_power=1,
    Front_gate,
    Left_gate,
    Back_gate,
    Right_gate,
    Safe_gate,
    Lightpath_closed,
    Finished_box_closed,
    water_cooling_Temp,
    Lightpath_state1,
    Lightpath_state2,
    Air_pressure,
    N2_pressure,
    E_Stop,
    Aspirateur,
    Water_cooling_flow,
    Fixture_1_clamp,
    Fixture_2_clamp,
    Tube_exist
};

enum Output{
    Red_lamp=1,
    Green_lamp,
    Yellow_lamp,
    Buzzer,
    Safegate_locked,
    null1,
    Lightpath_switch,
    null2,
    null3,
    null4,
    Cleaner_on_off,
    Coaxial_lighter,
    Switch_system,
    null5,
    null6,
    null7,
    Fixtrue_1,
    Fixtrue_2,
    N2_on_off
};


class StateWorker : public QThread
{
    Q_OBJECT
public:
    explicit StateWorker(QObject *parent = nullptr);
    ~StateWorker() Q_DECL_OVERRIDE;

signals:

public slots:

protected:
   void run() Q_DECL_OVERRIDE;


};

class StateHandler : public QObject
{
    Q_OBJECT
public:
    static StateHandler* GetInstance();
    static void Release();

    void unInit();
    bool isWarning;

    bool isEnableWarning;

Q_SIGNALS:


private:
    explicit StateHandler(QObject *parent = nullptr);
    ~StateHandler() Q_DECL_OVERRIDE;
    static StateHandler* m_pInstance;

    unsigned short readBit(unsigned short value, int begin, int count);
    unsigned short writeBit(unsigned short value, int begin, int count, unsigned short src);


public Q_SLOTS:

    void refreshFunc();

    bool getIsWarning();

    void beginMonitor();
    int getInput(int count);
    int getOutput(int count);
    bool setOutput(int count, bool value);

    void setMonitor(bool value);



private:
    StateWorker *worker;
    QTimer *timer;
    QList <unsigned short> temp;

};
#endif // STATEHANDLER_H
