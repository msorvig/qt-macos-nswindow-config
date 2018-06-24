#include "macwindow.h"

#import <AppKit/AppKit.h>

// An NSTitlebarAccessoryViewController that controls a programatically created view
@interface ProgramaticViewController : NSTitlebarAccessoryViewController
@end

@implementation ProgramaticViewController
- (id)initWithView: (NSView *)aView
{
    self = [self init];
    self.view = aView;
    return self;
}
@end

MacWindow::MacWindow(QWindow *window, QWindow *accessoryWindow)
:m_window(window)
,m_accessoryWindow(accessoryWindow)
{

}

void MacWindow::setContentWindow(QWindow *contentWindow)
{
    m_window = contentWindow;
    scheduleRecreateNSWindow();
}

void MacWindow::setLeftAcccessoryWindow(QWindow *leftAccessoryWindow)
{
    m_accessoryWindow = leftAccessoryWindow;
    scheduleRecreateNSWindow();
}

void MacWindow::setRightAcccessoryWindow(QWindow *rightAccessoryWindow)
{
    m_rightAccessoryWindow = rightAccessoryWindow;
    scheduleRecreateNSWindow();
}

void MacWindow::createNSWindow()
{
    qDebug() << "createNSWindow";
    if (m_nsWindow)
        return;
    
    auto styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |
                     NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
    
    if (m_fullSizeContentView)
        styleMask |= NSFullSizeContentViewWindowMask;
                
    NSRect frame = NSMakeRect(200, 200, 320, 200);
    m_nsWindow =
        [[NSWindow alloc] initWithContentRect:frame
                                    styleMask:styleMask
                                      backing:NSBackingStoreBuffered
                                        defer:NO];

    m_nsWindow.titleVisibility = m_titleVisibility ? NSWindowTitleVisible : NSWindowTitleHidden;
    m_nsWindow.title = m_titleText.toNSString();
    m_nsWindow.titlebarAppearsTransparent = m_titlebarAppearsTransparent;
    m_nsWindow.movableByWindowBackground = m_movableByWindowBackground;
    if (m_toolbarEnabled) {
        NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"main"];
        toolbar.showsBaselineSeparator = m_showsBaselineSeparator;
        m_nsWindow.toolbar = toolbar;
    }
    m_nsWindow.contentView = (__bridge NSView *)reinterpret_cast<void *>(m_window->winId());
    
    // Accessory View
    if (m_accessoryView) {
        {
            NSView *view = (__bridge NSView *)reinterpret_cast<void *>(m_accessoryWindow->winId());
            ProgramaticViewController *viewController = [[ProgramaticViewController alloc] initWithView:view];
            viewController.layoutAttribute = NSLayoutAttributeLeft;
            [m_nsWindow addTitlebarAccessoryViewController:viewController];
        }
        {
            NSView *view = (__bridge NSView *)reinterpret_cast<void *>(m_rightAccessoryWindow->winId());
            ProgramaticViewController *viewController = [[ProgramaticViewController alloc] initWithView:view];
            viewController.layoutAttribute = NSLayoutAttributeRight;
            [m_nsWindow addTitlebarAccessoryViewController:viewController];
        }
    }
}

void MacWindow::destroyNSWindow()
{
    @autoreleasepool {
        [m_nsWindow close];
        m_nsWindow = nil;
    }
}

void MacWindow::recreateNSWindow()
{
    if (!m_nsWindow)
        return;
    
    destroyNSWindow();
    createNSWindow();
    
    if (m_visible)
        [m_nsWindow makeKeyAndOrderFront:nil];
}

void MacWindow::scheduleRecreateNSWindow()
{
    QTimer::singleShot(0, [this](){
        recreateNSWindow();
    });
}

void MacWindow::setFullSizeContentView(bool enable)
{
    if (m_fullSizeContentView == enable)
        return;

    m_fullSizeContentView = enable;
    scheduleRecreateNSWindow();
}

bool MacWindow::fullSizeContentView() const
{
    return m_fullSizeContentView;
}

void MacWindow::setTitlebarAppearsTransparent(bool enable)
{
    if (m_titlebarAppearsTransparent == enable)
        return;

    m_titlebarAppearsTransparent = enable;
    scheduleRecreateNSWindow();
}

bool MacWindow::titlebarAppearsTransparent() const
{
    return m_titlebarAppearsTransparent;
}

void MacWindow::setMovableByWindowBackgropund(bool enable)
{
    if (m_movableByWindowBackground == enable)
        return;

    m_movableByWindowBackground = enable;
    scheduleRecreateNSWindow();
}

bool MacWindow::movableByWindowBackgropund() const
{
    return m_movableByWindowBackground;
}

void MacWindow::setToolbarEnabled(bool enable)
{
    if (m_toolbarEnabled == enable)
        return;

    m_toolbarEnabled = enable;
    scheduleRecreateNSWindow();
}

bool MacWindow::toolbarEnabled() const
{
    return m_toolbarEnabled;
}

void MacWindow::setShowsBaselineSeparator(bool enable)
{
    if (m_showsBaselineSeparator == enable)
        return;

    m_showsBaselineSeparator = enable;
    scheduleRecreateNSWindow();    
}

bool MacWindow::showsBaselineSeparator() const
{
    return m_showsBaselineSeparator;
}

void MacWindow::setTitleVisibility(bool enable)
{
    if (m_titleVisibility == enable)
        return;

    m_titleVisibility = enable;
    scheduleRecreateNSWindow();
}

bool MacWindow::titleVisibility() const
{
    return m_titleVisibility;
}

void MacWindow::setTitleText(const QString &text)
{
    if (m_titleText == text)
        return;

    m_titleText = text;
    scheduleRecreateNSWindow();
}

QString MacWindow::titleText() const
{
    return m_titleText;
}

void MacWindow::setAccessoryViewsEnabled(bool enable)
{
    if (m_accessoryView == enable)
        return;

    m_accessoryView = enable;
    scheduleRecreateNSWindow();
}

bool MacWindow::acceoryViews() const
{
    return m_accessoryView;
}

void MacWindow::setGeometry(QRect geometry)
{
    
}

QRect MacWindow::geometry() const
{
    return QRect();
}

void MacWindow::setVisible(bool visible)
{
    qDebug() << "setVisible" << visible;
    m_visible = visible;
    if (visible) {
        createNSWindow();
        [m_nsWindow makeKeyAndOrderFront:nil];
    } else {
        
    }
}

void MacWindow::show()
{
    setVisible(true);
}

