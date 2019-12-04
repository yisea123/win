#include "A3200Api.h"
#include "A3200/Include/A3200.h"
//#include <QDebug>
#include <QEventLoop>
#include <QTimer>


A3200Api* A3200Api::m_pInstance = nullptr;

const  AXISMASK allAxisMask =AXISMASK(AXISMASK_00 | AXISMASK_01| AXISMASK_02|AXISMASK_03);

static A3200Handle m_handle=nullptr;

A3200Api *A3200Api::GetInstance()
{
    if(m_pInstance == nullptr)
    {
        m_pInstance = new A3200Api();
        atexit(Release);
    }
    return m_pInstance;
}
void A3200Api::Release()
{
    if(m_pInstance)
    {
        delete m_pInstance;
        m_pInstance = nullptr;
    }
}



A3200Api::A3200Api()
{
    result=false;
    IsConnected=false;
}

bool A3200Api::GetLastError(char * &errorInfo)
{

    return A3200GetLastErrorString(errorInfo, 1024);
}



bool A3200Api::InitMotionController()
{
    if(A3200Connect(&m_handle)){
        QEventLoop loop;
        QTimer::singleShot(400, &loop, SLOT(quit()));
        loop.exec();

        A3200AcknowledgeAll(m_handle, TASKID_01);
    }
    A3200Reset(m_handle);

    BOOL A=0;
    if(A3200IsInitialized(&A))
        return A;
    else
        return false;
}

bool A3200Api::clearAllError()
{
    return A3200AcknowledgeAll(m_handle, TASKID_01);
}

bool A3200Api::UnInitMotionController()
{

    result=A3200MotionDisable(m_handle, TASKID_Library, allAxisMask);
    if (result)
    {
        result=A3200Disconnect(m_handle);
    }
    return result;

}


bool A3200Api::EnableMotionAxis(unsigned short axisIndex)
{

    return A3200MotionEnable(m_handle, TASKID_Library, AXISMASK(1<<axisIndex));
}

bool A3200Api::EnableAllAxis()
{
    return A3200MotionEnable(m_handle, TASKID_Library, allAxisMask);
}

bool A3200Api::DisableMotionAxis(unsigned short axisIndex)
{
    return A3200MotionDisable(m_handle, TASKID_Library,AXISMASK(1<<axisIndex));
}

bool A3200Api::DisableAllAxis()
{
    return A3200MotionDisable(m_handle, TASKID_Library, allAxisMask);
}

bool A3200Api::HomeAxis(unsigned short axisIndex)
{

    return A3200MotionHome(m_handle, TASKID_Library, AXISMASK(1<<axisIndex));
}

bool A3200Api::isAxisHomed(unsigned short axisIndex)
{
    DOUBLE Axis_status;
    A3200StatusGetItem(m_handle,axisIndex, STATUSITEM_AxisStatus, 0, &Axis_status);
    if ((static_cast<long>(Axis_status) & AXISSTATUS_Homed))
    {
        return true;
    }
    return false;
}

bool A3200Api::HomeAllAxis()
{
    if(A3200MotionHome(m_handle, TASKID_Library, AXISMASK_03))
        return A3200MotionHome(m_handle, TASKID_Library, AXISMASK(AXISMASK_00 | AXISMASK_01| AXISMASK_02));
    else{
        return false;
    }
}

bool A3200Api::StopAxis(unsigned short axisIndex)
{
    return A3200MotionAbort(m_handle,  AXISMASK(1<<axisIndex));
}

bool A3200Api::StopAllAxis()
{
    return A3200MotionAbort(m_handle, allAxisMask);
}

bool A3200Api::MoveIncStep(unsigned short axisIndex, double vel, double step, double acc, double dec){
    acc*=0.1;dec*=0.1;
    result = A3200MotionSetupRampRateAccelAxis(m_handle, TASKID_Library,AXISMASK(1<<axisIndex),&acc);
    if (result)
    {
        result = A3200MotionSetupRampRateDecelAxis(m_handle, TASKID_Library,AXISMASK(1<<axisIndex),&dec);
        if (result)
        {
            result = A3200MotionMoveInc(m_handle, TASKID_Library, AXISINDEX(axisIndex), step, vel);
        }
    }

    return result;
}
bool A3200Api::MoveToPos(unsigned short axisIndex, double vel, double pos, double acc, double dec)
{
    acc*=0.1;dec*=0.1;
    result = A3200MotionSetupRampRateAccelAxis(m_handle, TASKID_Library,AXISMASK(1<<axisIndex),&acc);
    if (result)
    {
        result = A3200MotionSetupRampRateDecelAxis(m_handle, TASKID_Library,AXISMASK(1<<axisIndex),&dec);
        if (result)
        {
            result = A3200MotionMoveAbs(m_handle, TASKID_Library, AXISINDEX(axisIndex), pos, vel);
        }
    }

    return result;
}

bool A3200Api::WaitAxisStop(unsigned short axisIndex, long timeOutms)
{
    long a=0;
    while (IsAxisMove(axisIndex)) {
        QEventLoop loop;
        QTimer::singleShot(20, &loop, SLOT(quit()));
        loop.exec();
        ++a;
        if(a>timeOutms/20){
            return false;
        }

    }
    return true;
}

