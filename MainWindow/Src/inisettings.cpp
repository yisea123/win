#include "inisettings.h"
#include <QFileInfo>
#include <QCoreApplication>



IniSettings* IniSettings::m_pInstance = nullptr;

IniSettings *IniSettings::GetInstance()
{
    if(m_pInstance == nullptr)
    {
        m_pInstance = new IniSettings();
        atexit(Release);
    }
    return m_pInstance;
}
void IniSettings::Release()
{
    if(m_pInstance)
    {

        delete m_pInstance;
        m_pInstance = nullptr;
    }
}

void IniSettings::writeData()
{
    if(!hashInfo.isEmpty()){
        for(int k=0;k<hashInfo.count();++k)
            configIni->setValue(iniName[k], hashInfo.value(k));
    }
}

void IniSettings::initData()
{
    QString iniPath=QCoreApplication::applicationDirPath()+"/settings/user.ini";
    QFileInfo fileInfo(iniPath);

    if(!fileInfo.exists())
    {
        configIni = new QSettings(iniPath, QSettings::IniFormat);

        configIni->setValue(iniName.at(IniType::view_lang), "en");
        configIni->setValue(iniName.at(IniType::view_style), "Material");

        configIni->setValue(iniName.at(IniType::motion_vel), 15);
        configIni->setValue(iniName.at(IniType::motion_acc), 100);
          configIni->setValue(iniName.at(IniType::motion_dec), 100);

        configIni->setValue(iniName.at(IniType::lightSwitch_step), 0.1);
        configIni->setValue(iniName.at(IniType::lightSwitch_pos), 0);


        configIni->setValue(iniName.at(IniType::position_wait_y), 0);
        configIni->setValue(iniName.at(IniType::position_wait_z), 0);



         configIni->setValue(iniName.at(IniType::State_isWarning), 1);
         configIni->setValue(iniName.at(IniType::isAutoback), 0);
    }
    else{
        configIni= new QSettings(iniPath, QSettings::IniFormat);

    }
    hashInfo.insert(IniType::view_lang,configIni->value(iniName.at(IniType::view_lang)).toString());
    hashInfo.insert(IniType::view_style,configIni->value(iniName.at(IniType::view_style)).toString());

    hashInfo.insert(IniType::motion_vel,configIni->value(iniName.at(IniType::motion_vel)).toString());
    hashInfo.insert(IniType::motion_acc,configIni->value(iniName.at(IniType::motion_acc)).toString());
    hashInfo.insert(IniType::motion_dec,configIni->value(iniName.at(IniType::motion_dec)).toString());

    hashInfo.insert(IniType::lightSwitch_step,configIni->value(iniName.at(IniType::lightSwitch_step)).toString());
    hashInfo.insert(IniType::lightSwitch_pos,configIni->value(iniName.at(IniType::lightSwitch_pos)).toString());

     hashInfo.insert(IniType::position_wait_y,configIni->value(iniName.at(IniType::position_wait_y)).toString());
      hashInfo.insert(IniType::position_wait_z,configIni->value(iniName.at(IniType::position_wait_z)).toString());


    hashInfo.insert(IniType::State_isWarning,configIni->value(iniName.at(IniType::State_isWarning)).toString());
    hashInfo.insert(IniType::isAutoback,configIni->value(iniName.at(IniType::isAutoback)).toString());


}

QString IniSettings::getValue(IniType index)
{
    if(!hashInfo.isEmpty()){
        return hashInfo.value(index);
    }
    else{
        return "";
    }
}


void IniSettings::setValue(IniType index, const QString &value)
{
    hashInfo.insert(index,value);
    configIni->setValue(iniName.at(index),value);
}


IniSettings::IniSettings()
{

    initData();
}

IniSettings::~IniSettings()
{
    writeData();
    delete configIni;
}
