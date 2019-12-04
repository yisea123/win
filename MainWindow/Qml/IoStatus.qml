import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.1
import "MyButton/"

Rectangle {
    id: rectRoot

    property var privateIn: [rectin1, rectin2, rectin3, rectin4, rectin5, rectin6, rectin7, rectin8, rectin9, rectin10, rectin11, rectin12, rectin13, rectin14, rectin15, rectin16, rectin17, rectin18, rectin19]
    property var privateOut: [switchout1, switchout2, switchout3, switchout4, switchout5, switchout6, switchout7, switchout8, switchout9, switchout10, switchout11, switchout12, switchout13, switchout14, switchout15, switchout16, switchout17, switchout18, switchout19]

    signal outPutChanged(int index, bool value)

    Connections {
        target: myState
    }

    Component.onCompleted: {
        timer2.start()
        myState.beginMonitor()
    }

    HMessageBox {
        id: kmt
    }

    Switch {
        id: switchout20
        x: 311
        y: 49
        text: qsTr("Monitor enable")
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: rectInput.horizontalCenter
        Layout.preferredHeight: parent.height / 8 - 2
        font.family: "Microsoft YaHei UI"
        Layout.fillHeight: true
        checked:  myState.getIsWarning()
        Layout.preferredWidth: parent.width / 2 - 10
        font.pixelSize: 14
        Layout.fillWidth: true

        onCheckedChanged: {
            myState.setMonitor(checked);
        }
    }


    Timer {
        id: timer2
        interval: 100
        running: false
        repeat: true
        onTriggered: {
            privateIn.forEach(function (value, index, array) {

                value.color = myState.getInput(index + 1) === 1 ? "red" : "#00ff00"



            })

            privateOut.forEach(function (value, index, array) {
                value.checked = myState.getOutput(index + 1)
            })
        }
    }

    width: 800
    height: 900
    color: "#a9bfa9"
    border.color: "#00000000"
    border.width: 0
    antialiasing: true

    Material.foreground: "black"
    Material.accent: "darkgreen"
    Material.theme: Material.System
    Rectangle {
        id: rectOutput
        x: 22
        width: 774
        height: 249
        color: "mistyrose"
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: rectInput.bottom
        anchors.topMargin: 22
        anchors.rightMargin: 0
        border.color: "#55aaff"
        border.width: 5
        transformOrigin: Item.Center

        GridLayout {
            anchors.rightMargin: 12
            anchors.leftMargin: 12
            anchors.bottomMargin: 12
            anchors.topMargin: 12
            anchors.fill: parent
            scale: 1
            antialiasing: true
            columnSpacing: 1
            rowSpacing: 1
            flow: GridLayout.LeftToRight
            layoutDirection: Qt.LeftToRight
            rows: 0
            columns: 4

            Switch {
                id: switchout1
                text: qsTr("Red lamp")
                enabled: false
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
                padding: 8

                onCheckedChanged: {
                    myState.setOutput(1, checked)
                    outPutChanged(1, checked)
                }

                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                //enabled: false
                font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
            }

            Switch {
                id: switchout2

                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                text: qsTr("Green lamp")
                enabled: false
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
                //enabled: false
                font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
                onCheckedChanged: {
                    myState.setOutput(2, checked)
                    outPutChanged(2, checked)
                }
            }

            Switch {
                id: switchout3

                text: qsTr("Yellow lamp")
                enabled: false
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                //enabled: false
                font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
                onCheckedChanged: {
                    myState.setOutput(3, checked)
                    outPutChanged(3, checked)
                }
            }

            Switch {
                id: switchout4
                text: qsTr("Buzzer")
                enabled: false

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                //enabled: false
                font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
                onCheckedChanged: {
                    myState.setOutput(4, checked)
                    outPutChanged(4, checked)
                }
            }

            Switch {
                id: switchout5
                text: qsTr("Safegate locked")
                enabled: true

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                // enabled: false
                font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
                onCheckedChanged: {
                    myState.setOutput(5, checked)
                    outPutChanged(5, checked)
                }
            }

            Switch {
                id: switchout6
                text: qsTr("NULL")
                enabled: false

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
                onCheckedChanged: {
                    myState.setOutput(6, checked)
                    outPutChanged(6, checked)
                }
            }

            Switch {
                id: switchout7
                text: qsTr("Lightpath switch")
                enabled: true

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
                onCheckedChanged: {
                    myState.setOutput(7, checked)
                    outPutChanged(7, checked)
                }
            }

            Switch {
                id: switchout8
                text: qsTr("NULL")
                enabled: false

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
                onCheckedChanged: {
                    myState.setOutput(8, checked)
                    outPutChanged(8, checked)
                }
            }

            Switch {
                id: switchout9
                text: qsTr("NULL")
                enabled: false

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
                onCheckedChanged: {
                    myState.setOutput(9, checked)
                    outPutChanged(9, checked)
                }
            }

            Switch {
                id: switchout10
                text: qsTr("NULL")
                enabled: false

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
                onCheckedChanged: {
                    myState.setOutput(10, checked)
                    outPutChanged(10, checked)
                }
            }

            Switch {
                id: switchout11
                text: qsTr("Cleaner on-off")
                enabled: true

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
                onCheckedChanged: {
                    myState.setOutput(11, checked)
                    outPutChanged(11, checked)
                }
            }

            Switch {
                id: switchout12
                text: qsTr("Coaxial lighter")

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
                onCheckedChanged: {
                    myState.setOutput(12, checked)
                    outPutChanged(12, checked)
                }
            }

            Switch {
                id: switchout13
                text: qsTr("Switch system")

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                enabled: true
                //font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
                onCheckedChanged: {
                    myState.setOutput(13, checked)
                    outPutChanged(13, checked)
                }
            }

            Switch {
                id: switchout14
                text: qsTr("NULL")

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                enabled: false
                //font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
                onCheckedChanged: {
                    myState.setOutput(14, checked)
                    outPutChanged(14, checked)
                }
            }

            Switch {
                id: switchout15
                text: qsTr("NULL")

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.preferredHeight: parent.height / 8 - 2
                enabled: false
                //font.family: "Microsoft YaHei UI"
                font.pixelSize: 14
                onCheckedChanged: {
                    myState.setOutput(15, checked)
                    outPutChanged(15, checked)
                }
            }

            Switch {
                id: switchout16
                text: qsTr("NULL")
                Layout.preferredHeight: parent.height / 8 - 2
                // font.family: "Microsoft YaHei UI"
                enabled: false
                font.pixelSize: 14
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.fillWidth: true
                onCheckedChanged: {
                    myState.setOutput(16, checked)
                    outPutChanged(16, checked)
                }
            }

            Switch {
                id: switchout17
                text: qsTr("Fixtrue 1")
                Layout.preferredHeight: parent.height / 8 - 2
                font.family: "Microsoft YaHei UI"
                enabled: true
                font.pixelSize: 14
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.fillWidth: true
                onCheckedChanged: {
                    myState.setOutput(17, checked)
                    outPutChanged(17, checked)
                }
            }

            Switch {
                id: switchout18
                text: qsTr("Fixtrue 2")
                Layout.preferredHeight: parent.height / 8 - 2
                font.family: "Microsoft YaHei UI"
                enabled: true
                font.pixelSize: 14
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.fillWidth: true
                onCheckedChanged: {
                    myState.setOutput(18, checked)
                    outPutChanged(18, checked)
                }
            }

            Switch {
                id: switchout19
                text: qsTr("N2 on-off")
                Layout.preferredHeight: parent.height / 8 - 2
                font.family: "Microsoft YaHei UI"
                enabled: true
                font.pixelSize: 14
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2 - 10
                Layout.fillWidth: true
                onCheckedChanged: {
                    myState.setOutput(19, checked)
                    outPutChanged(19, checked)
                }
            }
        }
    }

    Rectangle {
        id: rectInput
        x: 22
        width: 774
        height: 234
        color: "lightsteelblue"
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 122

        anchors.leftMargin: 0
        border.color: "#55aaff"
        antialiasing: true
        border.width: 5

        GridLayout {
            id: gridLayout
            columnSpacing: 12
            anchors.rightMargin: 12
            anchors.leftMargin: 12
            anchors.topMargin: 8
            anchors.bottomMargin: 8
            anchors.fill: parent
            columns: 4


            Rectangle {
                id: rectangle6
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true
                Rectangle {
                    id: rectin2
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                Text {
                    id: text3
                    width: 119
                    text: qsTr("Front gate")
                    anchors.left: rectin2.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
                border.width: 0
            }


            Rectangle {
                id: rectangle16
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.fillWidth: true
                Rectangle {
                    id: rectin4
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                Text {
                    id: text5
                    width: 119
                    text: qsTr("Back gate")
                    anchors.left: rectin4.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
                border.width: 0
            }

            Rectangle {
                id: rectangle8
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.fillWidth: true
                Rectangle {
                    id: rectin3
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                Text {
                    id: text4
                    width: 119
                    text: qsTr("Left gate")
                    anchors.left: rectin3.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
                border.width: 0
            }




            Rectangle {
                id: rectangle24
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.fillWidth: true
                Rectangle {
                    id: rectin5
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                Text {
                    id: text6
                    width: 119
                    text: qsTr("Right gate")
                    anchors.left: rectin5.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
                border.width: 0
            }


            Rectangle {
                id: rectangle26
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.fillWidth: true
                Rectangle {
                    id: rectin6
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                Text {
                    id: text7
                    width: 119
                    text: qsTr("Safe gate")
                    anchors.left: rectin6.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
                border.width: 0
            }


            Rectangle {
                id: rectangle28
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.fillWidth: true
                Rectangle {
                    id: rectin7
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                Text {
                    id: text8
                    width: 119
                    text: qsTr("Lightpath closed")
                    anchors.left: rectin7.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
                border.width: 0
            }


            Rectangle {
                id: rectangle30
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.fillWidth: true
                Rectangle {
                    id: rectin8
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                Text {
                    id: text10
                    width: 119
                    text: qsTr("Finished box closed")
                    anchors.left: rectin8.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
                border.width: 0
            }


            Rectangle {
                id: rectangle34
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Rectangle {
                    id: rectin19
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    Layout.preferredHeight: 24
                    anchors.topMargin: 3
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    Layout.preferredWidth: 24
                    anchors.top: parent.top
                }

                Text {
                    id: text13
                    width: 119
                    text: qsTr("Tube exist")
                    lineHeight: 1
                    verticalAlignment: Text.AlignVCenter
                    anchors.topMargin: 0
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.bottomMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.left: rectin19.right
                    horizontalAlignment: Text.AlignLeft
                    anchors.top: parent.top
                    font.pixelSize: 14
                }
                border.width: 0
                Layout.fillWidth: true
            }

            Rectangle {
                id: rectangle4
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                border.width: 0
                Layout.fillWidth: true

                Rectangle {
                    id: rectin1
                    width: 26

                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    anchors.topMargin: 3
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 3
                    Layout.preferredWidth: 24
                    anchors.leftMargin: 3
                    Layout.preferredHeight: 24
                    anchors.left: parent.left
                }

                Text {
                    id: text2
                    width: 119
                    text: qsTr("Laser power")
                    anchors.left: rectin1.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    font.pixelSize: 14
                    lineHeight: 1
                    anchors.topMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.top: parent.top
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                }
            }

            Rectangle {
                id: rectangle45
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.fillWidth: true
                Rectangle {
                    id: rectin15
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                Text {
                    id: text34
                    width: 119
                    text: qsTr("Aspirateur power")
                    anchors.left: rectin15.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
                border.width: 0
            }

            Rectangle {
                id: rectangle33
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.fillWidth: true
                Rectangle {
                    id: rectin9
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                Text {
                    id: text18
                    width: 119
                    text: qsTr("water-cooling Temp")
                    anchors.left: rectin9.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
                border.width: 0
            }






            Rectangle {
                id: rectangle47
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.fillWidth: true
                Rectangle {
                    id: rectin16
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                Text {
                    id: text35
                    width: 119
                    text: qsTr("Water-cooling flow")
                    anchors.left: rectin16.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
                border.width: 0
            }

            Rectangle {
                id: rectangle43
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.fillWidth: true
                Rectangle {
                    id: rectin14
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                Text {
                    id: text33
                    width: 119
                    text: qsTr("E-Stop")
                    anchors.left: rectin14.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
                border.width: 0
            }












            Rectangle {
                id: rectangle39
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.fillWidth: true
                Rectangle {
                    id: rectin12
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                Text {
                    id: text31
                    width: 119
                    text: qsTr("Air pressure")
                    anchors.left: rectin12.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
                border.width: 0
            }







            Rectangle {
                id: rectangle41
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.fillWidth: true
                Rectangle {
                    id: rectin13
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                Text {
                    id: text32
                    width: 119
                    text: qsTr("N2 pressure")
                    anchors.left: rectin13.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
                border.width: 0
            }










            Rectangle {
                id: rectangle35
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.fillWidth: true
                Rectangle {
                    id: rectin10
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                Text {
                    id: text23
                    width: 119
                    text: qsTr("Lightpath state1")
                    anchors.left: rectin10.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
                border.width: 0
            }


            Rectangle {
                id: rectangle37
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Layout.fillWidth: true

                Rectangle {
                    id: rectin11
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    anchors.top: parent.top
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: 24
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.left: parent.left
                    anchors.topMargin: 3
                }

                border.width: 0
                Text {
                    id: text28
                    width: 118
                    text: qsTr("Lightpath state2")
                    anchors.left: rectin11.right
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.top: parent.top
                    lineHeight: 1
                    font.pixelSize: 14
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignVCenter
                    anchors.bottomMargin: 0
                    horizontalAlignment: Text.AlignLeft
                    anchors.topMargin: 0
                }
            }

            Rectangle {
                id: rectangle31
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Rectangle {
                    id: rectin17
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    Layout.preferredHeight: 24
                    anchors.topMargin: 3
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    Layout.preferredWidth: 24
                    anchors.top: parent.top
                }

                Text {
                    id: text11
                    width: 131
                    text: qsTr("Fixture 1 clamp")
                    lineHeight: 1
                    verticalAlignment: Text.AlignVCenter
                    anchors.topMargin: 0
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.bottomMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.left: rectin17.right
                    horizontalAlignment: Text.AlignLeft
                    anchors.top: parent.top
                    font.pixelSize: 14
                }
                border.width: 0
                Layout.fillWidth: true
            }



            Rectangle {
                id: rectangle32
                width: 102
                height: 32
                color: "#cddbd7"
                radius: 8
                Rectangle {
                    id: rectin18
                    width: 26
                    color: "#00ff00"
                    radius: 13
                    Layout.preferredHeight: 24
                    anchors.topMargin: 3
                    anchors.leftMargin: 3
                    anchors.bottomMargin: 3
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    Layout.preferredWidth: 24
                    anchors.top: parent.top
                }

                Text {
                    id: text12
                    width: 119
                    text: qsTr("Fixture 2 clamp")
                    lineHeight: 1
                    verticalAlignment: Text.AlignVCenter
                    anchors.topMargin: 0
                    anchors.leftMargin: 6
                    font.family: "Microsoft YaHei UI"
                    anchors.bottomMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.left: rectin18.right
                    horizontalAlignment: Text.AlignLeft
                    anchors.top: parent.top
                    font.pixelSize: 14
                }
                border.width: 0
                Layout.fillWidth: true
            }

        }
    }

}
