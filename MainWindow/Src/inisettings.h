#ifndef INISETTINGS_H
#define INISETTINGS_H

#include <QObject>
#include <QHash>
#include <QSettings>

enum IniType{view_lang=0,view_style,motion_vel,motion_acc,motion_dec ,lightSwitch_step,lightSwitch_pos
            ,position_wait_y,position_wait_z,State_isWarning,isAutoback};

class IniSettings
{

public:
    static IniSettings* GetInstance();
    static void Release();


    void writeData();
    QString getValue(IniType index);
    void setValue(IniType index,const QString& value);
private:
    explicit IniSettings();
    ~IniSettings();
    void initData();

    static IniSettings* m_pInstance;

    QHash<int, QString> hashInfo;
    QSettings *configIni;

    const QStringList iniName={"/view/language","/view/style","/motion/vel","/motion/acc","/motion/dec","/lightSwitch/step","/lightSwitch/pos"
                              ,"/waitPosition/y","/waitPosition/z","/State/isWarning","/State/isAutoback"};



};

#endif // INISETTINGS_H
