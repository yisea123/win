import QtQuick 2.8
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.1
import "MyButton"
import QtQuick.Controls.Material 2.1

Rectangle {
    id: item1
    width: 800
    height: 800

    Material.foreground: "black"
    Material.background: "white"
    Material.accent: "limegreen"
    Material.theme: Material.System

    property var getName: ["?GTR\r\n", "?MCS\r\n", "?T1S\n", "?PRF\r\n", "?PSN\r\n", "?IS1\r\n", "?IS2\r\n", "?IS3\r\n", "?ADC\r\n", "?SHT\r\n", "?STA\r\n"]
    property var stringType: ["GTR", "MCS", "T1S", "PRF", "PSN", "ID1", "ID2", "ID3"]
    property var getDispaly: [gtr_d, mcs_d, t1s_d, prf_d, psn_d, id1_d, id2_d, id3_d, switch1, switch2]
    property var control2: ["ADC=", "SHT=", "SLP="]
    property int curNumber: -1
    property int currentCom: 0
    property int isConnected: -1

    function getRange() {
        switch (comboBox1.currentText) {
        case "GTR":
            return [0, 1, 1,Number(getDispaly[0].text)]
        case "MCS":
            return [0, 1000, 10,Number(getDispaly[1].text)]
        case "T1S":
            return [4500, 6000, 100,Number(getDispaly[2].text)]
        case "PRF":
            return [0, 1000, 1,Number(getDispaly[3].text)]
        case "PSN":
            return [0, 12, 1,Number(getDispaly[4].text)]
        case "ID1":
            return [0, 10000, 10,Number(getDispaly[5].text)]
        case "ID2":
            return [0, 10000, 10,Number(getDispaly[6].text)]
        case "ID3":
            return [0, 10000, 10,Number(getDispaly[7].text)]
        }
    }

    function closeLaser(){
        myLaser.setValue("SHT=0\r\n")
        myLaser.writeData("ADC=0\r\n")
    }

    function refreshLaser() {
        timer1.stop()
        timer1.count=0
        isConnected=myLaser.isConnected()
        if (isConnected) {
            image4.source = "qrc:/Resource/icons/ok.svg"
            labelLaser.text = comboBox.model[currentCom]+qsTr(" Connected")
            labelLaser.color = "green"
            enableAll(true)
            timer1.start()
            return true
        } else {
            image4.source = "qrc:/Resource/icons/no.svg"
            labelLaser.text = qsTr("Disconnected")
            labelLaser.color = "red"
            enableAll(false)
            return false
        }
    }

    function closeSerialport(){
        myLaser.closePort()
        button.isEnable=true
        button2.isEnable=false
        isConnected=false
        currentCom=-1

        image4.source = "qrc:/Resource/icons/no.svg"
        labelLaser.text = qsTr("Disconnected")
        labelLaser.color = "red"

        enableAll(false)
    }

    function openSerialport(){
        currentCom = comboBox.currentIndex
        button.isEnable = false
        button2.isEnable=true
        if(myLaser.reConnectCom(comboBox.currentText))
            refreshLaser()
    }

    function enableAll(flag) {
        if (flag) {
            rectangle.enabled = true
            rectangle2.enabled = true
            button1.isEnable = true
            //rectangle3.enabled=true
        } else {
            rectangle.enabled = false
            rectangle2.enabled = false
            button1.isEnable = false
            //rectangle3.enabled=true
        }
    }
    function readLaser(count, item) {
        if (count < 8)
            getDispaly[count].text = myLaser.setValue(item).toString()
        else {
            getDispaly[count].checked = myLaser.setValue(item)
        }
    }

    function applyFunc() {
        return myLaser.setValue(
                    comboBox1.currentText + "=" + spinBox.value.toString(
                        ) + "\r\n")
    }

    Connections {
        id:connec
        target: myLaser
        property bool isShowMessage: true
        onShowValue: {
            if(isShowMessage){
                labelDisplay.text = qsTr("   receive data: ") + m_value
                labelDisplay.color = "green"
            }
        }

        onShowMessage: {
            if(isShowMessage){
                labelDisplay.color = "red"
                labelDisplay.text = str
            }
        }

        onReConnect:{
            openSerialport()
        }
        onSerialClosed:{
            closeSerialport()
        }

        onValueChanged:{
            if(type<8)
                getDispaly[type].text =m_data.toString()
            else{
                getDispaly[type].checked = m_data
            }

        }
    }

    Component.onCompleted: {
        refreshLaser()
        // timer3.start()
    }
    Timer{
        id: timer3
        interval: 2100
        running: false
        repeat: true
        onTriggered: {refreshLaser()}
    }

    Timer {
        id: timer1
        interval: 10
        running: false
        repeat: false
        property int count: 0
        onTriggered: {
            readLaser(count, getName[count])
            count++
            if (count < 10)
                start()
            else
                count = 0
        }
    }





    Rectangle {
        id: rectangle3
        height: 267
        color: "lightblue"
        anchors.right: rectangle.left
        anchors.rightMargin: 6
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: rectangle2.left
        anchors.leftMargin: 0

        Rectangle {
            id: rectangle1
            y: 8
            height: 50
            color: "#00000000"
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
            Rectangle {
                id: rectangle6
                width: 49
                color: "#00000000"
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0

                Image {
                    id: image4
                    width: 30
                    height: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    mipmap: true
                    fillMode: Image.PreserveAspectFit

                    visible: true
                    antialiasing: true
                }

                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                Layout.fillHeight: false
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }

            Label {
                id: labelLaser
                width: parent.width - rectangle6.width
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                font.family: "Calibri"
                font.pointSize: 14
                Layout.preferredWidth: rowLayout3.width / 6 * 5
                horizontalAlignment: Text.AlignLeft
                Layout.fillHeight: true
                verticalAlignment: Text.AlignVCenter
            }
        }


        MyButton {
            id: button
            y: 134
            height: 48
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
            buttonText: qsTr("Open")
            rightButtonEnable: false
            isEnable: true
            onMyButttonLeftclicked: {
                openSerialport()
            }
        }

        ComboBox {
            id: comboBox
            y: 64
            height: 48
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
            Layout.preferredWidth: 100
            Layout.fillWidth: false
            model: myLaser.getCom()
            onDisplayTextChanged: {
                button.isEnable = currentIndex == currentCom ? false : true
                button2.isEnable = currentIndex == currentCom ? true : false
            }
        }

        MyButton {
            id: button2
            x: 0
            y: 200
            height: 48
            anchors.right: parent.right
            buttonText: qsTr("Close")
            rightButtonEnable: false
            anchors.leftMargin: 5
            anchors.left: parent.left
            isEnable: false
            anchors.rightMargin: 5
            onMyButttonLeftclicked: {
                closeSerialport()
            }
        }
    }

    Rectangle {
        id: rectangle2

        width: 750

        color: "mistyrose"
        anchors.right: parent.right
        anchors.rightMargin: 25
        anchors.horizontalCenterOffset: 0
        anchors.top: parent.top
        anchors.topMargin: 281
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 126
        anchors.horizontalCenter: parent.horizontalCenter
        antialiasing: true
        border.width: 5
        border.color: "#55aaff"

        MyButton {
            id: button1
            x: 477
            y: 299
            width: 200
            height: 58
            buttonText: "apply"
            rightButtonEnable: false
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width / 4.5

            onMyButttonLeftclicked: {
                getDispaly[comboBox1.currentIndex].text = applyFunc().toString()

            }
        }

        ColumnLayout {
            id: columnLayout
            x: 8
            y: 15
            width: 349
            height: 364
            spacing: 0

            Rectangle {
                id: rectangle13
                width: 200
                height: 200
                color: "#ed9ba9"
                Layout.fillHeight: true
                Layout.fillWidth: true
                RowLayout {
                    id: rowLayout9
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    Layout.fillWidth: false

                    Label {
                        id: label8
                        color: "#205396"
                        text: qsTr("laser current status")
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        font.family: "Calibri"
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 15
                    }
                    anchors.fill: parent
                }
            }

            Rectangle {
                id: rectangle4
                width: 200
                height: 200
                color: "lightgrey"
                Layout.fillHeight: true
                Layout.fillWidth: true

                RowLayout {
                    id: rowLayout1
                    anchors.fill: parent
                    Layout.fillWidth: false

                    Label {
                        id: gtr
                        color: "Peru"
                        text: qsTr("GTR=")
                        Layout.fillWidth: false
                        Layout.fillHeight: true
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14

                        verticalAlignment: Text.AlignVCenter
                        font.family: "Calibri"

                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                    }

                    Label {
                        id: gtr_d
                        color: "forestgreen"
                        text: qsTr("0")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.fillHeight: true

                        verticalAlignment: Text.AlignVCenter
                        font.family: "Calibri"
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14

                        horizontalAlignment: Text.AlignLeft
                    }
                }
            }

            Rectangle {
                id: rectangle5
                width: 200
                height: 200
                color: "lightsteelblue"
                Layout.fillHeight: true
                Layout.fillWidth: true
                RowLayout {
                    id: rowLayout2
                    Layout.fillWidth: false
                    Label {
                        id: mcs
                        color: "#cd853f"
                        text: qsTr("MCS=")
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        Layout.fillWidth: false
                        font.family: "Calibri"
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14
                    }

                    Label {
                        id: mcs_d
                        color: "#228b22"
                        text: qsTr("0")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        font.family: "Calibri"
                        horizontalAlignment: Text.AlignLeft
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14
                    }
                    anchors.fill: parent
                }
            }

            Rectangle {
                id: rectangle7
                width: 200
                height: 200
                color: "lightgrey"
                Layout.fillHeight: true
                Layout.fillWidth: true
                RowLayout {
                    id: rowLayout3
                    Layout.fillWidth: false
                    Label {
                        id: t1s
                        color: "#cd853f"
                        text: qsTr("T1S=")
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        Layout.fillWidth: false
                        font.family: "Calibri"
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14
                    }

                    Label {
                        id: t1s_d
                        color: "#228b22"
                        text: qsTr("0")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        font.family: "Calibri"
                        horizontalAlignment: Text.AlignLeft
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14
                    }
                    anchors.fill: parent
                }
            }

            Rectangle {
                id: rectangle8
                width: 200
                height: 200
                color: "lightsteelblue"
                Layout.fillHeight: true
                Layout.fillWidth: true
                RowLayout {
                    id: rowLayout4
                    Layout.fillWidth: false
                    Label {
                        id: prf
                        color: "#cd853f"
                        text: qsTr("PRF=")
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        Layout.fillWidth: false
                        font.family: "Calibri"
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14
                    }

                    Label {
                        id: prf_d
                        color: "#228b22"
                        text: qsTr("0")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        font.family: "Calibri"
                        horizontalAlignment: Text.AlignLeft
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14
                    }
                    anchors.fill: parent
                }
            }

            Rectangle {
                id: rectangle9
                width: 200
                height: 200
                color: "lightgrey"
                Layout.fillHeight: true
                Layout.fillWidth: true
                RowLayout {
                    id: rowLayout5
                    Layout.fillWidth: false
                    Label {
                        id: psn
                        color: "#cd853f"
                        text: qsTr("PSN=")
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        Layout.fillWidth: false
                        font.family: "Calibri"
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14
                    }

                    Label {
                        id: psn_d
                        color: "#228b22"
                        text: qsTr("0")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        font.family: "Calibri"
                        horizontalAlignment: Text.AlignLeft
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14
                    }
                    anchors.fill: parent
                }
            }

            Rectangle {
                id: rectangle10
                width: 200
                height: 200
                color: "lightsteelblue"
                Layout.fillHeight: true
                Layout.fillWidth: true
                RowLayout {
                    id: rowLayout6
                    Layout.fillWidth: false
                    Label {
                        id: id1
                        color: "#cd853f"
                        text: qsTr("ID1=")
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        Layout.fillWidth: false
                        font.family: "Calibri"
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14
                    }

                    Label {
                        id: id1_d
                        color: "#228b22"
                        text: qsTr("0")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        font.family: "Calibri"
                        horizontalAlignment: Text.AlignLeft
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14
                    }
                    anchors.fill: parent
                }
            }

            Rectangle {
                id: rectangle11
                width: 200
                height: 200
                color: "lightgrey"
                Layout.fillHeight: true
                Layout.fillWidth: true
                RowLayout {
                    id: rowLayout7
                    Layout.fillWidth: false
                    Label {
                        id: id2
                        color: "#cd853f"
                        text: qsTr("ID2=")
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        Layout.fillWidth: false
                        font.family: "Calibri"
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14
                    }

                    Label {
                        id: id2_d
                        color: "#228b22"
                        text: qsTr("0")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        font.family: "Calibri"
                        horizontalAlignment: Text.AlignLeft
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14
                    }
                    anchors.fill: parent
                }
            }

            Rectangle {
                id: rectangle12
                width: 200
                height: 200
                color: "lightsteelblue"
                Layout.fillHeight: true
                Layout.fillWidth: true
                RowLayout {
                    id: rowLayout8
                    Layout.fillWidth: false
                    Label {
                        id: id3
                        color: "#cd853f"
                        text: qsTr("ID3=")
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        Layout.fillWidth: false
                        font.family: "Calibri"
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14
                    }

                    Label {
                        id: id3_d
                        color: "#228b22"
                        text: qsTr("0")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        font.family: "Calibri"
                        horizontalAlignment: Text.AlignLeft
                        Layout.preferredWidth: parent.width / 4.5
                        font.pointSize: 14
                    }
                    anchors.fill: parent
                }
            }
        }

        ComboBox {
            id: comboBox1
            x: 477
            y: 59
            width: 200
            height: 47
            font.pointSize: 14
            font.family: "Calibri"
            model: stringType
        }

        SpinBox {
            id: spinBox
            x: 477
            y: 173
            width: 200
            height: 47
            editable: true
            wheelEnabled: true
            font.pointSize: 14
            font.family: "Calibri"
            value: getRange()[3]
            from: getRange()[0]
            to: getRange()[1]
            stepSize: getRange()[2]
        }

        Label {
            id: label
            x: 423
            y: 21
            width: 111
            height: 26
            text: qsTr("Set laser:")
            font.pointSize: 14
            font.family: "calibri"
        }
    }

    Rectangle {
        id: rectangle
        height: 267
        color: "#00000000"
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 231
        anchors.right: rectangle2.right
        anchors.rightMargin: 0

        Timer {
            id: delayTimer
            interval: 1000
            running: false
            repeat: false
            property int time: 1200
            property bool ak1: true
            onTriggered: {
                if (time > 0) {
                    labelDisplay.text = qsTr(" Waiting current stabilization, remaining time: ") + time + "S"
                    if(ak1){
                        var gm=myLaser.setValue("?STA\r\n")
                        if(gm===104){
                            time--
                            start()
                            return
                        }
                        else if(gm===1){
                            ak1=false
                            time--
                            start()
                            return
                        }
                        else{
                            labelDisplay.text = qsTr(" open laser failed!! error:sta")
                            enableAll(true)
                            button2.isEnable=true
                            time = 1200
                            isConnected=1
                            connec.isShowMessage=true
                        }
                    }
                    else{
                        time--
                        start()
                        return
                    }
                }
                else {
                    var dk=myLaser.setValue("?ADC\r\n")
                    if(dk!==1){
                        labelDisplay.text = qsTr(" open laser failed!! error:adc")
                    }
                    enableAll(true)
                    time = 1200
                    button2.isEnable=true
                    isConnected=1
                    connec.isShowMessage=true
                }
            }
        }

        Switch {
            id: switch1
            y: 26
            width: 168
            height: 50
            enabled: switch2.checked ? false : true
            text: qsTr("Laser on-off")
            checked: false
            font.pointSize: 14
            font.family: "Calibri"
            anchors.left: labelDisplay.left
            anchors.leftMargin: 0
            anchors.verticalCenterOffset: -95
            anchors.verticalCenter: parent.verticalCenter
            Layout.fillWidth: false
            onClicked: {
                var k=myLaser.setValue("?ADC\r\n")
                if(k!==checked){
                    myLaser.writeData("ADC="+Number(checked).toString()+"\r\n")
                    if(checked&&k===0){
                        if (k===0&&checked){

                            enableAll(false)
                            isConnected=2
                            button2.isEnable=false
                            connec.isShowMessage=false
                            delayTimer.start()

                        }
                    }
                }
            }
        }

        Switch {
            id: switch2
            x: 189
            y: 52
            width: 199
            height: 50
            enabled: switch1.checked ? true : false
            text: qsTr("Shutter on-off")
            anchors.horizontalCenterOffset: 1
            font.pointSize: 14
            font.family: "Calibri"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenterOffset: -95
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                myLaser.setValue("SHT=" + Number(checked).toString() + "\r\n")
            }
        }

        Switch {
            id: switch3
            x: 368
            y: 55
            width: 176
            height: 50
            text: qsTr("Sleep on-off")
            font.pointSize: 14
            font.family: "Calibri"
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.verticalCenterOffset: -95
            anchors.verticalCenter: parent.verticalCenter
            hoverEnabled: false
            enabled: false
            onClicked:{


                //myLaser.setValue("SLP="+Number(checked).toString()+"\n")
            }
        }

        Label {
            id: labelDisplay
            y: 114
            height: 153
            color: "black"
            text: qsTr("")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            font.pointSize: 14
            font.family: "Calibri"
            background: Rectangle {
                color: "lightgrey"
            }
        }
    }
}
