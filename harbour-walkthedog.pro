# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-walkthedog

CONFIG += sailfishapp

SOURCES += src/harbour-walkthedog.cpp \
    src/WalkTimer.cpp \
    src/SummaryLoader.cpp \
    src/StatisticsLoader.cpp \
    src/HistoryLoader.cpp \
    src/BaseLoader.cpp \
    src/LanguageSelector.cpp \
    src/CoverTexts.cpp

OTHER_FILES += qml/harbour-walkthedog.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-walkthedog.changes.in \
    rpm/harbour-walkthedog.spec \
    rpm/harbour-walkthedog.yaml \
    translations/*.ts \
    harbour-walkthedog.desktop \
    qml/pages/WelcomePage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/WalkPage.qml \
    qml/pages/SummaryPage.qml \
    qml/pages/HistoryPage.qml \
    qml/pages/StatisticsPage.qml \
    qml/pages/SettingsPage.qml \
    qml/Storage.js \
    qml/images/pic1.png \
    qml/images/pic2.png \
    qml/images/pic3.png \
    qml/images/pic4.png \
    qml/images/pic5.png \
    qml/images/pic6.png \
    translations/harbour-walkthedog-fi.qm

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-walkthedog-en.ts \
                translations/harbour-walkthedog-fi.ts

RESOURCES +=

HEADERS += \
    src/BaseLoader.h \
    src/WalkTimer.h \
    src/SummaryLoader.h \
    src/StatisticsLoader.h \
    src/HistoryLoader.h \
    src/LanguageSelector.h \
    src/CoverTexts.h

