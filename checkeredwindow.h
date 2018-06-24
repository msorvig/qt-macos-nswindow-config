#ifndef CHECKEREDWINDOW_H
#define CHECKEREDWINDOW_H

#include <QtGui>

class CheckeredWindow : public QRasterWindow
{
Q_OBJECT
public:
    CheckeredWindow();
    ~CheckeredWindow();

    void setDragEnabled(bool enable);
    void setOpaqueFormat(bool enable);
    void setColor(QColor color);

    void paintEvent(QPaintEvent * event);
    void mouseMoveEvent(QMouseEvent * ev);
    void mousePressEvent(QMouseEvent * ev);
    void mouseReleaseEvent(QMouseEvent * ev);
private:
    bool m_enableDrag;
    int m_drawAlpha;
    bool m_pressed;
    bool m_emitCloseOnClick;

    QPoint m_offset;
    QPoint m_lastPos;
    QColor m_color;
};

#endif
