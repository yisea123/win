#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QObject>
#include <QThread>
#include "programio.h"
#include <QTranslator>
#include <QWaitCondition>
#include <QMutex>
#include <QTimer>


class RunProgram : public QThread
{
    Q_OBJECT
public:
    explicit RunProgram(QObject *parent = nullptr);
    ~RunProgram() Q_DECL_OVERRIDE;

    long count;
    QString runPath;
    double step,focusY,focusZ,waitY,waitZ;
    bool isLaser,ischeckTube,isAutoBack,isGas,iscloseDoor;
    long mcs,prf,psn,t1s;


    QMutex lastM;

    struct lastError
    {
       int type;
       QString lastNote;
    } note;


signals:
    void _runDone(int returnCode,QString msg);
public slots:
    void checkCondition();




protected:

    void unexpectExit(int type,QString code);
    void runCompleted(QString code);

    bool setFixtrue1(bool value);
    bool setFixtrue2(bool value);



    QMutex m_mutex;
    QTimer timer;
    QTimer compaleted;
    void run() Q_DECL_OVERRIDE;

};

class MainWindow : public QObject
{
    Q_OBJECT
public:
//    explicit MainWindow(QObject *parent = nullptr);
 //~MainWindow() Q_DECL_OVERRIDE;

    static MainWindow* GetInstance();
    static void Release();

     void openProgramFile(QString filepath);
private:
    explicit MainWindow(QObject *parent = nullptr);
    static MainWindow* m_pInstance;
     ~MainWindow() Q_DECL_OVERRIDE;

Q_SIGNALS:

    void to_openProgram(QString filePath);

    void programVauleChanged(long long index,QString value);

    void programChanged(QString name);

    void programDone(int msgType,QString msg);

    void languageChanged(QString lang);

    void programEnded();

    void programLoaded();


public Q_SLOTS:
    void setValue(long long index,QString value);
    QString getValue(long long index);

    int newProgram();
    bool saveProgram();
    bool saveProgramAs();
    bool openProgram();
    bool openProgramPath(QString path);

    bool laserOn();
    bool laseroff();

    void setNew();

    void isModified(bool value);

    void switchStyle(QString name);
    QString getStyle();
    void setLanguage(QString value);
    QString getLanguage();


    bool runProgram();
    bool pauseProgram();
    bool continueProgram();
    bool stopProgram();


    void moveToWait();
    void moveToFocus();


    bool switchSystem(bool isMain);
    bool switchLaser(bool isGreen);


    bool exitApp();

private:

    QWaitCondition m_waitCondition;

    bool isModify;
    RunProgram *run;
    QString programFilePath;
    QString programRunPath;
    ProgramIO*program;
};

class Translator : public QTranslator
{
    Q_OBJECT
public:
    static Translator* inst();

signals:
    void languageChanged(QString language);

public slots:
    void loadLanguage(QString iLang);


private:
    static Translator* m_pInstance;
    Translator(QObject *parent = nullptr);
};


#endif // MAINWINDOW_H
