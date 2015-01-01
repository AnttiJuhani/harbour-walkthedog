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
    id: walkPage
    allowedOrientations: Orientation.All

    SilicaFlickable {
        height: column.height
        anchors.fill: parent

        Column {
            id: column
            anchors.horizontalCenter: parent.horizontalCenter
            width: walkPage.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Walk timer is on")
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: Qt.resolvedUrl("../images/pic3.png")
                width: (walkPage.width) ? walkPage.width : walkPage.height/2
                height: 0.75*width
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Duration:"
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: walkTimer.walkDuration
            }
            Rectangle{
                id: rect
                border.width: 2
                border.color: Theme.secondaryColor
                color: "transparent"
                height: 120
                x: (walkPage.width-width)/2
                width: 1.2*label.width
            }
        }
    }

    Label {
        id: label
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Flick to end the walk"
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
                    walkTimer.finishWalk();
                    DB.writeDB(walkTimer.getWalkStart(), walkTimer.getWalkEnd(), walkTimer.getWalkLenght())
                    pageStack.pop();
                }
            }
        }
    }
}
