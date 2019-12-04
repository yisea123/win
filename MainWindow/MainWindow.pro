QT += quick
QT += quickcontrols2
TEMPLATE = app
CONFIG += c++11
QT += widgets
QT += core
QT += quick qml multimedia multimediawidgets
QT += charts
#qtHaveModule(widgets): QT += widgets

DEFINES += QT_MESSAGELOGCONTEXT
QMAKE_LFLAGS_RELEASE = /INCREMENTAL:NO /DEBUG

QMAKE_LFLAGS += /MANIFESTUAC:\"level=\'requireAdministrator\' uiAccess=\'false\'\"

VERSION = 1.0.0.0

# 0x0004 mean zh
# for detail https://msdn.microsoft.com/en-us/library/dd318693%28vs.85%29.aspx
RC_LANG = 0x0409
RC_ICONS += inno.ico
RC_ICONS += file.ico

QMAKE_TARGET_COMPANY = AOC LASER
QMAKE_TARGET_PRODUCT = AOC Stent Laser Cutting System
QMAKE_TARGET_DESCRIPTION = AOC
QMAKE_TARGET_COPYRIGHT = Copyright(C) 2018 AOC


TARGET = AOC

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

TRANSLATIONS +=Resource/tr_zh.ts \
               Resource/tr_en.ts



SOURCES += \
    Src/hserialportlaser.cpp \
    Qml/textEditor/documenthandler.cpp \
    Src/deviceinit.cpp \
    Src/statehandler.cpp \
    Src/mythreadworker.cpp \
    Src/motionhandler.cpp \
    Src/GtMotion.cpp \
    Src/programio.cpp \
    Src/mainwindow.cpp \
    Src/laserui.cpp \
    Src/grapimageprovider.cpp \
    Src/stcamera.cpp \
    Src/advancesetting.cpp \
    main.cpp \
    Src/A3200Api.cpp \
    Src/inisettings.cpp \
    Src/lightswitch.cpp

LIBS+= "$$PWD/Src/GTS/64bit/single_card/gts.lib"
LIBS+= "$$PWD/Src/A3200/Lib64/A3200C64.lib"




RESOURCES += \
    myicons.qrc \
    qml.qrc\


HEADERS += \
    Src/hserialportlaser.h \
    Qml/textEditor/documenthandler.h \
    Src/A3200/Include/A3200.h \
    Src/A3200/Include/A3200AeroBasicCommands.h \
    Src/A3200/Include/A3200Callback.h \
    Src/A3200/Include/A3200Commands.h \
    Src/A3200/Include/A3200CommonStructures.h \
    Src/A3200/Include/A3200CommonTypes.h \
    Src/A3200/Include/A3200Configuration.h \
    Src/A3200/Include/A3200Connection.h \
    Src/A3200/Include/A3200DataCollection.h \
    Src/A3200/Include/A3200DataCollectionInfo.h \
    Src/A3200/Include/A3200EnumNames.h \
    Src/A3200/Include/A3200Error.h \
    Src/A3200/Include/A3200ErrorCode.h \
    Src/A3200/Include/A3200Information.h \
    Src/A3200/Include/A3200MessageCallbacks.h \
    Src/A3200/Include/A3200Parameter.h \
    Src/A3200/Include/A3200ParameterId.h \
    Src/A3200/Include/A3200Program.h \
    Src/A3200/Include/A3200Status.h \
    Src/A3200/Include/A3200StatusItemInfo.h \
    Src/A3200/Include/A3200Variable.h \
    Src/GTS/64bit/single_card/gts.h \
    Src/A3200Api.h \
    Src/deviceinit.h \
    Src/statehandler.h \
    Src/mythreadworker.h \
    Src/motionhandler.h \
    Src/GtMotion.h \
    Src/programio.h \
    Src/mainwindow.h \
    Src/laserui.h \
    Src/StCamera/StTrgApi.h \
    Src/grapimageprovider.h \
    Src/stcamera.h \
    Common/qtcommon.h \
    Src/advancesetting.h \
    Src/inisettings.h \
    Src/lightswitch.h




win32: LIBS += -L$$PWD/Src/StCamera/ -lStTrgApi
LIBS += -lDbgHelp

INCLUDEPATH += $$PWD/Src/StCamera
DEPENDPATH += $$PWD/Src/StCamera

INCLUDEPATH += $$PWD/ffmpeg/include
DEPENDPATH += $$PWD/ffmpeg/include

win32: LIBS += -L$$PWD/ffmpeg/lib/ -lavcodec

win32:!win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/avcodec.lib
else:win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/libavcodec.a

win32: LIBS += -L$$PWD/ffmpeg/lib/ -lavdevice

win32:!win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/avdevice.lib
else:win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/libavdevice.a

win32: LIBS += -L$$PWD/ffmpeg/lib/ -lavfilter

win32:!win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/avfilter.lib
else:win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/libavfilter.a

win32: LIBS += -L$$PWD/ffmpeg/lib/ -lavformat

win32:!win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/avformat.lib
else:win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/libavformat.a

win32: LIBS += -L$$PWD/ffmpeg/lib/ -lavutil

win32:!win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/avutil.lib
else:win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/libavutil.a


win32: LIBS += -L$$PWD/ffmpeg/lib/ -lpostproc


win32:!win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/postproc.lib
else:win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/libpostproc.a

win32: LIBS += -L$$PWD/ffmpeg/lib/ -lswresample

win32:!win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/swresample.lib
else:win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/libswresample.a


win32: LIBS += -L$$PWD/ffmpeg/lib/ -lswscale

win32:!win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/swscale.lib
else:win32-g++: PRE_TARGETDEPS += $$PWD/ffmpeg/lib/libswscale.a





