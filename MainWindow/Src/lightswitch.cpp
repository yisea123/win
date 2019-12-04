#include "lightswitch.h"
#include "GtMotion.h"
#include "inisettings.h"
#include "A3200Api.h"


LightSwitch::LightSwitch(QObject *parent) : QObject(parent)
{

}

QString LightSwitch::getSwitchPos()
{
    return IniSettings::GetInstance()->getValue(IniType::lightSwitch_pos);
}

int LightSwitch::getStep()
{
    return static_cast<int>(IniSettings::GetInstance()->getValue(IniType::lightSwitch_step).toDouble()*100);
}

void LightSwitch::moveStep(double step)
{
    double pos=0;
    GtMotion::GetInstance()->GetCurPosMM(1,pos);
    GtMotion::GetInstance()->MoveTo(1,5,pos+step);
}

void LightSwitch::setStep(QString value)
{

    IniSettings::GetInstance()->setValue(IniType::lightSwitch_step,value);
}

void LightSwitch::setSwitchPos(QString value)
{

    IniSettings::GetInstance()->setValue(IniType::lightSwitch_pos,value);
}


void LightSwitch::setWaitPosition(QStringList value)
{

    IniSettings::GetInstance()->setValue(IniType::isAutoback,value[0]);
    IniSettings::GetInstance()->setValue(IniType::position_wait_y,value[1]);
    IniSettings::GetInstance()->setValue(IniType::position_wait_z,value[2]);

}

QStringList LightSwitch::getWaitPosition()
{
    QStringList A={"0","0","0"};

    A[0]=IniSettings::GetInstance()->getValue(IniType::isAutoback);
    A[1]=IniSettings::GetInstance()->getValue(IniType::position_wait_y);
    A[2]=IniSettings::GetInstance()->getValue(IniType::position_wait_z);

    return A;
}

QStringList LightSwitch::getMotionConf()
{
    QStringList A={"50","50","10"};

    A[0]=IniSettings::GetInstance()->getValue(IniType::motion_acc);
    A[1]=IniSettings::GetInstance()->getValue(IniType::motion_dec);
    A[2]=IniSettings::GetInstance()->getValue(IniType::motion_vel);

    return A;
}

void LightSwitch::setMotionConf(QStringList value)
{

    IniSettings::GetInstance()->setValue(IniType::motion_acc,value[0]);
    IniSettings::GetInstance()->setValue(IniType::motion_dec,value[1]);
    IniSettings::GetInstance()->setValue(IniType::motion_vel,value[2]);
}



QString LightSwitch::getCurPos(int index)
{
    double pos=0;
    if(index==4){

        if(GtMotion::GetInstance()->GetCurPosMM(1,pos))
            return QString::number(pos,'f',2);
        return tr("error");
    }
    if(A3200Api::GetInstance()->GetFeedBackPos(index,pos)){
        return QString::number(pos,'f',3);
    }
    return tr("error");
}
