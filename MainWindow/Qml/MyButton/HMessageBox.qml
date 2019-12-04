import QtQuick 2.0

Rectangle {
    id: messageBoxBackground
    property string title: ""
    property string prompt: ""
    property int fontSize: 0.03 * parent.height
    signal itemClicked(int index)
    function doModal() {
        messageBoxBackground.state = "visible"
        Qt.inputMethod.hide()
    }
    signal myMessageBoxOK
    signal myMessageBoxCancel
    visible: false
    anchors.fill: parent
    color: "#80000000"
    //点击对话框区域外，隐藏对话框，其父窗口最后变为最外层窗口，在Component.onCompleted事件中设置
    MouseArea {
        anchors.fill: parent
        onClicked: {


            //menuRoot.state = "";//非模态时可以这样用
        }
    }

    //对话框
    Rectangle {
        id: messageBox
        color: "white"
        width: 0.3 * parent.width
        height: 0.3 * parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Column {
            anchors.fill: parent
            Rectangle {
                width: parent.width
                height: 0.25 * parent.height
                color: "deepskyblue"
                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: fontSize
                    //font.family: "Calibri"
                    text: title
                }
            }

            Text {
                id: textText
                width: parent.width
                height: 0.5 * parent.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
               //font.family: "Calibri"
                font.pixelSize: fontSize
                wrapMode: Text.WordWrap
                text: prompt
                color: "black"
            }

            Rectangle {
                width: parent.width
                height: 0.25 * parent.height

                //color: "#3399db"
                MyButton {
                    id: buttonOk
                    anchors.left: parent.left
                    anchors.leftMargin: 1
                    anchors.top: parent.top
                    anchors.topMargin: 1
                    //imgRes: "qrc:/Resource/icons/left2.svg"
                    width: parent.width / 2
                    height: parent.height - 2
                    isEnable: true
                    myRadius: 0
                    buttonText: qsTr("OK")
                    rightButtonEnable: false
                    onMyButttonLeftclicked: {
                        myMessageBoxOK()
                        messageBoxBackground.state = ""
                    }
                }

                MyButton {
                    id: buttonCancel
                    anchors.right: parent.right
                    anchors.rightMargin: 1
                    anchors.top: parent.top
                    anchors.topMargin: 1
                    //imgRes: "qrc:/Resource/icons/left2.svg"
                    width: parent.width / 2
                    height: parent.height - 2
                    isEnable: true
                    myRadius: 0
                    buttonText: qsTr("Cancel")
                    rightButtonEnable: false
                    onMyButttonLeftclicked: {
                        myMessageBoxCancel()
                        messageBoxBackground.state = ""
                    }
                }

                //                MouseArea {
                //                    anchors.fill: parent//
                //                    onClicked:
                //                    {
                //                        //console.log("onClicked 2")

                //                        messageBoxBackground.state = "";
                //                    }
                //                }
            }
        }
    }

    states: State {
        name: "visible"
        PropertyChanges {
            target: messageBoxBackground
            visible: true
        }

        PropertyChanges {
            target: textText
            //            verticalAlignment: Text.AlignVCenter
            //            horizontalAlignment: Text.AlignHCenter
        }
    }
    transitions: Transition {
        NumberAnimation {
            target: messageBoxBackground
            properties: "visible"
            duration: 250
        }
    }
    Component.onCompleted: {
        var docRoot = messageBoxBackground.parent
        while (docRoot.parent) {
            docRoot = docRoot.parent
        }
        messageBoxBackground.parent = docRoot
    }
}
