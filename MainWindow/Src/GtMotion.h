#include<QString>
#include <QMutex>
#include <QHash>
#include <QPointF>


class GtMotion
{
public:
    static GtMotion* GetInstance();
    static void Release();

    const long pluseRadio=500;//  pluse per mm
    /******************there units are mm and mm/s**********************/
    bool Init(QString ConfigPath, short axisStart, short axisNum);//card init
    bool MoveTo(short axis, double vel, double pos);
    bool StepMove(short axis, double vel, double step);

    bool HomeCapt(short axis, double pos, double vel);
    bool GetCurPosMM(short axisStart, double &pos, short axisNum=1);
    bool GetCurVelMM(short axisStart, double &vel, short axisNum=1);
    bool GetCmdPosMM(short axisStart, double &pos, short axisNum=1);
    bool GetCmdVelMM(short axisStart, double &vel, short axisNum=1);
    bool IsAxisInit(short axisStart, short axisNum=1);
    bool waitAxisStop(short axis,long timeout=10000);
    bool IsMove(short axis);
    void AxisControl(short axis, bool mode); //0:turn off  1:turn on
    void Close(const short axisNum=4);
    /**************************************************************/

    bool Stop(long axis, long style=0);
    bool SetTrapPrm(short axis, double Acc=0.25,  double vel=0,double Dec=0.125, short SmoothTime=25);

    //bool SmartHome();
    bool ClearError(short axisStart);

    bool PosZero(short axis);
    short GetAxisStatus(short axis);

    long GetInputBit(short type);
    long GetOutputBit(short type);
    bool GetInput(short type, short num, bool &bit);//  type 0：正限位。1：负限位。：驱动报警。 3：原点开关。 4：通用输入。5：电机到位信号。 6：手轮 MPG 轴选和倍率信号（5V 电平输入）。
    bool GetOutput(short type, short num, bool &bit);// 10：驱动器使能。 11：报警清除。 12：通用输出。
    bool SetOutput(short type, short num, bool bit); //10：驱动器使能。 11：报警清除。 12：通用输出。

private:
    GtMotion();
    ~GtMotion();
    QMutex mutex;

    QHash<short, QPoint> axisLimit;

    inline short isMoveDone(short axis);
    inline bool homeMove(short axis,double vel,long pos);

    static GtMotion* m_pInstance;

    //there unit are pluse and ms
    bool GetCmdVel(short axisStart, double &Vel, short axisNum);//get cmd pluse vel
    bool GetCmdPos(short axisStart,double &Pos,short axisNum);//get cmd pluse pos
    bool GetCmdAcc(short axisStart, double &Acc, short axisNum);//get cmd pluse acc
    bool PointMove(short axis, double vel, long pos);
    bool GetCurVel(short axisStart, double &Vel, short axisNum);//get cur pluse vel
    bool GetCurPos(short axisStart,double &Pos,short axisNum);//get cur pluse pos
    bool GetCurAcc(short axisStart,double &Acc,short axisNum);//get cur pluse acc


    bool GetMotionMode(short axisStart, QString &modename, short axisNum); //get motion mode

    bool GetTrapPrm(short axis, double&Vel, double&Acc, double &Dec, double&SmoothTime);
    bool GetJogPrm(short axis,double&Acc,double &Dec,double&Smooth);

    bool SetJogPrm(short axis, double&Acc, double &Dec);
    bool ComparePos(short axis, long Buf1[20], short num, short pulse);
    bool SetCapturePos(short axis , long pos, double encPos);

    bool JogMove(short axis, double Vel);
    bool GetCurError(short axisStart, double &Error, short axisNum);//get cur pos error



};
