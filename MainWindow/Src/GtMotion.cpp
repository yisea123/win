#include "GtMotion.h"
#include "GTS/64bit/single_card/gts.h"
#include <QThread>
#include <QStringList>
#include <QDebug>

GtMotion* GtMotion::m_pInstance = nullptr;

GtMotion *GtMotion::GetInstance()
{
    if(m_pInstance == nullptr)
    {
        m_pInstance = new GtMotion();
        atexit(Release);
    }
    return m_pInstance;
}
void GtMotion::Release()
{
    if(m_pInstance)
    {
        delete m_pInstance;
        m_pInstance = nullptr;
    }
}

GtMotion::GtMotion()
{
    axisLimit.insert(1,QPoint(-10000,10000));
    axisLimit.insert(2,QPoint(-10000,10000));
    axisLimit.insert(3,QPoint(-10000,10000));
    axisLimit.insert(4,QPoint(-10000,10000));

}

GtMotion::~GtMotion()
{
    Close();
}

short GtMotion::GetAxisStatus(short axis)
{

    long lAxisStatus;
    if(GT_GetSts(axis, &lAxisStatus))
        return -1;
    if(lAxisStatus & 0x2)//报警
        return 1;
    if(lAxisStatus & 0x10)//出错
        return 2;
    if(!(lAxisStatus & 0x200))//伺服关闭
        return 3;
    if(lAxisStatus & 0x20)//正限位
        return 4;
    if(lAxisStatus & 0x40)//负限位
        return 5;
    if(lAxisStatus & 0x80)//平滑停止
        return 6;
    if(lAxisStatus & 0x100)//紧急停止
        return 7;
    if((lAxisStatus & 0x400))//规划运动
        return 8;
    if(!(lAxisStatus & 0x400))//规划停止
        return 9;
    return 99;

    //    switch (type)
    //    {
    //    case 0:// 伺服报警标志
    //    {
    //        if (lAxisStatus & 0x2)
    //        {
    //            return 1;

    //        }
    //        else
    //        {
    //            return 2;
    //        }
    //    }
    //    case 1:// 跟随误差越限标志
    //    {
    //        if (lAxisStatus & 0x10)
    //        {
    //            return 3;

    //        }
    //        else
    //        {
    //            return 4;

    //        }
    //    }
    //    case 2:// 正向限位
    //    {
    //        if (lAxisStatus & 0x20)
    //        {
    //            return 5;

    //        }
    //        else
    //        {
    //            return 6;

    //        }
    //    }
    //    case 3:// 负向限位
    //    {
    //        if (lAxisStatus & 0x40)
    //        {
    //            return 7;

    //        }
    //        else
    //        {
    //            return 8;

    //        }
    //    }
    //    case 4:// 平滑停止
    //    {
    //        if (lAxisStatus & 0x80)
    //        {
    //            return 9;

    //        }
    //        else
    //        {
    //            return 10;

    //        }
    //    }
    //    case 5:// 急停标志
    //    {
    //        if (lAxisStatus & 0x100)
    //        {
    //            return 11;

    //        }
    //        else
    //        {

    //            return 12;
    //        }
    //    }
    //    case 6:// 伺服使能标志
    //    {
    //        if(lAxisStatus & 0x200)
    //        {

    //            return 13;
    //        }
    //        else
    //        {
    //            return 14;

    //        }
    //    }
    //    case 7:// 规划器正在运动标志
    //    {
    //        if (lAxisStatus & 0x400)
    //        {
    //            return 15;

    //        }
    //        else
    //        {
    //            return 16;

    //        }
    //    }


    //    default:
    //        return 0;
    //    }

    //    if (lAxisStatus& 0x2)
    //        printf("伺服报警\n");
    //    else
    //        printf("伺服正常\n");
    //    if (lAxisStatus& 0x10)  // 跟随误差越限标志
    //        printf("运动出错\n");
    //    else
    //        printf("运动正常\n");   // 正向限位
    //    if (lAxisStatus& 0x20)
    //        printf("正限位触发\n");
    //    else
    //        printf("正限位未触发\n");    // 负向限位
    //    if (lAxisStatus& 0x40)
    //        printf("负限位触发\n");
    //    else
    //        printf("负限位未触发\n");    // 平滑停止
    //    if (lAxisStatus& 0x80)  {     printf("平滑停止触发\n");  }  else  {      printf("平滑停止未触发\n");  }  // 急停标志
    //    if (lAxisStatus& 0x100)  {    printf("急停触发\n");  }  else  {    printf("急停未触发\n");  }  // 伺服使能标志
    //    if(lAxisStatus& 0x200)  {     printf("伺服使能\n");  }  else  {     printf("伺服关闭\n");  }  // 规划器正在运动标志
    //    if (lAxisStatus& 0x400)  {     printf("规划器正在运动\n");  }  else  {      printf("规划器已停止\n");
    //    }
}