bool A3200Api::WaitAllAxisStop(long timeOutms)
{
    long a=0;
    while (IsAxisMove(0)||IsAxisMove(1)||IsAxisMove(2)||IsAxisMove(3)){
        Sleep(50);
        ++a;
        if(a>timeOutms/50){
            return false;
        }

    }
    return true;
}

bool A3200Api::GetCommandPos(unsigned short axisIndex,double &Pos)
{

    return A3200StatusGetItem(m_handle, axisIndex, STATUSITEM_ProgramPositionCommand, 0, &Pos);
}

bool A3200Api::GetFeedBackPos(unsigned short axisIndex,double &Pos)
{
    return A3200StatusGetItem(m_handle, axisIndex, STATUSITEM_ProgramPositionFeedback, 0, &Pos);
}

bool A3200Api::GetFeedbackVel(unsigned short axisIndex,double &Pos)
{
    return A3200StatusGetItem(m_handle, axisIndex, STATUSITEM_ProgramVelocityFeedback, 0, &Pos);
}

bool A3200Api::IsAxisMove(unsigned short axisIndex)
{
    DOUBLE axis_status;
    if(A3200StatusGetItem(m_handle, axisIndex, STATUSITEM_AxisStatus, 0, &axis_status)){
        return !(static_cast<long>(axis_status) & AXISSTATUS_MoveDone);
    }
    else{
        return false;
    }
}

bool A3200Api::LoadProgram(const char *programPath)
{
    return  A3200ProgramLoad(m_handle, TASKID_01,programPath);
}


bool A3200Api::RunProgram(const char * programPath,int taskid)
{
    return  A3200ProgramRun(m_handle, TASKID(taskid),programPath);
}

bool A3200Api::StartProgram()
{

    return  A3200ProgramStart(m_handle, TASKID_01);

}

bool A3200Api::StopProgramAndWait(unsigned long timeOut)
{

    return  A3200ProgramStopAndWait(m_handle, TASKID_01,timeOut);

}

bool A3200Api::PauseProgramAndWait(unsigned long timeOut)
{

    return  A3200ProgramPauseAndWait(m_handle, TASKID_01,timeOut);

}

int A3200Api::GetProgramStatus()
{
    mutex.lock();
    TASKSTATE taskState;
    A3200ProgramGetTaskState(m_handle, TASKID_01, &taskState);
    mutex.unlock();
    return TASKSTATE(taskState);
}



int A3200Api::GetProgramState()
{
    TASKSTATE taskState;

    if(A3200ProgramGetTaskState(m_handle, TASKID_01, &taskState)){
        short k=TASKSTATE(taskState);
        if(k==8||k==1||k==0){
            return -1;
        }
        else if(k==7)
        {
            return 0;
        }
        else{
            return 1;
        }
    }
    else{
        return -1;
    }

}

int A3200Api::GetAxisStatus(unsigned short AxisIndex)
{
    mutex.lock();
    DOUBLE Axis_status;
    BOOL a=TRUE;
    A3200IsInitialized(&a);
    if (a)
    {
        if(A3200StatusGetItem(m_handle,AxisIndex, STATUSITEM_AxisFault, 0, &Axis_status))
        {

            if(static_cast<long>(Axis_status)==0)
            {
                A3200StatusGetItem(m_handle,AxisIndex, STATUSITEM_DriveStatus, 0, &Axis_status);
                if ((static_cast<long>(Axis_status) & DRIVESTATUS_Enabled))
                {
                    A3200StatusGetItem(m_handle,AxisIndex, STATUSITEM_AxisStatus, 0, &Axis_status);
                    if ((static_cast<long>(Axis_status) & AXISSTATUS_Homing))
                    {
                        mutex.unlock();
                        return 3;//homing
                    }
                    else if((static_cast<long>(Axis_status) & AXISSTATUS_MoveDone))
                    {
                        mutex.unlock();
                        return 5;//moving
                    }
                    else
                    {
                        mutex.unlock();
                        return 4;//stop
                    }

                }
                else
                {
                    mutex.unlock();
                    return 2;//disable
                }


            }
            else{
                mutex.unlock();
                return 1;//axis error
            }

        }
        else{
            mutex.unlock();
            return 0;//disconnected

        }


    }
    else
    {
        mutex.unlock();
        return 0;//disconnected
    }

}


bool A3200Api::SetOutput(unsigned short axisIndex,unsigned long outPutIndex, unsigned long nValue)
{
    mutex.lock();
    bool a= A3200IODigitalOutput(m_handle, TASKID_01, outPutIndex, AXISINDEX(axisIndex), nValue);
    mutex.unlock();
    return a;
}
bool A3200Api::GetInput(unsigned short axisIndex,unsigned long inPutIndex, unsigned long &nValue)
{
    mutex.lock();
    bool a= A3200IODigitalInput(m_handle, TASKID_01, inPutIndex, AXISINDEX(axisIndex), &nValue);
    mutex.unlock();
    return a;

}
