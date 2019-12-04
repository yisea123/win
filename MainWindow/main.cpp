#pragma once
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QSharedMemory>
#include <QMessageBox>
#include <QObject>
#include <QFontDatabase>
#include <QDebug>
#include <QQuickStyle>
#include <QQmlContext>
#include <QThread>
#include <QDateTime>
#include <QFile>
#include <QDir>
#include <QFileInfo>
#include <QTextCodec>
#include <QTranslator>
#include <QTimer>

#include <Windows.h>
#include <DbgHelp.h>
#include <QIcon>


#include "Qml/textEditor/documenthandler.h"
#include "Src/deviceinit.h"
#include "Src/statehandler.h"
#include "Src/motionhandler.h"
#include "Src/mainwindow.h"
#include "Src/hserialportlaser.h"
#include "Src/laserui.h"
#include "Src/grapimageprovider.h"
#include "Src/stcamera.h"
#include "Src/advancesetting.h"
#include "Src/inisettings.h"
#include "Src/lightswitch.h"



LONG ApplicationCrashHandler(EXCEPTION_POINTERS *pException){

    /*

      ***save your data here***

    */

    //create Dump file
    //    SYSTEMTIME lpSystemTime ;
    //    GetLocalTime(&lpSystemTime );
    //    QString time=QString::number(lpSystemTime.wYear)+"-"+QString::number(lpSystemTime.wMonth)+"-"+QString::number(lpSystemTime.wDay)+"_"+
    //            QString::number(lpSystemTime.wHour)+QString::number(lpSystemTime.wMinute)+QString::number(lpSystemTime.wSecond)
    //            +QString::number(lpSystemTime.wMilliseconds)+QString::number(lpSystemTime.wDayOfWeek);

    QString path=(QCoreApplication::applicationDirPath()+"/Log/"+QDateTime::currentDateTime().toString("yyyy-MM-dd_hh-mm-ss-zzz_dddd")+".dump");
    HANDLE hDumpFile = CreateFile(path.toStdWString().c_str(),GENERIC_WRITE, 0, nullptr, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);

    if( hDumpFile != INVALID_HANDLE_VALUE){

        //Dump info
        MINIDUMP_EXCEPTION_INFORMATION dumpInfo;
        dumpInfo.ExceptionPointers = pException;
        dumpInfo.ThreadId = GetCurrentThreadId();
        dumpInfo.ClientPointers = TRUE;

        //write dump data
        MiniDumpWriteDump(GetCurrentProcess(), GetCurrentProcessId(), hDumpFile, MiniDumpNormal, &dumpInfo, nullptr, nullptr);
        CloseHandle(hDumpFile);

    }
    else{
        qCritical()<<"hDumpFile == null";
    }

    //pop-up a dialog and exit process
    EXCEPTION_RECORD* record = pException->ExceptionRecord;
    QString errCode(QString::number(record->ExceptionCode,16)),errAdr(QString::number(reinterpret_cast<uint>(record->ExceptionAddress),16)),errMod;
    QMessageBox::critical(nullptr,QString::fromLocal8Bit("process crashed"),QString::fromLocal8Bit("<FONT size=4><div><b> An unexpected error caused your application to terminate!</b><br/></div>")+
                          QString(QString::fromLocal8Bit("<div>error code：%1</div><div>error memory addres：%2</div></b><br/></FONT>")).arg(errCode).arg(errAdr)
                          +QString::fromLocal8Bit("<FONT size=4><div> contact us to report bug: hongjianli@inno-laser.com</b><br/></div>"),QMessageBox::Ok);
    qFatal("Process Crashed");
    return EXCEPTION_EXECUTE_HANDLER;
}