long GtMotion::GetInputBit(short type)
{
    mutex.lock();
    long lGpiValue=-1;
    if(!GT_GetDi(type,&lGpiValue)){
        mutex.unlock();
        return lGpiValue;
    }
    mutex.unlock();
    return -1;

}

long GtMotion::GetOutputBit(short type)
{
    mutex.lock();
    long lGpiValue=-1;
    if(!GT_GetDo(type,&lGpiValue)){
        mutex.unlock();
        return lGpiValue;
    }
    mutex.unlock();
    return -1;
}

void GtMotion::AxisControl(short axis,bool mode)
{

    if (mode)
    {
        GT_AxisOn(axis);
    }
    else
    {
        GT_AxisOff(axis);
        GT_SetDoBit(10,0,0);
    }

}

bool GtMotion::PointMove(short axis,double vel,long pos)
{
    if(pos<axisLimit.value(axis).x()||pos>axisLimit.value(axis).y()){
        return false;
    }
    if(!GT_ClrSts(axis))
        if(!GT_SetPos(axis, pos))
            if(!GT_SetVel(axis,vel))
                if(!GT_Update(long(1<<(axis-1)))){
                    //                    do
                    //                    {
                    //                        if(isMoveDone(axis)==0)
                    //                            break;
                    //                        else if(isMoveDone(axis)==-1)
                    //                            return false;
                    //                        else
                    //                            continue;
                    //                    }while(true);
                    //                    QThread::msleep(200);
                    return true;
                }
    return false;
}

bool GtMotion::MoveTo(short axis, double vel, double pos)
{
    return PointMove(axis,vel/1000*pluseRadio,long(pos*pluseRadio));
}

bool GtMotion::StepMove(short axis, double vel, double step)
{
    double pos=0;
    if(GetCurPosMM(axis,pos,1))
        if(MoveTo(axis,vel,pos+step))
            return true;
    return false;
}

inline short GtMotion::isMoveDone(short axis)
{
    short type=GetAxisStatus(axis);
    if(type==-1||type==1||type==2||type==3)
        return -1;
    else if(type==6||type==7||type==9||type==4||type==5){
        return 0;
    }
    else if(type==8)
        return  1;
    return type;
}



bool GtMotion::Stop(long axis,long style)
{
    GT_Stop(axis,style);
    //GT_SetPrfPos(axis,0);

    return true;
}

bool GtMotion::JogMove(short axis,double Vel)
{
    // 将1轴设为Jog模式
    GT_PrfJog(axis);
    // 设置1轴的目标速度
    GT_SetVel(axis, Vel);
    // 启动1轴的运动
    GT_Update(long(1<<(axis-1)));
    return true;
}

bool GtMotion::SetCapturePos(short axis ,long pos,double encPos)
{

    short  status;

    // 启动Home捕获
    GT_SetCaptureMode(axis, CAPTURE_HOME);
    do
    {
        // 查询捕获状态
        GT_GetCaptureStatus(axis, &status, &pos);

        // 读取编码器位置
        // 该指令和捕获无关，仅用于显示编码器位置
        GT_GetEncPos(axis, &encPos);
        return false;
        // 显示捕获状态和编码器位置

        // 当指定轴捕获触发时退出循环
    }while( 0 == status );
    return true;
}

bool GtMotion::GetTrapPrm(short axis,double&Vel,double&Acc,double &Dec,double&SmoothTime)
{
    TTrapPrm trapPrm;
    GT_SetPrfPos(axis, 0);
    GT_PrfTrap(axis);
    // 读取点位模式运动参数
    GT_GetTrapPrm(axis, &trapPrm);
    Acc=trapPrm.acc;
    Vel=trapPrm.velStart;
    Dec=trapPrm.dec;
    SmoothTime=trapPrm.smoothTime;
    return true;
}

