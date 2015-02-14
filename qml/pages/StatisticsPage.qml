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
    id: statPage
    allowedOrientations: Orientation.All

    property bool active: appWin.applicationActive

    onActiveChanged: {
        //console.log("StatisticsPage: Active=" + active);
        if (active == true) {
            statPageTimer.start();
        }
        else {
            statPageTimer.stop();
        }
    }

    Timer {
        id: statPageTimer
        interval: 5*60000
        triggeredOnStart: true
        repeat: true
        running: true
        onTriggered: refreshStatData()
    }

    function refreshStatData() {
        //console.log("refresh statistics page");
        DB.readDB(statLoader, 31);
        canvas.requestPaint();
        dataModel.refresh();
    }

    PageHeader {
        id: heading
        title: qsTr("Walk frequency by hour")
    }

    TextSwitch {
        id: zoomSwitch
        anchors.top: heading.bottom
        text: qsTr("Zoom")
        description: (checked == true) ? qsTr("Click to fit view") : qsTr("Click to zoom in")
        visible: statPage.isPortrait
        onCheckedChanged: {
            if (checked == true) { flick.contentX = flick.width/2; }
        }
    }

    SilicaFlickable{
        id: flick
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        width: parent.width
        contentWidth: canvas.width
        height: column.height

        Column {
            id: column

            Canvas {
                id: canvas
                width: (statPage.isPortrait && zoomSwitch.checked) ? statPage.width*2 : statPage.width
                height: (statPage.isPortrait) ? statPage.height/2 : 0.65*statPage.height

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
                    var xAxisLenght = canvas.width-2*xMargin;
                    var yAxisHeight = canvas.height-50;
                    var lineWidth = 3;
                    canvas.drawLine(ctx, xMargin, xAxisPosition, canvas.width-xMargin, xAxisPosition, lineWidth);
                    canvas.drawLine(ctx, xMargin, xAxisPosition-yAxisHeight, xMargin, xAxisPosition, lineWidth);
                    canvas.drawLine(ctx, xMargin+xAxisLenght, xAxisPosition-yAxisHeight, xMargin+xAxisLenght, xAxisPosition, lineWidth);

                    if (statPage.isPortrait) {
                        if (zoomSwitch.checked === true) {
                            ctx.font="22px sans-serif";
                            var textHeight=25;
                        }
                        else {
                            ctx.font="13px sans-serif";
                            textHeight=20;
                        }
                    }
                    else {
                        ctx.font="25px sans-serif";
                        textHeight=25;
                    }

                    var yMaxValue = statLoader.getMaxValue();
                    yMaxValue = (yMaxValue > 0) ? yMaxValue : 1;
                    var yAxisDataHeight = 0.90*yAxisHeight;
                    var yMarker = 10;
                    canvas.drawLine(ctx, xMargin, xAxisPosition-yAxisDataHeight, xMargin+yMarker, xAxisPosition-yAxisDataHeight, lineWidth);
                    ctx.fillText(yMaxValue, xMargin+yMarker, xAxisPosition-yAxisDataHeight-10);
                    canvas.drawLine(ctx, xMargin+xAxisLenght-yMarker, xAxisPosition-yAxisDataHeight, xMargin+xAxisLenght, xAxisPosition-yAxisDataHeight, lineWidth);

                    var xMarker = 10;
                    var xStepping = (canvas.width-2*xMargin)/24;
                    for (var i = 0; i < 24; ++i) {
                        var xPosition = i*xStepping;
                        var mark = xMarker;
                        if (i%6 == 0) {
                            mark = mark*3;
                        }
                        canvas.drawLine(ctx, xMargin+xPosition, xAxisPosition, xMargin+xPosition, xAxisPosition-mark, lineWidth);

                        var textWidth=ctx.measureText(i).width;;
                        var fineXPosition=(xStepping-textWidth)/2;
                        ctx.fillText(i, xMargin+xPosition+fineXPosition, xAxisPosition+textHeight);
                    }

                    var yScaling = yAxisDataHeight/yMaxValue;
                    for (i = 0; i <= 23; ++i) {
                        var dataValue = statLoader.getHourlySum(i);
                        var yScaled = dataValue*yScaling
                        xPosition = i*xStepping;

                        var x0 = xMargin+xPosition;
                        var y0 = xAxisPosition-yScaled;
                        var dx = xStepping;
                        var dy = yScaled;

                        var myGradient = ctx.createLinearGradient(x0, y0+yScaled, x0, y0);
                        myGradient.addColorStop(0, Theme.secondaryColor);
                        myGradient.addColorStop(1, Theme.primaryColor);
                        ctx.fillStyle=myGradient;
                        ctx.fillRect(x0, y0, dx, dy);
                    }

                    ctx.restore();
                }
            }

            Row {
                anchors.leftMargin: 10
                GridView {
                    id: headingsView
                    width: 50
                    height: 60
                    cellWidth: width;
                    cellHeight: height/2
                    enabled: false
                    model: ListModel {
                        function init() {
                            append( { heading: qsTr("Hour") } );
                            append( { heading: qsTr("Sum") } );
                        }
                        Component.onCompleted: { init(); }
                    }
                    delegate: headingsDelegate
                }
                GridView {
                    id: dataView
                    width: canvas.width -headingsView.width;
                    height: headingsView.height
                    cellWidth: width/24;
                    cellHeight: height/2
                    model: dataModel
                    delegate: dataDelegate
                }
            }
        }
    }

    Component {
        id: headingsDelegate
        Rectangle {
            width: headingsView.cellWidth
            height: headingsView.cellHeight
            border.color: Theme.secondaryColor
            border.width: 2
            color: "transparent"
            Text {
                anchors.centerIn: parent
                text: heading
                font.pixelSize: Theme.fontSizeTiny
                color: Theme.secondaryColor
            }
        }
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
            clear();
            for (var i = 0; i < 24; ++i) {
                append( {"txt": i} );
            }
            for (i = 0; i < 24; ++i) {
                append( {"txt": statLoader.getHourlySum((i))} );
            }
        }
    }

}
