import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import "MyButton"
import myLightSwitch 1.0

ApplicationWindow {
    id: denugUi
    width: 800
    height: 600

    maximumHeight: 600
    maximumWidth: 800
    minimumHeight: 600
    minimumWidth: 800




    title: qsTr("Advance Settings")

    LightSwitch {
        id: lswitch
    }

    onClosing: {
        lswitch.setStep(step.displayText)
        lswitch.setSwitchPos(spos.text)

        lswitch.setWaitPosition([Number(checkBox.checked).toString(),spos3.text,spos4.text])

        lswitch.setMotionConf([spos5.text,spos6.text,spos7.text])
    }

    Rectangle {
        id: rectangle
        x: 399
        width: 363
        height: 484
        color: "#ffffff"
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20

        GroupBox {
            id: groupBox1
            font.pointSize: 12
            anchors.fill: parent
            //font.family: "calibri"
            title: qsTr("light switch pos setting")

            Rectangle {
                x: 205
                y: 243
                width: 125
                height: 34
                border.width: 2
                TextInput {
                    id: spos
                    text: lswitch.getSwitchPos()
                    anchors.topMargin: 5
                    cursorVisible: false
                    anchors.bottomMargin: 0
                    anchors.fill: parent
                    renderType: Text.QtRendering
                    //font.family: "calibri"
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 20
                    selectByMouse: true
                }
            }

            Label {
                id: label
                x: 20
                y: 248
                width: 159
                height: 24
                color: "#000000"
                text: qsTr("switch position(mm):")
                font.pointSize: 13
                //font.family: "calibri"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }

            Label {
                id: label1
                x: 27
                y: 8
                width: 159
                height: 24
                color: "#000000"
                text: qsTr("current position(mm):")
                font.pointSize: 13
                //font.family: "calibri"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                Timer {
                          interval: 100; running: true; repeat: true
                          onTriggered: curpos.text=lswitch.getCurPos(4)
                      }

                id: curpos
                x: 189
                y: 3
                width: 127
                height: 34
                color: "#000000"
                //text: lswitch.getCurPos(4)
                font.pointSize: 14
                //font.family: "calibri"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            MyButton {
                id: negimove
                x: 20
                y: 114
                width: 117
                height: 46
                rightButtonEnable: false
                myRadius: 0
                buttonText: qsTr("negative move")
                onMyButttonLeftclicked: {
                    lswitch.moveStep(-step.value / 100)
                }
            }

            MyButton {
                id: posimove
                x: 213
                y: 114
                width: 117
                height: 46
                rightButtonEnable: false
                myRadius: 0
                buttonText: qsTr("positive move")
                onMyButttonLeftclicked: {
                    lswitch.moveStep(step.value / 100)
                }
            }

            SpinBox {
                id: step
                x: 164
                y: 58
                width: 152
                height: 50
                wheelEnabled: true
                editable: true

                from: 0
                to: 5000
                value: lswitch.getStep()
                stepSize: 2

                property int decimals: 2
                property real realValue: value / 100

                validator: DoubleValidator {
                    bottom: step.from
                    top: step.to
                }

                textFromValue: function (value, locale) {
                    return Number(value / 100).toLocaleString(locale, 'f',step.decimals)
                }

                valueFromText: function (text, locale) {
                    return Number.fromLocaleString(locale, text) * 100
                }
            }

            Label {
                id: label3
                x: 66
                y: 71
                width: 81
                height: 24
                color: "#000000"
                text: qsTr("step(mm):")
                font.pointSize: 13
                //font.family: "calibri"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }

            MyButton {
                id: getpos
                x: 94
                y: 175
                width: 160
                height: 46
                rightButtonEnable: false
                myRadius: 0
                buttonText: qsTr("get current pos")
                onMyButttonLeftclicked: {
                    spos.text = curpos.text
                }
            }
        }
    }

    Rectangle {
        id: rectangle1
        width: 363
        height: 484
        color: "#ffffff"
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20

        GroupBox {
            id: groupBox
            anchors.fill: parent
            font.pointSize: 12
            //font.family: "calibri"
            title: qsTr("pos setting")

            Rectangle {
                id: rectangle4
                x: 10
                y: 30
                width: 319
                height: 55
                color: "#e0d7e3"
                border.width: 0
                Label {
                    id: label5
                    y: 7
                    width: 60
                    height: 24
                    color: "#000000"
                    text: qsTr(" Y(mm):")
                    horizontalAlignment: Text.AlignRight
                    //font.family: "calibri"
                    anchors.verticalCenterOffset: 0
                    font.pointSize: 13
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                }

                Rectangle {
                    y: 9
                    width: 111
                    height: 32
                    border.width: 2
                    TextInput {
                        id: spos3
                        text: lswitch.getWaitPosition()[1]
                        anchors.topMargin: 3
                        anchors.bottomMargin: 3
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 19
                       // font.family: "calibri"
                        renderType: Text.QtRendering
                        cursorVisible: false
                        anchors.fill: parent
                        selectByMouse: true
                    }
                    anchors.verticalCenterOffset: 0
                    anchors.left: label5.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                }

                MyButton {
                    id: getpos3
                    x: 245
                    y: 5
                    width: 97
                    height: 32
                    rightButtonEnable: false
                    myRadius: 0
                    anchors.right: parent.right
                    buttonText: qsTr("get current pos")
                    anchors.verticalCenterOffset: 0
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    onMyButttonLeftclicked: {
                        spos3.text = lswitch.getCurPos(2)
                    }
                }
                border.color: "#00000000"
            }

            Rectangle {
                id: rectangle5
                x: 10
                y: 91
                width: 319
                height: 55
                color: "#e0d7e3"
                border.width: 0
                Label {
                    id: label6
                    y: 7
                    width: 60
                    height: 24
                    color: "#000000"
                    text: qsTr(" Z(mm):")
                    horizontalAlignment: Text.AlignRight
                    //font.family: "calibri"
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 13
                    anchors.verticalCenterOffset: 0
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                }

                Rectangle {
                    y: 9
                    width: 111
                    height: 32
                    border.width: 2
                    TextInput {
                        id: spos4
                        text: lswitch.getWaitPosition()[2]
                        anchors.topMargin: 3
                        anchors.bottomMargin: 3
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 19
                        //font.family: "calibri"
                        renderType: Text.QtRendering
                        cursorVisible: false
                        anchors.fill: parent
                        selectByMouse: true
                    }
                    anchors.verticalCenterOffset: 0
                    anchors.left: label6.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                }

                MyButton {
                    id: getpos4
                    x: 245
                    y: 5
                    width: 97
                    height: 32
                    rightButtonEnable: false
                    myRadius: 0
                    buttonText: qsTr("get current pos")
                    anchors.right: parent.right
                    anchors.verticalCenterOffset: 0
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    onMyButttonLeftclicked: {
                        spos4.text = lswitch.getCurPos(3)
                    }
                }
                border.color: "#00000000"
            }

            Label {
                id: label2
                x: 10
                y: 0
                width: 122
                height: 24
                text: qsTr("wait position:")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }

            CheckBox {
                id: checkBox
                x: 131
                y: 160
                width: 198
                height: 40
                checked: Number(lswitch.getWaitPosition()[0])
                text: qsTr("auto return to wait")
            }

            Label {
                id: label4
                x: 10
                y: 213
                width: 181
                height: 24
                text: qsTr("motion configuration:")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }

            Rectangle {
                id: rectangle6
                x: 10
                y: 243
                width: 319
                height: 55
                color: "#e0d7e3"
                border.color: "#00000000"
                border.width: 0
                Label {
                    id: label7
                    y: 7
                    width: 102
                    height: 24
                    color: "#000000"
                    text: qsTr("acc(mm*mm/s):")
                    font.pointSize: 13
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 36
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenterOffset: 0
                }

                Rectangle {
                    y: 9
                    width: 111
                    height: 32
                    border.width: 2
                    anchors.left: label7.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 30
                    TextInput {
                        id: spos5
                        text: lswitch.getMotionConf()[0]
                        anchors.topMargin: 3
                        renderType: Text.QtRendering
                        font.pixelSize: 19
                        selectByMouse: true
                        anchors.fill: parent
                        cursorVisible: false
                        anchors.bottomMargin: 3
                        horizontalAlignment: Text.AlignHCenter
                    }
                    anchors.verticalCenterOffset: 0
                }
            }

            Rectangle {
                id: rectangle7
                x: 10
                y: 304
                width: 319
                height: 55
                color: "#e0d7e3"
                border.color: "#00000000"
                border.width: 0
                Label {
                    id: label8
                    y: 7
                    width: 102
                    height: 24
                    color: "#000000"
                    text: qsTr("dec(mm*mm/s):")
                    font.pointSize: 13
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 36
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    anchors.verticalCenterOffset: 0
                }

                Rectangle {
                    y: 9
                    width: 111
                    height: 32
                    border.width: 2
                    anchors.left: label8.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 30
                    TextInput {
                        id: spos6
                        text: lswitch.getMotionConf()[1]
                        anchors.topMargin: 3
                        renderType: Text.QtRendering
                        font.pixelSize: 19
                        selectByMouse: true
                        anchors.fill: parent
                        cursorVisible: false
                        anchors.bottomMargin: 3
                        horizontalAlignment: Text.AlignHCenter
                    }
                    anchors.verticalCenterOffset: 0
                }
            }

            Rectangle {
                id: rectangle8
                x: 10
                y: 365
                width: 319
                height: 55
                color: "#e0d7e3"
                border.color: "#00000000"
                border.width: 0
                Label {
                    id: label9
                    y: 7
                    width: 102
                    height: 24
                    color: "#000000"
                    text: qsTr("vel(mm*mm/s):")
                    font.pointSize: 13
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 36
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenterOffset: 0
                }

                Rectangle {
                    x: 185
                    y: 9
                    width: 111
                    height: 32
                    border.width: 2
                    anchors.left: label9.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 30
                    TextInput {
                        id: spos7
                        text: lswitch.getMotionConf()[2]
                        anchors.topMargin: 3
                        renderType: Text.QtRendering
                        font.pixelSize: 19
                        selectByMouse: true
                        anchors.fill: parent
                        cursorVisible: false
                        anchors.bottomMargin: 3
                        horizontalAlignment: Text.AlignHCenter
                    }
                    anchors.verticalCenterOffset: 2
                }
            }
        }
    }

    MyButton {
        id: cancel
        x: 307
        y: 522
        width: 186
        height: 45
        rightButtonEnable: false
        buttonText: qsTr("OK")
        onMyButttonLeftclicked: {
            close()
        }
    }
}

