import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import mydeviceinit 1.0
import "MyButton/"

ApplicationWindow {

    visible: true
    width: 650
    height: 500
    maximumHeight: 500
    maximumWidth: 650
    minimumHeight: 500
    minimumWidth: 650

    flags: Qt.WindowTitleHint | Qt.Window

    property var isInit: [0, 0, 0, 0]

    function startInitCamera() {
        busyIndicatorCamera.visible = true
        labelCamera.color = "blue"
        labelCamera.text = qsTr("Initing camera...")
        decieInit.initCamera()
    }

    function startInitA3200() {
        busyIndicatorA3200.visible = true
        labelA3200.color = "blue"
        labelA3200.text = qsTr("Initing A3200 motion table...")
        decieInit.initA3200()
    }

    function startInitGts() {

        busyIndicatorGTS.visible = true
        labelGTS.color = "blue"
        labelGTS.text = qsTr("Initing GTS motion table...")
        decieInit.initGTS()
    }

    function startInitLaser() {
        busyIndicatorLaser.visible = true
        labelLaser.color = "blue"
        labelLaser.text = qsTr("Initing Laser controller...")

    }

    title: qsTr("Check Hardware")

    DeviceInit {
        id: decieInit
        onCameraInitCompleted: {
            if (code) {
                labelCamera.color = "green"
                labelCamera.text = qsTr("Camera ready!")
                image1.source = "qrc:/Resource/icons/ok.svg"
                isInit[0] = 1
            } else {
                labelCamera.color = "red"
                labelCamera.text = qsTr("Camera initialize failed!")
                image1.source = "qrc:/Resource/icons/no.svg"
                isInit[0] = -1
            }

            busyIndicatorCamera.visible = false
            image1.visible = true

            if (isInit[0] !== 0 && isInit[1] !== 0 && isInit[2] !== 0
                    /*&& isInit[3] !== 0*/) {
                if (isInit[0] === 1 && isInit[1] === 1 && isInit[2] === 1
                        /*&& isInit[3] === 1*/) {
                    label.color = "green"
                    label.text = qsTr(
                                "All hardware initialization was successful!")
                    time.start()
                } else {
                    label.color = "red"
                    label.text = qsTr(
                                "hardware initialization was failed! Please check!")
                    rectangleButton.visible = true
                }
            }
        }
        onA3200InitCompleted: {
            if (code) {
                labelA3200.color = "green"
                labelA3200.text = qsTr("A3200 motion table ready!")
                image2.source = "qrc:/Resource/icons/ok.svg"
                isInit[1] = 1
            } else {
                labelA3200.color = "red"
                labelA3200.text = qsTr("A3200 motion table initialize failed!")
                image2.source = "qrc:/Resource/icons/no.svg"
                isInit[1] = -1
            }
            busyIndicatorA3200.visible = false
            image2.visible = true

            if (isInit[0] !== 0 && isInit[1] !== 0 && isInit[2] !== 0
                    /*&& isInit[3] !== 0*/) {
                if (isInit[0] === 1 && isInit[1] === 1 && isInit[2] === 1
                        /*&& isInit[3] === 1*/) {
                    label.color = "green"
                    label.text = qsTr(
                                "All hardware initialization was successful!")
                    time.start()
                } else {
                    label.color = "red"
                    label.text = qsTr(
                                "hardware initialization was failed! Please check!")
                    rectangleButton.visible = true
                }
            }
        }
        onGtsInitCompleted: {
            if (code) {
                labelGTS.color = "green"
                labelGTS.text = qsTr("GTS motion table ready!")
                image3.source = "qrc:/Resource/icons/ok.svg"
                isInit[2] = 1
            } else {
                labelGTS.color = "red"
                labelGTS.text = qsTr("GTS motion table initialize failed!")
                image3.source = "qrc:/Resource/icons/no.svg"
                isInit[2] = -1
            }
            busyIndicatorGTS.visible = false
            image3.visible = true


            decieInit.initLaser()///////////////FOR IO


            if (isInit[0] !== 0 && isInit[1] !== 0 && isInit[2] !== 0
                    /*&& isInit[3] !== 0*/) {
                if (isInit[0] === 1 && isInit[1] === 1 && isInit[2] === 1
                        /*&& isInit[3] === 1*/) {
                    label.color = "green"
                    label.text = qsTr(
                                "All hardware initialization was successful!")
                    time.start()
                } else {
                    label.color = "red"
                    label.text = qsTr(
                                "hardware initialization was failed! Please check!")
                    rectangleButton.visible = true
                }
            }
        }

        onLaserStartWait: {
            labelLaser.text = qsTr(
                        "Laser dio is initializing,remaining time: ") + second
        }

//        onLaserInitCompleted: {
//            if (code) {
//                labelLaser.color = "green"
//                labelLaser.text = qsTr("Laser controller ready!")
//                image4.source = "qrc:/Resource/icons/ok.svg"
//                isInit[3] = 1
//            } else {
//                labelLaser.color = "red"
//                labelLaser.text = qsTr(
//                            "Laser controller initialize failed! ") + error
//                image4.source = "qrc:/Resource/icons/no.svg"
//                isInit[3] = -1
//            }
//            busyIndicatorLaser.visible = false
//            image4.visible = true

//            if (isInit[0] !== 0 && isInit[1] !== 0 && isInit[2] !== 0
//                    && isInit[3] !== 0) {
//                if (isInit[0] === 1 && isInit[1] === 1 && isInit[2] === 1
//                        && isInit[3] === 1) {
//                    label.color = "green"
//                    label.text = qsTr(
//                                "All hardware initialization was successful!")
//                    time.start()
//                } else {
//                    label.color = "red"
//                    label.text = qsTr(
//                                "hardware initialization was failed! Please check!")
//                    rectangleButton.visible = true
//                }
//            }
//        }
    }

    onClosing: {
        if (isInit[0] !== 0 && isInit[1] !== 0 && isInit[2] !== 0/*&& isInit[3] !== 0*/) {
            if (go.isConti) {
                close.accepted = true
                decieInit.initDone()
                return
            }
            if (isInit[0] === -1 || isInit[1] === -1 || isInit[2] === -1/*|| isInit[3] === -1*/)
                decieInit.exitApp()
        } else
            close.accepted = false
    }



    function reInit() {
        busyIndicatorCamera.visible = false
        image1.visible = false
        labelCamera.text = ""

        busyIndicatorA3200.visible = false
        image2.visible = false
        labelA3200.text = ""

        busyIndicatorGTS.visible = false
        image3.visible = false
        labelGTS.text = ""

//        busyIndicatorLaser.visible = false
//        image4.visible = false
//        labelLaser.text = ""

        label.color = "black"
        label.text = qsTr("Checking hardware...")
        rectangleButton.visible = false

        isInit = [0, 0, 0, 0]

        startInitCamera()
        startInitA3200()
        startInitGts()
        //startInitLaser()
    }

    Timer {
        id: time
        running: false

        interval: 1000
        repeat: false
        onTriggered: {
            decieInit.initDone()
            close()
        }
    }

    Component.onCompleted: {
        label.text = qsTr("Checking hardware...")
        startInitCamera()
        startInitA3200()
        startInitGts()
        //startInitLaser()
    }

    Rectangle {
        id: rectangle
        color: "lavender"
        anchors.fill: parent

        Rectangle {
            id: rectangle3
            height: 255
            color: "lightgrey"
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.top: parent.top
            anchors.topMargin: 8
            border.width: 2
            border.color: "skyblue"

            RowLayout {
                id: rowLayout
                width: 300
                height: 50
                anchors.left: parent.left
                anchors.leftMargin: 50
                anchors.top: parent.top
                anchors.topMargin: 5

                Rectangle {
                    id: rectangle2
                    width: 40
                    height: 30
                    color: rectangle3.color
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 40
                    BusyIndicator {
                        id: busyIndicatorCamera
                        width: 40
                        height: 40
                        antialiasing: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        Layout.preferredWidth: rowLayout1.width / 6
                        visible: false
                        Layout.fillHeight: true
                    }

                    Image {
                        id: image1
                        width: 30
                        height: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        antialiasing: true
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        visible: false
                    }
                    Layout.fillHeight: false
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                Label {
                    id: labelCamera
                    Layout.preferredWidth: rowLayout.width / 6 * 5
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    Layout.fillHeight: true

                    font.pointSize: 12
                   // font.family: "Calibri"
                }
            }

            RowLayout {
                id: rowLayout1
                width: 300
                height: 50
                anchors.top: rowLayout.bottom
                anchors.topMargin: 5
                anchors.left: rowLayout.left
                anchors.leftMargin: 0

                Rectangle {
                    id: rectangle1
                    width: 50
                    height: 50
                    color: rectangle3.color
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 40
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillHeight: false

                    BusyIndicator {
                        id: busyIndicatorA3200
                        width: 40
                        height: 40
                        antialiasing: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        visible: false
                        Layout.fillHeight: true
                        Layout.preferredWidth: rowLayout1.width / 6
                    }

                    Image {
                        id: image2
                        width: 30
                        height: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        antialiasing: true
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        visible: false
                    }
                }

                Label {
                    id: labelA3200
                    horizontalAlignment: Text.AlignLeft
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignVCenter
                    Layout.preferredWidth: rowLayout1.width / 6 * 5

                    font.pointSize: 12
                    //font.family: "Calibri"
                }
            }

            RowLayout {
                id: rowLayout2
                width: 300
                height: 50
                Rectangle {
                    id: rectangle5
                    width: 50
                    height: 50
                    color: rectangle3.color

                    Image {
                        id: image3
                        width: 30
                        height: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        mipmap: true
                        fillMode: Image.PreserveAspectFit
                        visible: false
                        antialiasing: true
                    }
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    Layout.fillHeight: false
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    BusyIndicator {
                        id: busyIndicatorGTS
                        width: 40
                        height: 40
                        z: 0
                        antialiasing: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        Layout.preferredWidth: rowLayout2.width / 6
                        visible: false
                        Layout.fillHeight: true
                    }
                }

                Label {
                    id: labelGTS

                    //font.family: "Calibri"
                    font.pointSize: 12
                    Layout.preferredWidth: rowLayout2.width / 6 * 5
                    horizontalAlignment: Text.AlignLeft
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignVCenter
                }
                anchors.left: rowLayout1.left
                anchors.topMargin: 5
                anchors.top: rowLayout1.bottom
                anchors.leftMargin: 0
            }

            RowLayout {
                id: rowLayout3
                width: 300
                height: 50
                Rectangle {
                    id: rectangle6
                    width: 50
                    height: 50
                    color: rectangle3.color
                    BusyIndicator {
                        id: busyIndicatorLaser
                        width: 40
                        height: 40
                        antialiasing: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        Layout.preferredWidth: rowLayout3.width / 6
                        Layout.fillHeight: true
                        visible: false
                    }

                    Image {
                        id: image4
                        width: 30
                        height: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        mipmap: true
                        fillMode: Image.PreserveAspectFit
                        visible: false
                        antialiasing: true
                    }

                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    Layout.fillHeight: false
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                Label {
                    id: labelLaser

                    //font.family: "Calibri"
                    font.pointSize: 12
                    Layout.preferredWidth: rowLayout3.width / 6 * 5
                    horizontalAlignment: Text.AlignLeft
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignVCenter
                }
                anchors.left: rowLayout2.left
                anchors.topMargin: 5
                anchors.top: rowLayout2.bottom
                anchors.leftMargin: 0
            }
        }

        Rectangle {
            id: rectangle4
            height: 119
            color: "powderblue"
            anchors.top: parent.top
            anchors.topMargin: 275
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 8
            border.width: 2
            border.color: "skyblue"

            Label {
                id: label

                horizontalAlignment: Text.AlignHCenter
                anchors.leftMargin: 0
                font.pointSize: 14
                //font.family: "Calibri"
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
            }
        }

        Rectangle {
            id: rectangleButton
            height: 83
            color: "lightcoral"
            anchors.top: parent.top
            anchors.topMargin: 409
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.right: parent.right
            anchors.rightMargin: 8
            visible: false

            MyButton {
                id: go
                width: 115
                height: 43
                anchors.right: reTry.left
                anchors.rightMargin: 80
                anchors.verticalCenter: parent.verticalCenter
                buttonText: qsTr("ignore")
                visible: true
                rightButtonEnable: false
                property bool isConti: false
                x: 22
                y: 9
                onMyButttonLeftclicked: {
                    isConti = true
                    close()
                }
            }

            MyButton {
                id: reTry
                x: 185
                y: 9
                width: 115
                height: 43
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                buttonText: qsTr("retry")
                visible: true
                rightButtonEnable: false
                onMyButttonLeftclicked: {
                    reInit()
                }
            }

            MyButton {
                id: cancle
                y: 9
                width: 115
                height: 43
                anchors.left: reTry.right
                anchors.leftMargin: 80
                anchors.verticalCenter: parent.verticalCenter
                buttonText: qsTr("cancel")
                visible: true
                rightButtonEnable: false

                onMyButttonLeftclicked: {
                    decieInit.exitApp()
                    close()
                }
            }
        }
    }
}
