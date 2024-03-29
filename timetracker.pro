# App version
VERSION = 0.1.0

# Publish the app version to source code.
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

# Add more folders to ship with the application, here
folder_01.source = qml/timetracker
folder_01.target = qml
folder_02.source = qml/harmattan-timepicker
folder_02.target = qml
folder_03.source = qml/harmattan-datepicker
folder_03.target = qml
DEPLOYMENTFOLDERS += \
    folder_01 \
    folder_02 \
    folder_03

# Additional import path used to resolve QML modules in Creator's code model
#QML_IMPORT_PATH += /opt/meego/Simulator/Qt/gcc/imports/simulatorHarmattan/ \
#    /opt/meego/Simulator/Qt/gcc/harmattanthemes/blanco/meegotouch/

symbian:TARGET.UID3 = 0xEF87556A

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Add SQL libraries
QT += sql

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    src/databasemanager.cpp \
    src/exportmanager.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    TODO

HEADERS += \
    src/databasemanager.h \
    src/exportmanager.h