bool GtMotion::SetTrapPrm(short axis, double Acc, double vel,double Dec, short SmoothTime)
{
    TTrapPrm trapPrm;
    if(!GT_PrfTrap(axis)){
        trapPrm.acc=Acc;
        trapPrm.velStart=vel;
        trapPrm.dec=Dec;
        trapPrm.smoothTime=SmoothTime;
        if(!GT_SetTrapPrm(axis, &trapPrm))
            return true;
    }
    return false;
}

bool GtMotion::SetJogPrm(short axis,double&Acc,double &Dec)
{
    JogPrm jogPrm;
    GT_PrfJog(axis);
    jogPrm.acc=Acc;
    jogPrm.dec=Dec;
    //jogPrm.smooth=Smooth;
    if(GT_SetJogPrm(axis, &jogPrm))
        return false;
    return true;
}
bool GtMotion::GetMotionMode(short axisStart, QString &modename, short axisNum)
{
    long mode;
    GT_GetPrfMode(axisStart,&mode,axisNum);
    QStringList typeName;
    typeName<<"点位运动"<<"Jog模式"<<"PT模式"<<"电子齿轮模式"<<"Fllow模式"<<"插补模式"<<"PVT模式";
    modename=typeName[mode];
    return true;
}

inline bool GtMotion::homeMove(short axis, double vel, long pos)
{
    long status;
    if(!GT_ClrSts(axis))
        if(!GT_ZeroPos(axis))
            if(!GT_SetPrfPos(axis, 0))
                if(!GT_SetVel(axis, vel))
                    if(!GT_SetPos(axis,pos))
                        if(!GT_Update(long(1<<(axis-1)))){
                            do{
                                GT_GetSts(axis, &status);

                            }while( status & 0x400 );
                            QThread::msleep(200);
                            return true;
                        }
    return false;
}

bool GtMotion::HomeCapt(short axis,double pos,double vel)
{
    double limitMin=0,limitMax=0;
    long rePos=long(pos*pluseRadio);
    vel=vel/1000*pluseRadio;

    if(homeMove(axis,vel,LONG_MAX/2*(rePos/qAbs(rePos))))
        if(homeMove(axis,vel,-8*pluseRadio*(rePos/qAbs(rePos))))
            if(homeMove(axis,double(pluseRadio)/1000.0,LONG_MAX/2*(rePos/qAbs(rePos))))
                if(homeMove(axis,vel,-LONG_MAX/2*(rePos/qAbs(rePos)))){
                    GetCurPos(axis,limitMax,1);
                    limitMax=qAbs(limitMax);
                    if(qAbs(rePos)>long(limitMax)-pluseRadio)
                        return false;
                    if(homeMove(axis,vel,8*pluseRadio*(rePos/qAbs(rePos))))
                        if(homeMove(axis,double(pluseRadio)/1000.0,-LONG_MAX/2*(rePos/qAbs(rePos))))
                            if(homeMove(axis,vel,rePos))
                                if(GetCurPos(axis,limitMin,1))

                                    if(!GT_ZeroPos(axis))
                                        if(!GT_SetPrfPos(axis, 0))
                                            if(!GT_ClrSts(axis)){
                                                QPoint limit;
                                                if(limitMin<0){
                                                    limit.setX(-long(limitMax)-long(limitMin)-pluseRadio);
                                                    limit.setY(-long(limitMin)+pluseRadio);
                                                }
                                                else{
                                                    limit.setX(-long(limitMin)-pluseRadio);
                                                    limit.setY(long(limitMax)-long(limitMin)+pluseRadio);
                                                }
                                                axisLimit.insert(axis,limit);
                                                return true;
                                            }
                }



    return false;
}

bool GtMotion::GetCurPosMM(short axisStart,double &pos,short axisNum)
{
    if(!GT_GetAxisEncPos(axisStart,&pos,axisNum)){
        pos/=double(pluseRadio);
        qDebug()<<pos;
        return true;}
    return false;
}

bool GtMotion::GetCurVelMM(short axisStart, double &vel, short axisNum)
{
    if(!GT_GetAxisEncVel(axisStart,&vel,axisNum)){
        vel/=double(pluseRadio*1000);
        return true;
    }
    return false;
}

bool GtMotion::GetCmdPosMM(short axisStart, double &pos, short axisNum)
{
    if(!GT_GetAxisPrfPos(axisStart,&pos,axisNum)){
        pos/=double(pluseRadio);
        return true;}
    return false;
}

