/*
 * Copyright (C) 2014 Antti Aura
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

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Graphical")
                onClicked: pageStack.push( Qt.resolvedUrl("StatisticsPage.qml") )
            }
            MenuItem {
                text: qsTr("Summary")
                onClicked: pageStack.push( Qt.resolvedUrl("SummaryPage.qml") )
            }
            MenuItem {
                text: qsTr("Activity log")
                onClicked: pageStack.push( Qt.resolvedUrl("HistoryPage.qml") )
            }
        }

        Column {
            id: column
            anchors.horizontalCenter: parent.horizontalCenter
            width: mainPage.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Walk The Dog - application")
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: Qt.resolvedUrl("../images/pic2.png")
                width: (mainPage.isPortrait) ? mainPage.width : mainPage.height/2
                height: 0.75*width
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Time since last walk:"
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: walkTimer.waitingDuration
            }
            Rectangle{
                id: rect
                border.width: 2
                border.color: Theme.secondaryColor
                color: "transparent"
                height: 120
                x: (mainPage.width-width)/2
                width: 1.2*label.width
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Activity today:");
            }
            ListView {
                id: listView
                width: mainPage.width
                height: contentItem.height
                interactive: false
                model: ListModel { id: listModel }
                delegate: listDelegate
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("None");
                visible: (mainPage.isPortrait && listModel.count == 0)
            }
        }

        Label {
            id: label
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Flick to start a new walk"
            y: rect.y + rect.height - height
            MouseArea {
                anchors.fill: parent
                drag.target: parent
                drag.axis: "YAxis"
                drag.minimumY: rect.y
                drag.maximumY: rect.y+rect.height-height
                onReleased: {
                    if (label.y <= drag.minimumY+10) {
                        var c = true;
                    }
                    label.y = drag.maximumY;
                    if (c == true) {
                        walkTimer.startWalk();
                        pageStack.push( Qt.resolvedUrl("WalkPage.qml") )
                    }
                }
            }
        }
    }

    Component {
        id: listDelegate
        Item {
            width: mainPage.width
            height: childrenRect.height
            Label {
                anchors.leftMargin: parent.width/5
                anchors.left: parent.left
                text: timeStr
                color: Theme.primaryColor
            }
            Label {
                anchors.rightMargin: parent.width/5
                anchors.right: parent.right
                text: durationStr
                color: Theme.primaryColor
            }
        }
    }

    function refreshPageData() {
        console.log("refresh main page");
        if (DB.sum(historyLoader.today()) !== listModel.count) {
            DB.readDB(historyLoader, 1);
            listModel.clear();
            for (var walkIndex = 0; walkIndex < historyLoader.getWalkSum(0)-1; ++walkIndex) {
                listModel.append( {"timeStr": historyLoader.getWalkTime(0, walkIndex),
                                   "durationStr": historyLoader.getWalkDuration(0, walkIndex)} );
            }
        }
    }

    Timer {
        id: mainPageTimer
        interval: 15000
        triggeredOnStart: true
        repeat: true
        onTriggered: refreshPageData()
        Component.onCompleted: start()
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            mainPageTimer.start();
        }
        else if (status === PageStatus.Deactivating) {
            mainPageTimer.stop();
        }
    }
}
