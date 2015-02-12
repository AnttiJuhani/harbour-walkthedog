/*
 * Copyright (C) 2015 Antti Aura
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *   * Neither the name of the author nor the
 *     names of its contributors may be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Storage.js" as DB


Page {
    id: mainPage
    allowedOrientations: Orientation.All

    Component.onDestruction: {
        inactivateTimer();
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            activateAll();
        }
        else if (status === PageStatus.Deactivating) {
            inactivate();
        }
    }

    Timer {
        id: mainPageTimer
        interval: 15000
        triggeredOnStart: true
        repeat: true
        onTriggered: refreshPageData()
    }
    SequentialAnimation {
        id: anim
        loops: Animation.Infinite
        PauseAnimation { duration: 3000 }
        PropertyAnimation { target: imgHint; property: "opacity"; to: 0.2; duration: 1500 }
        PropertyAnimation { target: imgHint; property: "opacity"; to: 1; duration: 1500 }
    }

    function refreshPageData() {
        //console.log("refresh main page");
        if (DB.sum(historyLoader.today()) !== todayModel.count) {
            DB.readDB(historyLoader, 1);
            todayModel.clear();
            for (var walkIndex = 0; walkIndex < historyLoader.getWalkSum(0); ++walkIndex) {
                todayModel.append( {"timeStr": historyLoader.getWalkTime(0, walkIndex),
                                    "durationStr": historyLoader.getWalkDuration(0, walkIndex)} );
            }
        }
    }

    function activateAll() {
        mainPageTimer.start();
        anim.running = true;
        walkTimer.startTimer();
    }

    function inactivate() {
        mainPageTimer.stop();
        anim.running = false;
    }

    function inactivateTimer() {
        walkTimer.stopTimer();
    }

    SilicaFlickable {
        width: parent.width
        height: parent.height
        contentHeight: height

        PullDownMenu {
            MenuItem {
                text: qsTr("Graphical")
                onClicked: {
                    inactivateTimer();
                    pageStack.push( Qt.resolvedUrl("StatisticsPage.qml") );
                }
            }
            MenuItem {
                text: qsTr("Summary")
                onClicked: {
                    inactivateTimer();
                    pageStack.push( Qt.resolvedUrl("SummaryPage.qml") );
                }
            }
            MenuItem {
                text: qsTr("Activity log")
                onClicked: {
                    inactivateTimer();
                    pageStack.push( Qt.resolvedUrl("HistoryPage.qml") );
                }
            }
        }

        Column {
            id: column1
            width: parent.width

            PageHeader {
                id: heading
                title: qsTr("Walk The Dog")
            }
            Flow {
                width: parent.width
                spacing: (mainPage.isPortrait) ? Theme.paddingLarge : 0

                Rectangle {
                    id: imgArea
                    width: (mainPage.isPortrait) ? parent.width : parent.width/2
                    height: 0.75*width+2
                    color: "transparent"
                    border.color: "transparent"

                    Image {
                        width: parent.width
                        height: 0.75*width
                        anchors.top: parent.top
                        source: Qt.resolvedUrl("../images/pic2.png")
                        onYChanged: {
                            if (y <= mouseArea.releaseArea) { infoLabel.visible = true; }
                            else { infoLabel.visible = false; }
                        }
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            drag.target: parent
                            drag.axis: "YAxis"
                            drag.minimumY: imgArea.y-60
                            drag.maximumY: imgArea.y
                            property int releaseArea: drag.minimumY+5
                            onPressed: {
                                parent.anchors.top = undefined;
                                anim.running = false;
                            }
                            onReleased: {
                                if (parent.y <= releaseArea) {
                                    var finish = true;
                                }
                                infoLabel.visible = false;
                                anim.running = true;
                                parent.anchors.top = parent.parent.top
                                if (finish == true) {
                                    walkTimer.startWalk();
                                    pageStack.push( Qt.resolvedUrl("WalkPage.qml") )
                                }
                            }
                        }
                    }
                    Label {
                        id: infoLabel
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Theme.fontSizeSmall
                        visible: false
                        text: qsTr("<Release to start a new walk>")
                    }
                    Rectangle {
                        id: imgHint
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 2
                        color: Theme.secondaryColor
                    }
                }

                SilicaFlickable {
                    width: (mainPage.isPortrait) ? parent.width : parent.width/2
                    height: (mainPage.isPortrait) ?  mainPage.height-heading.height-imgArea.height-Theme.paddingLarge : mainPage.height-heading.height
                    contentHeight: column2.height

                    Column {
                        id: column2
                        width: parent.width
                        spacing: Theme.paddingLarge

                        Column {
                            width: parent.width
                            Label {
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.pixelSize: Theme.fontSizeLarge
                                text: qsTr("Time since last walk:")
                            }
                            Label {
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.pixelSize: Theme.fontSizeLarge
                                text: walkTimer.duration
                            }
                        }
                        Column {
                            width: parent.width
                            spacing: Theme.paddingSmall
                            Label {
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.pixelSize: Theme.fontSizeLarge
                                text: qsTr("Activity today:");
                            }
                            Rectangle{
                                width: 0.85*parent.width
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: 2
                                color: Theme.secondaryColor
                            }
                            Label {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("Nothing");
                                font.pixelSize: Theme.fontSizeLarge
                                visible: (todayModel.count == 0)
                            }
                            ListView {
                                id: todayView
                                width: parent.width
                                height: contentItem.height
                                interactive: false
                                model: ListModel { id: todayModel }
                                delegate: Component {
                                    id: todayDelegate
                                    Item {
                                        width: todayView.width
                                        height: childrenRect.height
                                        Label {
                                            anchors.leftMargin: parent.width/5
                                            anchors.left: parent.left
                                            font.pixelSize: Theme.fontSizeMedium
                                            text: timeStr
                                            color: Theme.primaryColor
                                        }
                                        Label {
                                            anchors.rightMargin: parent.width/5
                                            anchors.right: parent.right
                                            font.pixelSize: Theme.fontSizeMedium
                                            text: durationStr
                                            color: Theme.primaryColor
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
