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
import StatisticsLoader 1.0
import "../Storage.js" as DB


Page {
    id: statPage
    allowedOrientations: Orientation.All

    Column {
        anchors.fill: parent

        PageHeader {
            id: heading
            title: qsTr("Walk frequency by hour")
        }

        TextSwitch {
            id: zoomSwitch
            text: "Zoom"
            description: (checked == true) ? qsTr("Click to fit view") : qsTr("Click to zoom in")
            visible: statPage.isPortrait
            onCheckedChanged: {
                if (checked == true) {
                    flick.contentX = flick.width/2;
                }
            }
        }

        SilicaFlickable{
            id: flick
            width: statPage.width
            contentWidth: canvas.width
            height: innerColumn.height

            Column {
                id: innerColumn

                Canvas {
                    id: canvas
                    width: (statPage.isPortrait && zoomSwitch.checked) ? statPage.width*2 : statPage.width
                    height: statPage.height/2

                    function drawLine(ctx,x1,y1,x2,y2,lw) {
                        ctx.beginPath();
                        ctx.lineWidth = lw;
                        ctx.moveTo(x1, y1);
                        ctx.lineTo(x2, y2);
                        ctx.stroke();
                        ctx.closePath();
                    }

                    function clear(ctx) {
                        ctx.clearRect(0, 0, width, height);
                    }

                    onPaint: {
                        var ctx = getContext("2d");

                        ctx.save();
                        clear(ctx);

                        ctx.strokeStyle = Theme.secondaryColor
                        ctx.fillStyle = Theme.secondaryColor;

                        var xMargin = 15;
                        var xAxisPosition = canvas.height-40;
                        var yAxisHeight = canvas.height-50;
                        var xMarker = 10;
                        var lineWidth = 3;

                        canvas.drawLine(ctx, xMargin, xAxisPosition, canvas.width-xMargin, xAxisPosition, lineWidth);
                        canvas.drawLine(ctx, xMargin, xAxisPosition-yAxisHeight, xMargin, xAxisPosition, lineWidth);

                        var stepping = (canvas.width - 2*xMargin) / 24;

                        for (var i = 1; i <= 24; ++i) {
                            var xPosition = i*stepping;
                            var mark = xMarker;
                            if (i % 6 == 0) {
                                mark = mark*3;
                            }
                            canvas.drawLine(ctx, xMargin+xPosition, xAxisPosition, xMargin+xPosition, xAxisPosition-mark, lineWidth);

                            xPosition = (i-1)*stepping;
                            ctx.fillText(i, xMargin+xPosition, xAxisPosition+20);
                        }

                        ctx.strokeStyle = Theme.primaryColor
                        ctx.fillStyle = Theme.primaryColor;

                        var yMax = statLoader.getMaxValue();
                        var yScaling = yAxisHeight/yMax;
                        for (i = 0; i <= 23; ++i) {
                            var value = statLoader.getHourlySum(i);
                            xPosition = i*stepping;
                            ctx.fillRect(xMargin+xPosition, xAxisPosition-value*yScaling, stepping, value*yScaling);
                        }

                        ctx.restore();
                    }
                }

                Row {
                    anchors.leftMargin: 10
                    GridView {
                        id: titleView
                        width: 50;
                        height: 60
                        cellWidth: width;
                        cellHeight: height/2
                        model: titleModel
                        delegate: titleDelegate
                    }
                    GridView {
                        id: dataView
                        width: canvas.width -titleView.width;
                        height: titleView.height
                        cellWidth: width/24;
                        cellHeight: height/2
                        model: dataModel
                        delegate: dataDelegate
                    }
                }

            }
        }
    }

    Component {
        id: titleDelegate
        Rectangle {
            width: titleView.cellWidth
            height: titleView.cellHeight
            border.color: Theme.secondaryColor
            border.width: 2
            color: "transparent"
            Text {
                anchors.centerIn: parent
                text: txt
                font.pixelSize: Theme.fontSizeTiny
                color: Theme.secondaryColor
            }
        }
    }
    ListModel {
        id: titleModel
        function init() {
            append( {"txt": qsTr("Hour")} );
            append( {"txt": qsTr("Sum")} );
        }
        Component.onCompleted: init()
    }

    Component {
        id: dataDelegate
        Rectangle {
            width: dataView.cellWidth
            height: dataView.cellHeight
            border.color: Theme.secondaryColor
            border.width: 2
            color: "transparent"
            Text {
                anchors.centerIn: parent
                text: txt
                font.pixelSize: Theme.fontSizeTiny
                color: Theme.primaryColor
            }
        }
    }
    ListModel {
        id: dataModel
        function refresh() {
            for (var i = 0; i < 24; i++) {
                append( {"txt": i} );
            }
            for (i = 0; i < 24; i++) {
                append( {"txt": statLoader.getHourlySum((i))} );
            }
        }
    }

    StatisticsLoader {
        id: statLoader
    }

    function refreshStatData() {
        console.log("refresh statistics page");
        DB.readDB(statLoader, 31);
        canvas.requestPaint();
        dataModel.clear();
        dataModel.refresh();
    }

    Timer {
        id: statPageTimer
        interval: 60000
        triggeredOnStart: true
        repeat: true
        running: true
        onTriggered: refreshStatData()
    }

}
