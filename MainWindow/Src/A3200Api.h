#include <QMutex>

enum Axis{
    AXIS_THETA=0,
    AXIS_X,
    AXIS_Y,
    AXIS_Z,
};

class A3200Api
{

private:
    A3200Api();
     static A3200Api* m_pInstance;
     QMutex mutex;

     bool result;
     bool IsConnected;


public:
    static A3200Api* GetInstance();
    static void Release();



     bool GetLastError( char * &errorInfo);
     bool InitMotionController();
     bool clearAllError();
     bool EnableMotionAxis(unsigned short axisIndex);
     bool EnableAllAxis();
     bool DisableMotionAxis(unsigned short axisIndex);
     bool DisableAllAxis();
     bool UnInitMotionController();
     bool HomeAxis(unsigned short axisIndex);
     bool isAxisHomed(unsigned short axisIndex);
     bool HomeAllAxis();
     bool StopAxis(unsigned short axisIndex);
     bool StopAllAxis();
     bool MoveIncStep(unsigned short axisIndex, double vel, double step, double acc=100, double dec=100);
     bool MoveToPos(unsigned short axisIndex, double vel, double pos, double acc=100, double dec=100);
     bool WaitAxisStop(unsigned short axisIndex,long timeOutms=60000);
     bool WaitAllAxisStop(long timeOutms=20000);


     bool GetCommandPos(unsigned short axisIndex, double &pos);
     bool GetFeedBackPos(unsigned short axisIndex, double &pos);
     bool GetFeedbackVel(unsigned short axisIndex, double &pos);
     bool IsAxisMove(unsigned short axisIndex);


     bool LoadProgram(const char * programPath);
     bool RunProgram(const char * programPath, int taskid);
     bool StartProgram();
     bool StopProgramAndWait(unsigned long timeOut=1000);
     bool PauseProgramAndWait(unsigned long timeOut=1000);

     int GetProgramStatus();
     int GetProgramState();

     int GetAxisStatus(unsigned short AxisIndex);

     bool SetOutput(unsigned short axisIndex, unsigned long outPutIndex, unsigned long nValue);
     bool GetInput(unsigned short axisIndex, unsigned long outPutIndex, unsigned long &nValue);

};