void registerFileRelation(const QString& className,const QString& appPath,const QString& ext,const QString& extDes)
{

    //    QString className("xxx.yyy.com");                           // 自定义的类别

    //    QString appPath("D:\\Program Files\\MyProgram.exe");        // 关联的程序目录

    //    QString ext(".proj");                                       // 关联的文件类型

    //    QString extDes("xx 工程文件");                              // 该文件类型描述

    QString baseUrl("HKEY_CURRENT_USER\\Software\\Classes");    // 要添加的顶层目录
    QSettings settingClasses(baseUrl,QSettings::NativeFormat);

    // 在...Classes\类别下创建一个新的类别，并设置该类别打开文件时的调用参数
    settingClasses.setValue("/" + className + "/Shell/Open/Command/.","\"" + appPath + "\" \"%1\"");

    // 文件类型描述
    settingClasses.setValue("/" + className + "/.",extDes);

    // 设置该类别的默认图标默认图标
    settingClasses.setValue("/" + className + "/DefaultIcon/.",appPath + ",1");
    // 关联ext 和 类别
    settingClasses.setValue("/" + ext + "/OpenWithProgIds/" + className,"");

    // 立即保存该修改
    settingClasses.sync();

}


void outputMessage(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    static QMutex mutex;
    mutex.lock();

    QString text;
    switch(type)
    {
    case QtDebugMsg:
        text = "Debug: ";
        break;
    case QtWarningMsg:
        text = "Warning: ";
        break;
    case QtCriticalMsg:
        text = "Critical: ";
        break;
    case QtInfoMsg:
        text = "Info: ";
        break;
    case QtFatalMsg:
        text = "Fatal: ";
        break;
    }

    QString context_info = QString("File:(%1) Line:(%2) Function:(%3)").arg(QString(context.file)).arg(context.line).arg(context.function);
    QString current_date_time = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss:zzz dddd");
    QString current_date = QString("(%1)").arg(current_date_time);
    QString message = QString("%1 %2 %3 %4").arg(text).arg(context_info).arg(msg).arg(current_date);

    QFile file(QCoreApplication::applicationDirPath()+"/Log/log.log");
    file.open(QIODevice::WriteOnly | QIODevice::Append);
    QTextStream text_stream(&file);
    text_stream << message << "\r\n";
    file.flush();
    file.close();
    mutex.unlock();

    if(text==QString("Fatal:"))
        quick_exit(-3);
}

quint64 dirFileSize(const QString &path)
{
    QDir dir(path);
    quint64 size = 0;
    //dir.entryInfoList(QDir::Files)返回文件信息
    foreach(QFileInfo fileInfo, dir.entryInfoList(QDir::Files))
    {
        //计算文件大小
        size += fileInfo.size();
    }
    //dir.entryList(QDir::Dirs|QDir::NoDotAndDotDot)返回所有子目录，并进行过滤
    foreach(QString subDir, dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot))
    {
        //若存在子目录，则递归调用dirFileSize()函数
        size += dirFileSize(path + QDir::separator() + subDir);
    }
    return size;
}

bool DelDir(const QString &path)
{
    if (path.isEmpty())
        return false;
    QDir dir(path);
    if(!dir.exists())
        return true;
    dir.setFilter(QDir::AllEntries | QDir::NoDotAndDotDot); //设置过滤
    QFileInfoList fileList = dir.entryInfoList(); // 获取所有的文件信息
    foreach (QFileInfo file, fileList){ //遍历文件信息
        if (file.isFile()){ // 是文件，删除
            file.dir().remove(file.fileName());
        }else{ // 递归删除
            DelDir(file.absoluteFilePath());
        }
    }
    return dir.rmpath(dir.absolutePath()); // 删除文件夹
}



