#ifndef GRAPIMAGEPROVIDER_H
#define GRAPIMAGEPROVIDER_H
#pragma once

#include <QImage>
#include <QQuickImageProvider>

class GrapImageProvider :  public QQuickImageProvider
{

public:
    GrapImageProvider();


    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);

    QImage img;


private:


};

#endif // GRAPIMAGEPROVIDER_H
