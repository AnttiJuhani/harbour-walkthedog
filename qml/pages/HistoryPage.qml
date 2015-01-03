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
    id: actPage
    allowedOrientations: Orientation.All

    Timer {
        id: historyPageTimer
        interval: 5*60000
        triggeredOnStart: true
        repeat: true
        running: true
        onTriggered: refreshHistoryData()
    }

    function refreshHistoryData() {
        console.log("refresh history page");
        DB.readDB(historyLoader, 31);
        outerlistModel.refresh();
    }

    Image {
        width: parent.width/3
        height: 1.25*width
        anchors.left:  parent.left
        anchors.verticalCenter: parent.verticalCenter
        source: Qt.resolvedUrl("../images/pic6.png")
        visible: actPage.isLandscape
    }

    SilicaFlickable {
        id: flick
        width: (actPage.isPortrait) ? parent.width : 2*parent.width/3
        height: parent.height
        contentHeight: column.height
        anchors.right: parent.right

        VerticalScrollDecorator { flickable: flick }

        Column {
            id: column
            width: parent.width
            height: childrenRect.height
            PageHeader {
                title: qsTr("One month activity log")
            }
            ListView {
                id: listView
                width: parent.width
                height: childrenRect.height
                interactive: false
                model: outerlistModel
                delegate: outerlistDelegate
            }
        }
    }

    ListModel {
        id: outerlistModel
        function refresh() {
            clear();
            for (var dayIndex = 0; dayIndex < 31; ++dayIndex) {
                append( {"dayStr": historyLoader.getDayStr(dayIndex), "dateStr": historyLoader.getDateStr(dayIndex)} );
            }
        }
    }

    Component {
        id: outerlistDelegate
        Column {
            id:column2
            width: flick.width
            height: childrenRect.height
            Item {
                width: parent.width
                height: childrenRect.height
                Label {
                    anchors.leftMargin: parent.width/10
                    anchors.left: parent.left
                    text: dayStr
                    color: Theme.secondaryColor
                }
                Label {
                    anchors.rightMargin: parent.width/10
                    anchors.right: parent.right
                    text: dateStr
                    color: Theme.secondaryColor
                }
            }
            Rectangle {
                x: parent.width/10
                width: parent.width - 2*parent.width/10
                height: 2
                color: Theme.secondaryColor
            }

            ListView {
                width: parent.width
                height: contentItem.height
                interactive: false
                property int parentIndex: index

                model: ListModel { id: innerlistModel }
                delegate: Item {
                    id: innerlistDelegate
                    width: column2.width
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

                Component.onCompleted: {
                    var dayIndex = parentIndex;
                    var daySum = historyLoader.getWalkSum(dayIndex);
                    if (daySum === 0 ) {
                        innerlistModel.append( {"timeStr": qsTr("Nothing"), "durationStr": ""} );
                    }
                    else {
                        for (var walkIndex = 0; walkIndex < daySum; ++walkIndex) {
                            innerlistModel.append( {"timeStr": historyLoader.getWalkTime(dayIndex, walkIndex),
                                                    "durationStr": historyLoader.getWalkDuration(dayIndex, walkIndex)} );
                        }
                    }
                }
            }

            Item {
                width: parent.width
                height: 20
            }
        }
    }

}
