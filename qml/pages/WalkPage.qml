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
        width: parent.width
        height: parent.height
        contentHeight: outerColumn.height

        Column {
            id: outerColumn
            width: parent.width

            PageHeader {
                title: qsTr("Walk timer is on")
            }

            Flow {
                width:parent.width
                spacing: (walkPage.isPortrait) ? Theme.paddingLarge : 0

                Image {
                    width: (walkPage.isPortrait) ? parent.width : parent.width/2
                    height: 0.75*width
                    source: Qt.resolvedUrl("../images/pic3.png")
                }
                Column {
                    width: (walkPage.isPortrait) ? parent.width : parent.width/2
                    spacing: Theme.paddingLarge

                    Rectangle {
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
                            text: "Flick up to end the walk"

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
                                        walkTimer.finishWalk();
                                        DB.writeDB(walkTimer.getWalkStart(), walkTimer.getWalkEnd(), walkTimer.getWalkLenght())
                                        pageStack.pop();
                                    }
                                }
                            }
                        }
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Theme.fontSizeLarge
                        text: "Duration:"
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Theme.fontSizeLarge
                        text: walkTimer.walkDuration
                    }
                }
            }
        }
    }
}
