import QtQuick 2.6
import QtQml 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Button {

    id: buttonCompant
    width: 50
    height: 30
    antialiasing: true

    enabled: isEnable

    property string imgRes: ""
    property bool isMirror: false
    property bool isEnable: true
    property int myRadius: 10
    property string buttonText: ""
    property int buttonBorderWidth: 1
    property bool rightButtonEnable: true
    property color myButtonColor1: "#eee"
    property color myButtonColor2: "#ccc"

    Keys.onReturnPressed: {


        // event.accepted = true;
    }

    Keys.onSpacePressed: {


        // event.accepted = true;
    }

    onFocusChanged: {

    }

    Component.onCompleted: {

    }

    Text {
        text: buttonText
        font.bold: false
        scale: mouseA.pressed ? 0.9 : 1.0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        width: imgRes === "" ? parent.height * 0.3 : parent.height * 0.18
        height: imgRes === "" ? parent.height * 0.3 : parent.height * 0.18
        anchors.verticalCenterOffset: imgRes === "" ? 0 : parent.height * 0.31
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        antialiasing: true
        font.pointSize: height * 0.8 < 10 ? 10 : height * 0.8
        //font.family: "Calibri"
    }

    Image {
        id: img
        scale: mouseA.pressed ? 0.9 : 1.0
        width: parent.height * 0.6
        height: parent.height * 0.6
        anchors.verticalCenterOffset: buttonText === "" ? 0 : -parent.height * 0.14
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        antialiasing: true
        horizontalAlignment: Image.AlignHCenter
        fillMode: Image.PreserveAspectCrop
        mipmap: true
        asynchronous: true
        source: imgRes
        mirror: isMirror
        visible: imgRes === "" ? false : true
    }

    signal myButttonLeftclicked
    signal myButttonRightpressed
    signal myButttonRightreleased

    MouseArea {
        id: mouseA
        antialiasing: true
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        propagateComposedEvents: true
        onClicked: {
            if (!rightButtonEnable)
                if (mouse.button == Qt.RightButton)
                    mouse.accepted = false
            if (mouse.button == Qt.LeftButton)
                myButttonLeftclicked()
        }
        onPressed: {
            if (!rightButtonEnable)
                if (mouse.button == Qt.RightButton)
                    mouse.accepted = false
            if (mouse.button == Qt.RightButton)
                myButttonRightpressed()
        }
        onReleased: {
            if (mouse.button == Qt.RightButton)
                myButttonRightreleased()
        }
    }

    style: ButtonStyle {

        background: Rectangle {
            anchors.fill: parent
            border.width: mouseA.pressed ? 2 : buttonBorderWidth
            border.color: "#888"
            radius: myRadius

            function getColor1() {
                if (mouseA.containsMouse) {
                    if (mouseA.pressed) {
                        if (mouseA.pressedButtons === Qt.LeftButton) {
                            return "lightgreen"
                        } else {
                            return myButtonColor1
                        }
                    } else {
                        return "lightskyblue"
                    }
                } else {
                    return "#eee"
                }
            }

            function getColor2() {
                if (mouseA.containsMouse) {
                    if (mouseA.pressed) {
                        if (mouseA.pressedButtons === Qt.LeftButton)
                            return "springgreen"
                        else
                            return "lightcoral"
                    } else {
                        return "deepskyblue"
                    }
                } else {
                    return myButtonColor2
                }
            }

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: isEnable ? getColor1() : "DimGray"
                }
                GradientStop {
                    position: myButtonColor1 === myButtonColor2 ? 0 : 0.5
                    color: isEnable ? getColor2() : "DimGray"
                }
            }
        }
    }
}
