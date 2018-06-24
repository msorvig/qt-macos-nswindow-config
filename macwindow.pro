TEMPLATE = app
OBJECTS_DIR = .obj
MOC_DIR = .moc

QT += widgets

include($$PWD/macwindow.pri)

HEADERS +=\
    checkeredwindow.h

SOURCES += \
    checkeredwindow.cpp \
    main.cpp

