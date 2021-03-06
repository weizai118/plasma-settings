// -*- coding: iso-8859-1 -*-
/*
 *   Copyright 2011 Sebastian Kügler <sebas@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.3 as Controls
import QtQuick.Controls 1.3 as QQC1

import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kcm 1.0

Item {
    id: timeModule
    objectName: "timeModule"

    QQC1.ScrollView {
        id: scrollView
        anchors.fill: parent

        GridLayout {
            id: formLayout

            property int gridspacing: Kirigami.Units.gridUnit

            //anchors.fill: parent
            //height: implicitHeight
            width: scrollView.width - Kirigami.Units.gridUnit
            //Rectangle { color: "orange"; opacity: 0.3; anchors.fill: parent}

            columns: 2
            //rows: 4
            //anchors.fill: parent
            //anchors.rightMargin: gridspacing

            //rowSpacing: gridspacing
            columnSpacing: gridspacing

            Item {
                Layout.preferredHeight: Kirigami.Units.gridUnit / 3
                Layout.columnSpan: 2
            }

            Kirigami.Heading {
                Layout.columnSpan: 2
                //             Layout.rowSpacing: Kirigami.Units.gridUnit * 4
                text: i18n("Time Display")
                level: 3
            }

            Controls.Label {
                text: i18n("Use 24-hour clock:")
                Layout.fillWidth: true
            }

            Controls.Switch {
                id: twentyFourSwitch
                checked: kcm.twentyFour
                Layout.alignment : Qt.AlignRight
                onClicked : {
                    kcm.twentyFour = checked
                    print(kcm.timeZone);
                }
            }

            Controls.Label {
                id: timeZoneLabel
                text: i18n("Timezone:")
                Layout.fillWidth: true
            }

            Controls.Button {
                id: timeZoneButton
                text: kcm.timeZone
                onClicked: timeZonePickerDialog.open()
            }

            Item {
                height: Kirigami.Units.gridUnit
            }

            Kirigami.Heading {
                Layout.columnSpan: 2
    //             Layout.rowSpacing: Kirigami.Units.gridUnit * 4
                text: i18n("Set Time and Date")
                level: 3
            }

            Controls.Label {
                id: ntpLabel
                text: i18n("Set time automatically:")
                Layout.fillWidth: true
            }

            Controls.Switch {
                id: ntpCheckBox
                Layout.alignment : Qt.AlignRight
                checked: kcm.useNtp
                onClicked: {
                    kcm.useNtp = checked;
                    if (!checked) {
                        kcm.ntpServer = ""
                        kcm.saveTime()
                    }
                }
            }
            Kirigami.Heading {
                Layout.columnSpan: 2
                //             Layout.rowSpacing: Kirigami.Units.gridUnit * 4
                text: i18n("Set Time")
                level: 4
            }

            TimePicker {
                id: timePicker
                enabled: !ntpCheckBox.checked
                twentyFour: twentyFourSwitch.checked

                Layout.columnSpan: 2
                Layout.preferredHeight: timePicker.childrenRect.height + timePicker.margin * 2
                //Layout.preferredWidth: timePicker.childrenRect.width + timePicker._margin * 2
    //             Layout.alignment: Qt.AlignHCenter
                Layout.alignment: Qt.AlignLeft

                Component.onCompleted: {
                    //var date = new Date("January 1, 1971 "+kcm.currentTime)
                    var date = new Date(kcm.currentTime);
    //                 print("CurrentTime: "  + kcm.currentTime);
    //                 print("Date: "  + date);
    //                 print("hours:   "  + date.getHours());
    //                 print("minutes: "  + date.getMinutes());
    //                 print("seconds: "  + date.getSeconds());
                    timePicker.hours = date.getHours();
                    timePicker.minutes = date.getMinutes();
                    timePicker.seconds = date.getSeconds();
                }
                Connections {
                    target: kcm
                    onCurrentTimeChanged: {
                        if (timePicker.userConfiguring) {
                            return;
                        }

                        //var date = new Date("January 1, 1971 "+kcm.currentTime)
                        var date = new Date(kcm.currentTime);
                        timePicker.hours = date.getHours();
                        timePicker.minutes = date.getMinutes();
                        timePicker.seconds = date.getSeconds();
                    }
                }
                onUserConfiguringChanged: {
                    kcm.currentTime = timeString
                    kcm.saveTime()
                }
            }

            Kirigami.Heading {
                Layout.columnSpan: 2
                //             Layout.rowSpacing: Kirigami.Units.gridUnit * 4
                text: i18n("Set Date")
                level: 4
            }

            DatePicker {
                id: datePicker
                enabled: !ntpCheckBox.checked
                Layout.columnSpan: 2
                //Layout.preferredHeight: datePicker.childrenRect.height + datePicker._margin * 2
                //Layout.preferredWidth: datePicker.childrenRect.width + datePicker._margin * 2
                Layout.alignment: Qt.AlignLeft

                Component.onCompleted: {
                    var date = new Date(kcm.currentDate)
                    datePicker.day = date.getDate()
                    datePicker.month = date.getMonth()+1
                    datePicker.year = date.getFullYear()
                }
                Connections {
                    target: kcm
                    onCurrentDateChanged: {
                        if (datePicker.userConfiguring) {
                            return
                        }

                        var date = new Date(kcm.currentDate)

                        datePicker.day = date.getDate()
                        datePicker.month = date.getMonth()+1
                        datePicker.year = date.getFullYear()
                    }
                }
                onUserConfiguringChanged: {
                    kcm.currentDate = isoDate
                    kcm.saveTime()
                }
            }
        }
    }

    PlasmaComponents.CommonDialog {
        id: timeZonePickerDialog
        titleText: i18n("Pick Timezone... (%1)", kcm.timeZone)
        buttonTexts: [i18n("Close")]
        onButtonClicked: close()
        content: Loader {
            id: timeZonePickerLoader
            width: Kirigami.Units.gridUnit * 22
            height: Kirigami.Units.gridUnit * 25
        }
        onStatusChanged: {
            if (status == PlasmaComponents.DialogStatus.Open) {
                timeZonePickerLoader.source = "TimeZonePicker.qml"
                timeZonePickerLoader.item.focusTextInput()
            }
        }
    }
}