int main(int argc, char *argv[])
{

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    SetUnhandledExceptionFilter((LPTOP_LEVEL_EXCEPTION_FILTER)ApplicationCrashHandler);// for dump
    qInstallMessageHandler(outputMessage); //for log

    QQuickStyle::setStyle(":/qtquickcontrols2");
    QQuickStyle::setFallbackStyle(IniSettings::GetInstance()->getValue(IniType::view_style));
    //QQuickStyle::setStyle(IniSettings::GetInstance()->getValue(IniType::view_style));//for style

    if(dirFileSize(QCoreApplication::applicationDirPath()+"/Log")>1073741824){//del log file
        DelDir(QCoreApplication::applicationDirPath()+"/Log");
    }

    app.setWindowIcon(QIcon("inno.ico"));//set app icon

    QTextCodec::setCodecForLocale(QTextCodec::codecForLocale());

    //for multiple language
    Translator::inst()->loadLanguage(IniSettings::GetInstance()->getValue(IniType::view_lang));
    app.installTranslator(Translator::inst());

    if(IniSettings::GetInstance()->getValue(IniType::view_lang)=="zh"){
       app.setFont(QFont("Microsoft YaHei UI", 9));
    }
    else{
       app.setFont(QFont("calibri",11));
    }

    registerFileRelation("hongjianli",argv[0],".hpro","AOC Laser");//associate file type
    //QQuickStyle::setStyle("Material"); //for theme

    QSharedMemory *g_pShareMem = new QSharedMemory(QString("centralMoniSystem"));
    int nIndex = 1;
    while (nIndex--){
        if (g_pShareMem->attach(/*QSharedMemory::ReadOnly*/)){
            if(QString(argv[1]).isEmpty()){
                QMessageBox::information(nullptr,QObject::tr("warning"),QObject::tr("Application is running!!!"));
            }
            else{
                g_pShareMem->lock();
                char * to = static_cast<char*>( g_pShareMem->data());
                const char * from = QString(argv[1]).toStdString().data();
                memcpy(to, from, strlen(from));
                g_pShareMem->unlock();

            }
            g_pShareMem->detach();
        }
    }
    if (g_pShareMem->create(2048)){
        QQmlApplicationEngine engine;
        engine.rootContext()->setContextProperty("CodeImage",StCamera::GetInstance());
        engine.addImageProvider(QLatin1String("CodeImg"), StCamera::GetInstance()->m_pImgProvider);
        QFontDatabase fontDatabase;
        if(fontDatabase.addApplicationFont(":/Qml/textEditor/fonts/fontello.ttf") == -1){
            qWarning() << "Failed to load fontello.ttf";
            return -1;
        }
        qmlRegisterType<DeviceInit>("mydeviceinit", 1, 0, "DeviceInit");
        qmlRegisterType<DocumentHandler>("mytexteditor", 1, 0, "DocumentHandler");
        engine.rootContext()->setContextProperty("myLaser",LaserUI::GetInstance());
        engine.rootContext()->setContextProperty("myMainWindow",MainWindow::GetInstance());

        engine.rootContext()->setContextProperty("myState",StateHandler::GetInstance());
        qmlRegisterType<MotionHandler>("myMotion", 1, 0, "MotionHandler");
        qmlRegisterType<AdvanceSetting>("myAdvance", 1, 0, "AdvanceSetting");
        qmlRegisterType<LightSwitch>("myLightSwitch", 1, 0, "LightSwitch");


        engine.load(QUrl(QStringLiteral("qrc:/Qml/InitDevice.qml")));
        if (engine.rootObjects().isEmpty()){
            qCritical() << "Failed to load InitDevice.qml";
            return -1;
        }
        if(app.exec()!=0)
            return -1;
        if(DeviceInit::isEXIT==1)
            return 0;
        engine.load(QUrl(QStringLiteral("qrc:/Qml/main.qml")));
        if (engine.rootObjects().isEmpty()){
            qCritical() << "Failed to load main.qml";
            return -1;
        }

        if(!QString(argv[1]).isEmpty()){
            MainWindow::GetInstance()->openProgramFile(QString(argv[1]).replace('\\','/'));
        }

        QTimer *timer=new QTimer;
        QObject::connect(timer, &QTimer::timeout, [=](){
            if (g_pShareMem->isAttached()){
                g_pShareMem->lock();
                char * from = static_cast<char*>(g_pShareMem->data());
                char * to = static_cast<char*>(malloc(2048));
                QString str(strcpy(to,from));
                if(!str.isEmpty()){
                    MainWindow::GetInstance()->openProgramFile(str.replace('\\','/'));
                }
                memset(from,0,strlen(from));
                free(to);
                g_pShareMem->unlock();
            }});
        timer->start(200);

        if(app.exec()!=0)
            return -1;
        if (g_pShareMem->isAttached()){
            timer->stop();
            g_pShareMem->detach();
        }
        delete g_pShareMem;
        g_pShareMem = nullptr;
        return 0;
    }
}