bool GtMotion::GetCmdVelMM(short axisStart, double &vel, short axisNum)
{
    if(!GT_GetAxisPrfVel(axisStart,&vel,axisNum)){
        vel/=double(pluseRadio*1000);
        return true;
    }
    return false;
}



bool GtMotion::ComparePos(short axis,long Buf1[20],short num,short pulse)
{
    if(!GT_ZeroPos(axis))
        if(!GT_SetPrfPos(axis, 0))
            if(!GT_PrfTrap(axis))
                if(!GT_ComparePulse(3,1,pulse))
                    return !GT_CompareData(axis, 1, 1, 0,pulse , NULL, NULL,Buf1,num);
    return false;
}

bool GtMotion::PosZero(short axis)
{
    if(!GT_ZeroPos(axis))
        return !GT_SetPrfPos(axis, 0);
    return false;
}

bool GtMotion::ClearError(short axisStart)
{
    return !GT_ClrSts(axisStart);

}

bool GtMotion::IsAxisInit(short axisStart,short axisNum)
{
    for (int i = axisStart; i < axisNum+1; i++)
    {
        if(!GetAxisStatus(axisStart))
        {
            return false;
        }
    }
    return true;

}

bool GtMotion::waitAxisStop(short axis, long timeout)
{
    long sts;
    long a=0;
    do{
        if(a==timeout)
            return false;
        if(GT_GetSts(axis, &sts))
            return false;
        QThread::msleep(1);
        a++;
    }
    while(sts&0x400);
    return true;

}

void GtMotion::Close(const short axisNum)
{
    for(short k=0;k<axisNum;++k){
        GT_Stop(k,0);
        GT_AxisOff(k);
    }
    GT_Close();
}



bool GtMotion::Init(QString ConfigPath,short axisStart,short axisNum)
{
    std::string str = ConfigPath.toStdString();
    char *p = const_cast<char*>(str.data());

    if(!GT_Open())
        if(!GT_Reset())
            if(!GT_LoadConfig(p))
                if(!GT_ClrSts(axisStart,axisNum)){
                    for (short i = axisStart; i <= axisNum; i++){
                        if(!GT_AxisOn(i))
                            if(!GT_ZeroPos(i)){
                                  continue;
                            }
                        return false;
                    }

                    return true;
                }
    return false;
}



bool GtMotion::IsMove(short axis)
{
    long sts;
    if(!GT_GetSts(axis, &sts))
        return (sts&0x400);
    return false;
}

bool GtMotion::GetCurVel(short axisStart,double &Vel,short axisNum)
{
    return !GT_GetAxisEncVel(axisStart,&Vel,axisNum);

}

bool GtMotion::GetCmdVel(short axisStart,double &Vel,short axisNum)
{
    return !GT_GetAxisPrfVel(axisStart,&Vel,axisNum);

}

bool GtMotion::GetCurAcc(short axisStart,double &Acc,short axisNum)
{
    return !GT_GetAxisEncAcc(axisStart, &Acc, axisNum);
}

bool GtMotion::GetCmdAcc(short axisStart,double &Acc,short axisNum)
{
    return !GT_GetAxisPrfAcc(axisStart, &Acc, axisNum);

}

bool GtMotion::GetCurPos(short axisStart, double &Pos, short axisNum)
{
    return !GT_GetAxisEncPos(axisStart, &Pos, axisNum);

}

bool GtMotion::GetCmdPos(short axisStart, double &Pos, short axisNum)
{
    return !GT_GetAxisPrfPos(axisStart, &Pos, axisNum);

}

bool GtMotion::GetCurError(short axisStart,double &Error,short axisNum)
{
    return !GT_GetAxisError(axisStart, &Error, axisNum);

}



bool GtMotion::GetInput(short type,short num,bool &bit)
{
    mutex.lock();
    long lGpiValue;
    if(!GT_GetDi(type,&lGpiValue)){
        bit=(lGpiValue & long(1<<num));
        mutex.unlock();
        return true;
    }
    mutex.unlock();
    return false;
}


bool GtMotion::GetOutput(short type,short num,bool &bit)
{
    mutex.lock();
    long lGpiValue;
    if(!GT_GetDo(type,&lGpiValue)){
        bit=(lGpiValue&long(1<<num));
        mutex.unlock();
        return true;
    }
    mutex.unlock();
    return false;
}

bool GtMotion::SetOutput(short type,short num,bool bit)
{
    mutex.lock();
    bool k= !GT_SetDoBit(type,num,bit);
    mutex.unlock();
    return k;
}



