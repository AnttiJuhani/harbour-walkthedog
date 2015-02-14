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
    id: summaryPage
    allowedOrientations: Orientation.All

    property bool active: appWin.applicationActive

    onActiveChanged: {
        //console.log("SummaryPage: Active=" + active);
        if (active == true) {
            checkAnimation();
            summaryPageTimer.start();
        }
        else {
            anim.running = false;
            summaryPageTimer.stop();
        }
    }

    Timer {
        id: summaryPageTimer
        interval: 5*60000
        triggeredOnStart: true
        repeat: true
        running:true
        onTriggered: refreshSummaryData()
    }
    SequentialAnimation {
        id: anim
        running: true
        loops: Animation.Infinite
        PauseAnimation { duration: 3000 }
        PropertyAnimation { targets: [actLab, durLab]; property: "opacity"; to: 0.2; duration: 1500 }
        PropertyAnimation { targets: [actLab, durLab]; property: "opacity"; to: 1; duration: 1500 }
    }

    function refreshSummaryData () {
        //console.log("refresh summary data");
        DB.readDB(summaryLoader, 7);
    }
    function showActivityDetails () {
        avgActLab.visible = true;
        minActLab.visible = true;
        maxActLab.visible = true;
        checkAnimation();
    }
    function hideActivityDetails () {
        avgActLab.visible = false;
        minActLab.visible = false;
        maxActLab.visible = false;
        checkAnimation();
    }
    function showDurationDetails () {
        minDurLab.visible = true;
        maxDurLab.visible = true;
        checkAnimation();
    }
    function hideDurationDetails () {
        minDurLab.visible = false;
        maxDurLab.visible = false;
        checkAnimation();
    }
    function checkAnimation() {
        if (actItem.showDetails == true || durItem.showDetails == true) {
            anim.running = false;
            actLab.opacity = 1;
            durLab.opacity = 1;
        }
        else {
            anim.running = true;
        }
    }

    Column {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width

        PageHeader {
            title: qsTr("Statistics")
        }

        Flow {
            width: parent.width

            Image {
                width: (summaryPage.isPortrait) ? parent.width : parent.width/2
                height: 0.75 * width
                source: Qt.resolvedUrl("../images/pic4.png")
            }

            Column {
                width: (summaryPage.isPortrait) ? parent.width : parent.width/2

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeLarge
                    text: qsTr("Seven day summary")
                    color: Theme.primaryColor
                }
                BackgroundItem {
                    id: actItem
                    Label {
                        id: actLab
                        anchors.centerIn: parent
                        font.pixelSize: Theme.fontSizeMedium
                        text: qsTr("Activity count = ") + summaryLoader.activitySum
                        color: Theme.primaryColor
                    }
                    property bool showDetails: false
                    onPressed: {
                        showDetails = !showDetails;
                        if (showDetails == true) {
                            showActivityDetails();
                        }
                        else {
                            hideActivityDetails();
                        }
                    }
                }
                Label {
                    id: avgActLab
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeMedium
                    text: qsTr("Average per day =  ") + summaryLoader.activityAvg
                    visible: false
                    color: Theme.secondaryColor
                }
                Label {
                    id: minActLab
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeMedium
                    text: qsTr("Minimum per day = ") + summaryLoader.activityMin
                    visible: false
                    color: Theme.secondaryColor
                }
                Label {
                    id: maxActLab
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeMedium
                    text: qsTr("Maximum per day = ") + summaryLoader.activityMax
                    visible: false
                    color: Theme.secondaryColor
                }
                BackgroundItem {
                    id: durItem
                    Label {
                        id: durLab
                        anchors.centerIn: parent
                        font.pixelSize: Theme.fontSizeMedium
                        text: qsTr("Average duration = ") + summaryLoader.durationAvg
                        color: Theme.primaryColor
                    }
                    property bool showDetails: false
                    onPressed: {
                        showDetails = !showDetails;
                        if (showDetails == true) {
                            showDurationDetails();
                        }
                        else {
                            hideDurationDetails();
                        }
                    }
                }
                Label {
                    id: minDurLab
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeMedium
                    text: qsTr("Minimum = ") + summaryLoader.durationMin
                    visible: false
                    color: Theme.secondaryColor
                }
                Label {
                    id: maxDurLab
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeMedium
                    text: qsTr("Maximum = ") + summaryLoader.durationMax
                    visible: false
                    color: Theme.secondaryColor
                }
            }
        }
    }
}
