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

    onStatusChanged: {
        if (status === PageStatus.Activating) { mainPageTimer.start(); }
        else if (status === PageStatus.Deactivating) { mainPageTimer.stop(); }
    }

    Timer {
        id: mainPageTimer
        interval: 15000
        triggeredOnStart: true
        repeat: true
        onTriggered: refreshPageData()
        Component.onCompleted: start()
    }

    function refreshPageData() {
        console.log("refresh main page");
        if (DB.sum(historyLoader.today()) !== todayModel.count) {
            DB.readDB(historyLoader, 1);
            todayModel.clear();
            for (var walkIndex = 0; walkIndex < historyLoader.getWalkSum(0)-1; ++walkIndex) {
                todayModel.append( {"timeStr": historyLoader.getWalkTime(0, walkIndex),
                                    "durationStr": historyLoader.getWalkDuration(0, walkIndex)} );
            }
        }
    }

    SilicaFlickable {
        width: parent.width
        height: parent.height

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
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Walk The Dog")
            }

            Flow {
                width: parent.width
                spacing: (mainPage.isPortrait) ? Theme.paddingLarge : 0

                Image {
                    width: (mainPage.isPortrait) ? parent.width : parent.width/2
                    height: 0.75*width
                    source: Qt.resolvedUrl("../images/pic2.png")
                }
                SilicaFlickable {
                    width: (mainPage.isPortrait) ? parent.width : parent.width/2
                    height: mainPage.height
                    contentHeight: innerColumn.height

                    Column {
                        id: innerColumn
                        width: parent.width
                        spacing: Theme.paddingLarge

                        Rectangle{
                            id: rect
                            anchors.horizontalCenter: parent.horizontalCenter
                            border.width: 2
                            border.color: Theme.secondaryColor
                            color: "transparent"
                            height: 150
                            width: 1.2*label.width

                            Label {
                                id: label
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                font.pixelSize: Theme.fontSizeLarge
                                text: qsTr("Flick up to start a new walk")

                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    drag.target: parent
                                    drag.axis: "YAxis"
                                    drag.minimumY: rect.y
                                    drag.maximumY: rect.y + rect.height - parent.height
                                    onPressed: { parent.anchors.bottom = undefined; }
                                    onReleased: {
                                        if (parent.y <= drag.minimumY+10) {
                                            var finish = true;
                                        }
                                        parent.anchors.bottom = parent.parent.bottom
                                        if (finish == true) {
                                            walkTimer.startWalk();
                                            pageStack.push( Qt.resolvedUrl("WalkPage.qml") )
                                        }
                                    }
                                }
                            }
                        }
                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: Theme.fontSizeLarge
                            text: qsTr("Time since last walk:")
                        }
                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: Theme.fontSizeLarge
                            text: walkTimer.waitingDuration
                        }
                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: Theme.fontSizeLarge
                            text: qsTr("Activity today:");
                        }
                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("None");
                            visible: (mainPage.isPortrait && todayModel.count == 0)
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
                        }
                    }
                }
            }
        }
    }
}
