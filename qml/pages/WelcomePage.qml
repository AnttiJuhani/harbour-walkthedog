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
    id: welcomePage
    allowedOrientations: Orientation.All
    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push( Qt.resolvedUrl("SettingsPage.qml") )
            }
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push( Qt.resolvedUrl("AboutPage.qml") )
            }
        }

        Column {
            width: welcomePage.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Walk The Dog - application")
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: (welcomePage.isPortrait) ? welcomePage.width : welcomePage.height/2
                height: 0.75*width
                source: Qt.resolvedUrl("../images/pic1.png")
            }
            Label {
                id: label
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Welcome!")
                font.pixelSize: Theme.fontSizeExtraLarge
                color: Theme.highlightColor
                MouseArea {
                    anchors.fill: parent
                    onClicked: pageStack.push( Qt.resolvedUrl("MainPage.qml") )
                }
                SequentialAnimation {
                    id: sAnim
                    loops: Animation.Infinite
                    RotationAnimation { target: label; properties: "rotation"; from: 0; to: 180; duration: 2000; direction: RotationAnimation.Counterclockwise }
                    PauseAnimation { duration: 1000 }
                    RotationAnimation { target: label; properties: "rotation"; from: 180; to: 0; duration: 2000; direction: RotationAnimation.Clockwise }
                    PauseAnimation { duration: 1000 }
                }
            }
        }
    }
    onStatusChanged: {
        if (status === PageStatus.Activating) {
            sAnim.running= true;
        }
        else if (status === PageStatus.Deactivating) {
            sAnim.running= false;
        }
    }
}
