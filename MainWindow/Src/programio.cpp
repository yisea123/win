#include "programio.h"

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonValue>
#include <QJsonObject>
#include <QFile>
#include <QDebug>
#include <QCoreApplication>
#include <QSettings>
#include <QTime>



ProgramIO::ProgramIO(QObject *parent) : QObject(parent)
{

}


bool ProgramIO::readFile(const QString &filePath)
{
    QString ret;
    QFile file(filePath);

    if (file.open(QFile::ReadOnly))
    {
        auto byteArray = file.readAll();
        QJsonParseError jsonError;
        QJsonDocument doucment = QJsonDocument::fromJson(byteArray, &jsonError);
        if (!doucment.isNull() && (jsonError.error == QJsonParseError::NoError)) {
            if (doucment.isObject()) {
                QJsonObject object = doucment.object();
                if (object.contains("Name")) {
                    QJsonValue value = object.value("Name");
                    if (value.isString()) {
                        QString strName = value.toString();

                    }
                }
                if (object.contains("User")) {
                    QJsonValue value = object.value("User");
                    if (value.isString()) {
                        QString strCompany = value.toString();

                    }
                }
                if (object.contains("Version")) {
                    QJsonValue value = object.value("Version");
                    if (value.isDouble()) {
                        int nFrom = value.toVariant().toInt();


                    }
                }

                //                if (object.contains("Laser")) {
                //                    QJsonValue value = object.value("Laser");
                //                    if (value.isArray()) {
                //                        QJsonArray array = value.toArray();
                //                        int nSize = array.size();
                //                        for (int i = 0; i < nSize; ++i) {
                //                            QJsonValue value = array.at(i);
                //                            if (value.isDouble()) {
                //                                int dVersion = value.toInt();
                //                                //hashInfo.insert(i+ParaType::Laser_gtr, QString::number(dVersion, 10));
                //                                qDebug() << "Laser : " << dVersion;
                //                            }
                //                        }
                //                    }
                //                }

                if (object.contains("Page")) {
                    QJsonValue value = object.value("Page");
                    if (value.isObject()) {  // Page 的 value 是对象
                        QJsonObject obj = value.toObject();
                        if (obj.contains("Laser")) {
                            QJsonValue value = obj.value("Laser");
                            if (value.isArray()) {
                                QJsonArray array = value.toArray();
                                int nSize = array.size();
                                for (int i = 0; i < nSize; ++i) {
                                    QJsonValue value = array.at(i);
                                    if (value.isString()) {
                                        //hashInfo.insert(i+ParaType::Flow_currentPosStart, value.toString());
                                    }
                                }
                            }
                        }
                        if (obj.contains("Flow")) {
                            QJsonValue value = obj.value("Flow");
                            if (value.isArray()) {
                                QJsonArray array = value.toArray();
                                int nSize = array.size();
                                for (int i = 0; i < nSize; ++i) {
                                    QJsonValue value = array.at(i);
                                    if (value.isString()) {
                                        hashInfo.insert(i+ParaType::Flow_Focus_Y, value.toString());
                                    }
                                }

                            }
                        }
                        if (obj.contains("A3200Code")) {
                            QJsonValue value = obj.value("A3200Code");
                            if (value.isString()) {
                                hashInfo.insert(ParaType::A3200Code, value.toString());
                            }
                        }
                    }
                }
            }
        }
        return true;
    }
    else
    {
        return false;
    }
}

bool ProgramIO::writeFile(const QString &filePath)
{

    QFile file(filePath);
    if (file.open(QFile::WriteOnly)){
        // 构建 Json 数组 - Version
        QJsonArray laserArray;

//        for(long long a=ParaType::LaserSTART_mcs;a<ParaType::LaserOVER_T1S+1;++a){
//            laserArray.append(hashInfo.value(a));
//        }

        QJsonArray FlowArray;

        for(long long a=ParaType::Flow_Focus_Y;a<ParaType::Flow_processCount+1;++a){

            FlowArray.append(hashInfo.value(a));
        }

        // 构建 Json 对象 - Page
        QJsonObject pageObject;
        //pageObject.insert("Laser",QJsonValue(laserArray));
        pageObject.insert("Flow",QJsonValue(FlowArray));
        pageObject.insert("A3200Code",hashInfo.value(ParaType::A3200Code));
        pageObject.insert("Developers", "hongjianli");

        // 构建 Json 对象
        QJsonObject json1;
        json1.insert("Name", "Qt");
        json1.insert("User", "hongjianli");
        json1.insert("Version", 1.0);
        json1.insert("Time",QTime::currentTime().toString());
        json1.insert("Page", QJsonValue(pageObject));

        // 构建 Json 文档
        QJsonDocument document;
        document.setObject(json1);

        QByteArray byteArray = document.toJson(QJsonDocument::Compact);
        QString strJson(byteArray);


        auto json = QJsonDocument::fromJson(strJson.toUtf8());
        auto data  = json.toJson();


        file.write(data);

        file.close();
        return true;
    }
    else{
        return false;
    }
}
