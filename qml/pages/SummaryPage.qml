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
import SummaryLoader 1.0
import "../Storage.js" as DB


Page {
    id: summaryPage
    allowedOrientations: Orientation.All

    Column {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        width: summaryPage.width

        PageHeader {
            title: qsTr("Statistics")
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeLarge
            text: qsTr("Seven day summary")
        }

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: Qt.resolvedUrl("../images/pic4.png")
            width: (summaryPage.isPortrait) ? summaryPage.width : summary.height/2
            height: 0.75 * width
        }

        BackgroundItem {
            Label {
                anchors.centerIn: parent
                text: qsTr("Activity count = ") + summaryLoader.activitySum
            }
            onPressAndHold: showActivityDetails()
            onReleased: hideActivityDetails()
        }
        Label {
            id: avgActLab
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Average per day =  ") + summaryLoader.activityAvg
            visible: false
            color: Theme.secondaryColor
        }
        Label {
            id: minActLab
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Minimum per day = ") + summaryLoader.activityMin
            visible: false
            color: Theme.secondaryColor
        }
        Label {
            id: maxActLab
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Maximum per day = ") + summaryLoader.activityMax
            visible: false
            color: Theme.secondaryColor
        }

        BackgroundItem {
            Label {
                anchors.centerIn: parent
                text: qsTr("Average duration = ") + summaryLoader.durationAvg
            }
            onPressAndHold: showDurationDetails()
            onReleased: hideDurationDetails()
        }
        Label {
            id: minDurLab
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Minimum = ") + summaryLoader.durationMin
            visible: false
            color: Theme.secondaryColor
        }
        Label {
            id: maxDurLab
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Maximum = ") + summaryLoader.durationMax
            visible: false
            color: Theme.secondaryColor
        }
    }

    SummaryLoader {
        id: summaryLoader
    }
    Timer {
        id: summaryPageTimer
        interval: 60000
        triggeredOnStart: true
        repeat: true
        running:true
        onTriggered: refreshSummaryData()
    }

    function showActivityDetails () {
        avgActLab.visible = true;
        minActLab.visible = true;
        maxActLab.visible = true;
    }
    function hideActivityDetails () {
        avgActLab.visible = false;
        minActLab.visible = false;
        maxActLab.visible = false;
    }
    function showDurationDetails () {
        minDurLab.visible = true;
        maxDurLab.visible = true;
    }
    function hideDurationDetails () {
        minDurLab.visible = false;
        maxDurLab.visible = false;
    }
    function refreshSummaryData () {
        console.log("refresh summary data");
        DB.readDB(summaryLoader, 7);
    }

}
