#include <QtCore/QtCore>
#include <QtGui/QtGui>

// MacWindow provides a Qt C++ API for creating NSWindows in
// various configuartions. The idea is to make it possible to
// quickly test window configurations from C++ code. This API is not
// complete and shold be used as a starting point for a custom implementation. 

Q_FORWARD_DECLARE_OBJC_CLASS(NSWindow);

class MacWindow
{
public:
    MacWindow(QWindow *contentWindow, QWindow *accessoryWindow = nullptr);
    
    // Content Windows
    void setContentWindow(QWindow *contentWindow);
    void setLeftAcccessoryWindow(QWindow *leftAccessoryWindow);
    void setRightAcccessoryWindow(QWindow *rightAccessoryWindow);
    
    // NSWindow properties
    void setFullSizeContentView(bool enable);
    bool fullSizeContentView() const;
    void setTitlebarAppearsTransparent(bool enable);
    bool titlebarAppearsTransparent() const;
    void setMovableByWindowBackgropund(bool enable);
    bool movableByWindowBackgropund() const;
    void setToolbarEnabled(bool enable);
    bool toolbarEnabled() const;
    void setShowsBaselineSeparator(bool enable);
    bool showsBaselineSeparator() const;
    void setTitleVisibility(bool enable);
    bool titleVisibility() const;
    void setTitleText(const QString &text);
    QString titleText() const;
    void setAccessoryViewsEnabled(bool enable);
    bool acceoryViews() const;

    // Duplicated QWindow API
    void setGeometry(QRect geometry);
    QRect geometry() const;
    void setSize(QSize &size);
    QSize size() const;
    void setVisible(bool visible);
    void show();
protected:
    void createNSWindow();
    void destroyNSWindow();
    void recreateNSWindow();
    void scheduleRecreateNSWindow();

private:
    QWindow *m_window = nullptr;
    QWindow *m_accessoryWindow = nullptr;
    QWindow *m_rightAccessoryWindow = nullptr;
    NSWindow *m_nsWindow = nullptr;
    QRect m_geometry;
    QString m_titleText;
    bool m_visible;
    
    bool m_fullSizeContentView = false;
    bool m_titlebarAppearsTransparent = false;
    bool m_movableByWindowBackground = false;
    bool m_toolbarEnabled = false;
    bool m_showsBaselineSeparator = false;
    bool m_titleVisibility = true;
    bool m_accessoryView = false;
};
