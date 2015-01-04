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
    id: settingsPage
    allowedOrientations: Orientation.All

    SilicaFlickable {
        width: parent.width
        height: parent.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Use test database")
                onClicked: {
                    DB.dropDB();
                    DB.initializeDB();
                    DB.fillTestData();
                    walkTimer.initialize( DB.getLastWalkTime() );
                }
            }
            MenuItem {
                text: qsTr("Reset database")
                onClicked: {
                    DB.dropDB();
                    DB.initializeDB();
                    walkTimer.initialize( DB.getLastWalkTime() );
                }
            }
        }

        Column {
            width: parent.width
            PageHeader {
                title: qsTr("Settings")
            }
            Label {
                id: lbl
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: Theme.fontSizeExtraLarge
                color: Theme.primaryColor
                text: qsTr("Language:")
            }
            ComboBox {
                id: cb
                anchors.horizontalCenter: parent.horizontalCenter
                width: 200
                currentIndex: language.language
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("System")
                        color: Theme.secondaryColor
                        onClicked: changeLanguage(0)
                    }
                    MenuItem {
                        text: qsTr("English")
                        color: Theme.secondaryColor
                        onClicked: changeLanguage(1)
                    }
                    MenuItem {
                        text: qsTr("Finnish")
                        color: Theme.secondaryColor
                        onClicked: changeLanguage(2)
                    }
                }
            }
        }
    }

    function changeLanguage(l) {
        l = parseInt(l);
        language.changeLanguage(l)
        pageStack.replaceAbove(null, Qt.resolvedUrl("WelcomePage.qml"))
    }
}
