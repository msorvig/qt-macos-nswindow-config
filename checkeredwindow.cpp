#include "checkeredwindow.h"

CheckeredWindow::CheckeredWindow()
:m_enableDrag(false)
,m_pressed(false)
,m_color(40, 80, 130, 255)
{

}

CheckeredWindow::~CheckeredWindow()
{

}

void CheckeredWindow::setDragEnabled(bool enable)
{
    m_enableDrag = enable;
}

void CheckeredWindow::setOpaqueFormat(bool enable)
{
    // Opaque windows do not have an alpha channel and are guaranteed
    // to fill their entire content area. This guarantee is propagated
    // to Cocoa via the NSView opaque property.
    QSurfaceFormat format;
    format.setAlphaBufferSize(enable ? 0 : 8);
    setFormat(format);
}

void CheckeredWindow::setColor(QColor color)
{
    m_color = color;
}

void CheckeredWindow::paintEvent(QPaintEvent * event)
{
    QRect r = event->rect();

    QPainter p(this);

    QColor fillColor = m_color;
    QColor fillColor2 = fillColor.darker();

    int tileSize = 40;
    for (int i = -tileSize * 2; i < r.width() + tileSize * 2; i += tileSize) {
        for (int j = -tileSize * 2; j < r.height() + tileSize * 2; j += tileSize) {
            QRect rect(i + (m_offset.x() % tileSize * 2), j + (m_offset.y() % tileSize * 2), tileSize, tileSize);
            int colorIndex = abs((i/tileSize - j/tileSize) % 2);
            p.fillRect(rect, colorIndex == 0 ? fillColor : fillColor2);
        }
    }

    QRect g = geometry();
    QString text;
    text += QString("Size: %1 %2\n").arg(g.width()).arg(g.height());

    QPen pen;
    pen.setColor(QColor(255, 255, 255, 200));
    p.setPen(pen);
    p.drawText(QRectF(0, 0, width(), height()), Qt::AlignCenter, text);
}
void CheckeredWindow::mouseMoveEvent(QMouseEvent * ev)
{
    if (!m_enableDrag)
        return;

    if (m_pressed)
        m_offset += ev->localPos().toPoint() - m_lastPos;
    m_lastPos = ev->localPos().toPoint();
    update();
}

void CheckeredWindow::mousePressEvent(QMouseEvent *)
{
    m_pressed = true;
}

void CheckeredWindow::mouseReleaseEvent(QMouseEvent *)
{
    m_pressed = false;
}
