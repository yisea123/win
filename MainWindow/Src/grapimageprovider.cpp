#include "grapimageprovider.h"



GrapImageProvider::GrapImageProvider():QQuickImageProvider(QQuickImageProvider::Image)
{

}

QImage GrapImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    return this->img;
}

QPixmap GrapImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
     return QPixmap::fromImage(this->img);
}
