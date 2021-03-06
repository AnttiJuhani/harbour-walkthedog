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
    id: walkPage
    allowedOrientations: Orientation.All

    property bool active: appWin.applicationActive

    onActiveChanged: {
        //console.log("WalkPage: Active=" + active);
        if (active == true) {
            blinkAnim.running = true;
        }
        else {
            blinkAnim.running = false;
        }
    }
    Component.onDestruction: {
        //console.log("WalkPage: OnDestruction");
        walkTimer.stopWalk();
    }

    SequentialAnimation {
        id: blinkAnim
        running: true
        loops: Animation.Infinite
        PauseAnimation { duration: 3000 }
        PropertyAnimation { target: blinkLine; property: "opacity"; to: 0.1; duration: 1500 }
        PropertyAnimation { target: blinkLine; property: "opacity"; to: 1; duration: 1500 }
    }

    Column {
        id: imgColumn
        width: parent.width
        PageHeader {
            title: qsTr("Walk timer is on")
        }
        Column {
            width: (walkPage.isPortrait) ? parent.width : parent.width/2
            anchors.left: parent.left
            Rectangle {
                id: imgArea
                width: parent.width
                height: 0.75*width+2
                color: "transparent"
                border.color: "transparent"
                Image {
                    width: parent.width
                    height: 0.75*width
                    anchors.top: parent.top
                    source: Qt.resolvedUrl("../images/pic3.png")
                    onYChanged: {
                        if (y <= mouseArea.releaseArea) { infoLbl.visible = true; }
                        else { infoLbl.visible = false; }
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
                            blinkAnim.running = false;
                        }
                        onReleased: {
                            if (parent.y <= releaseArea) {
                                var finish = true;
                            }
                            infoLbl.visible = false;
                            blinkAnim.running = true;
                            parent.anchors.top = parent.parent.top
                            if (finish == true) {
                                walkTimer.finishWalk();
                                DB.writeDB(walkTimer.getWalkStart(), walkTimer.getWalkEnd(), walkTimer.getWalkLenght());
                                pageStack.pop();
                            }
                        }
                    }
                }
                Label {
                    id: infoLbl
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeSmall
                    visible: false
                    text: qsTr("<Release to end the walk>")
                }
                Rectangle {
                    id: blinkLine
                    width: parent.width
                    anchors.bottom: parent.bottom
                    color: Theme.secondaryColor
                    height: 2
                }
            }
        }
    }

    Column {
        width: (walkPage.isPortrait) ? parent.width : parent.width/2
        height: childrenRect.height
        spacing: Theme.paddingSmall
        anchors.right: parent.right
        anchors.topMargin: (walkPage.isPortrait) ? 100 : undefined
        anchors.top: (walkPage.isPortrait) ? imgColumn.bottom : undefined
        anchors.verticalCenter: (walkPage.isPortrait) ? undefined : parent.verticalCenter

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeLarge
            color: Theme.secondaryColor
            text: qsTr("Duration:")
        }
        Rectangle{
            width: 0.65*parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            height: 2
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeLarge
            color: Theme.secondaryColor
            text: walkTimer.duration
        }
    }
}
