import QtQuick 2.8
import QtQuick.Controls 2.1
import Qt.labs.platform 1.0
import QtQuick.Controls.Material 2.1
import mytexteditor 1.0

// TODO:
// - make designer-friendly

Rectangle {
    id: window
    width: 800
    height: 600
    visible: true
    //title: document.fileName + " - Text Editor Example"
    border.width: 1
    border.color: "black"





    Component.onCompleted: {
        //        x = Screen.width / 2 - width / 2
        //        y = Screen.height / 2 - height / 2
    }

    signal mytextChanged(var code)

    function setText(code){
        label.text=qsTr("from program")
        textArea.text=code
    }

    function getText(){
        return textArea.text
    }

    Shortcut {
        sequence: StandardKey.Open
        onActivated: openDialog.open()
    }
    Shortcut {
        sequence: StandardKey.SaveAs
        onActivated: saveDialog.open()
    }
    Shortcut {
        sequence: StandardKey.Quit
        onActivated: Qt.quit()
    }
    Shortcut {
        sequence: StandardKey.Copy
        onActivated: textArea.copy()
    }
    Shortcut {
        sequence: StandardKey.Cut
        onActivated: textArea.cut()
    }
    Shortcut {
        sequence: StandardKey.Paste
        onActivated: textArea.paste()
    }
    Shortcut {
        sequence: StandardKey.Bold
        onActivated: document.bold = !document.bold
    }
    Shortcut {
        sequence: StandardKey.Italic
        onActivated: document.italic = !document.italic
    }
    Shortcut {
        sequence: StandardKey.Underline
        onActivated: document.underline = !document.underline
    }

    //    MenuBar {
    //        Menu {
    //            title: qsTr("&File")

    //            MenuItem {
    //                text: qsTr("&Open")
    //                onTriggered: openDialog.open()
    //            }
    //            MenuItem {
    //                text: qsTr("&Save As...")
    //                onTriggered: saveDialog.open()
    //            }
    //            MenuItem {
    //                text: qsTr("&Quit")
    //                onTriggered: Qt.quit()
    //            }
    //        }

    //        Menu {
    //            title: qsTr("&Edit")

    //            MenuItem {
    //                text: qsTr("&Copy")
    //                enabled: textArea.selectedText
    //                onTriggered: textArea.copy()
    //            }
    //            MenuItem {
    //                text: qsTr("Cu&t")
    //                enabled: textArea.selectedText
    //                onTriggered: textArea.cut()
    //            }
    //            MenuItem {
    //                text: qsTr("&Paste")
    //                enabled: textArea.canPaste
    //                onTriggered: textArea.paste()
    //            }
    //        }

    //        Menu {
    //            title: qsTr("F&ormat")

    //            MenuItem {
    //                text: qsTr("&Bold")
    //                checkable: true
    //                checked: document.bold
    //                onTriggered: document.bold = !document.bold
    //            }
    //            MenuItem {
    //                text: qsTr("&Italic")
    //                checkable: true
    //                checked: document.italic
    //                onTriggered: document.italic = !document.italic
    //            }
    //            MenuItem {
    //                text: qsTr("&Underline")
    //                checkable: true
    //                checked: document.underline
    //                onTriggered: document.underline = !document.underline
    //            }
    //        }
    //    }

    FileDialog {
        id: openDialog
        title: qsTr("open A3200 program file")
        fileMode: FileDialog.OpenFile
        selectedNameFilter.index: 0
        nameFilters: ["A3200 files (*.PGM)","Text files (*.txt)", "HTML files (*.html *.htm)"]
        folder: document.getDefaultDir(0)//StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        onAccepted: document.load(file)
    }

    FileDialog {
        id: saveDialog
        title: qsTr("export A3200 program file")
        fileMode: FileDialog.SaveFile
        defaultSuffix: document.fileType
        nameFilters: openDialog.nameFilters
        selectedNameFilter.index: document.fileType === "txt" ? 1 : 0
        folder: document.getDefaultDir(1)
        onAccepted: document.saveAs(file)
    }

    FontDialog {
        id: fontDialog
        onAccepted: {
            document.fontFamily = font.family;
            document.fontSize = font.pointSize;
        }
    }

    ColorDialog {
        id: colorDialog
        currentColor: "black"
    }

    MessageDialog {
        id: errorDialog
    }

    ToolBar {
        height: 54
        anchors.bottom: flickable.top
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.top: label.bottom
        anchors.topMargin: 0
        leftPadding: 8

        Flow {
            id: flow1
            anchors.fill: parent

            Row {
                id: fileRow
                ToolButton {
                    id: openButton
                    text: "\uF115"
                    anchors.verticalCenter: parent.verticalCenter // icon-folder-open-empty
                    font.family: "fontello"
                    onClicked: openDialog.open()
                }
//                ToolButton {
//                    id: saveButton
//                    anchors.verticalCenter: parent.verticalCenter
//                    icon.source: "qrc:/Resource/icons/saveas.png"
 //                      antialiasing: true
//                    onClicked: saveDialog.open()
//                    antialiasing: true
//                }
                ToolSeparator {
                    anchors.verticalCenter: parent.verticalCenter
                    contentItem.visible: fileRow.y === editRow.y
                }
            }

            Row {
                id: editRow
                ToolButton {
                    id: copyButton
                    text: "\uF0C5"
                    anchors.verticalCenter: parent.verticalCenter // icon-docs
                    font.family: "fontello"
                    focusPolicy: Qt.TabFocus
                    enabled: textArea.selectedText
                    onClicked: textArea.copy()
                }
                ToolButton {
                    id: cutButton
                    text: "\uE802"
                    anchors.verticalCenter: parent.verticalCenter // icon-scissors
                    font.family: "fontello"
                    focusPolicy: Qt.TabFocus
                    enabled: textArea.selectedText
                    onClicked: textArea.cut()
                }
                ToolButton {
                    id: pasteButton
                    text: "\uF0EA"
                    anchors.verticalCenter: parent.verticalCenter // icon-paste
                    font.family: "fontello"
                    focusPolicy: Qt.TabFocus
                    enabled: textArea.canPaste
                    onClicked: textArea.paste()
                }
                ToolSeparator {
                    anchors.verticalCenter: parent.verticalCenter
                    contentItem.visible: editRow.y === formatRow.y
                }
            }

            Row {
                id: formatRow
                ToolButton {
                    id: boldButton
                    text: "\uE800"
                    anchors.verticalCenter: parent.verticalCenter // icon-bold
                    font.family: "fontello"
                    focusPolicy: Qt.TabFocus
                    checkable: true
                    checked: document.bold
                    onClicked: document.bold = !document.bold
                }
                ToolButton {
                    id: italicButton
                    text: "\uE801"
                    anchors.verticalCenter: parent.verticalCenter // icon-italic
                    font.family: "fontello"
                    focusPolicy: Qt.TabFocus
                    checkable: true
                    checked: document.italic
                    onClicked: document.italic = !document.italic
                }
                ToolButton {
                    id: underlineButton
                    text: "\uF0CD"
                    anchors.verticalCenter: parent.verticalCenter // icon-underline
                    font.family: "fontello"
                    focusPolicy: Qt.TabFocus
                    checkable: true
                    checked: document.underline
                    onClicked: document.underline = !document.underline
                }
                ToolButton {
                    id: fontFamilyToolButton
                    text: qsTr("\uE808")
                    anchors.verticalCenter: parent.verticalCenter // icon-font
                    font.family: "fontello"
                    font.bold: document.bold
                    font.italic: document.italic
                    font.underline: document.underline
                    onClicked: {
                        fontDialog.currentFont.family = document.fontFamily;
                        fontDialog.currentFont.pointSize = document.fontSize;
                        fontDialog.open();
                    }
                }
                ToolButton {
                    id: textColorButton
                    text: "\uF1FC"
                    anchors.verticalCenter: parent.verticalCenter // icon-brush
                    font.family: "fontello"
                    focusPolicy: Qt.TabFocus
                    onClicked: colorDialog.open()

                    Rectangle {
                        width: aFontMetrics.width + 3
                        height: 2
                        color: document.textColor
                        parent: textColorButton.contentItem
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.baseline: parent.baseline
                        anchors.baselineOffset: 6

                        TextMetrics {
                            id: aFontMetrics
                            font: textColorButton.font
                            text: textColorButton.text
                        }
                    }
                }
                ToolSeparator {
                    anchors.verticalCenter: parent.verticalCenter
                    contentItem.visible: formatRow.y === alignRow.y
                }
            }

            Row {
                id: alignRow
                ToolButton {
                    id: alignLeftButton
                    text: "\uE803"
                    anchors.verticalCenter: parent.verticalCenter // icon-align-left
                    font.family: "fontello"
                    focusPolicy: Qt.TabFocus
                    checkable: true
                    checked: document.alignment === Qt.AlignLeft
                    onClicked: document.alignment = Qt.AlignLeft
                }
                ToolButton {
                    id: alignCenterButton
                    text: "\uE804"
                    anchors.verticalCenter: parent.verticalCenter // icon-align-center
                    font.family: "fontello"
                    focusPolicy: Qt.TabFocus
                    checkable: true
                    checked: document.alignment === Qt.AlignHCenter
                    onClicked: document.alignment = Qt.AlignHCenter
                }
                ToolButton {
                    id: alignRightButton
                    text: "\uE805"
                    anchors.verticalCenter: parent.verticalCenter // icon-align-right
                    font.family: "fontello"
                    focusPolicy: Qt.TabFocus
                    checkable: true
                    checked: document.alignment === Qt.AlignRight
                    onClicked: document.alignment = Qt.AlignRight
                }
                ToolButton {
                    id: alignJustifyButton
                    text: "\uE806"
                    anchors.verticalCenter: parent.verticalCenter // icon-align-justify
                    font.family: "fontello"
                    focusPolicy: Qt.TabFocus
                    checkable: true
                    checked: document.alignment === Qt.AlignJustify
                    onClicked: document.alignment = Qt.AlignJustify
                }
            }
        }
    }

    DocumentHandler {
        id: document
        document: textArea.textDocument
        cursorPosition: textArea.cursorPosition
        selectionStart: textArea.selectionStart
        selectionEnd: textArea.selectionEnd
        textColor: colorDialog.color
        //Component.onCompleted: document.load("qrc:/Qml/textEditor/texteditor.html")
        onLoaded: {
            switch(fileType){
            case "PGM":
                textArea.textFormat=Qt.PlainText
                break
            case "html":
                textArea.textFormat=Qt.RichText
                break
            case "text":
                textArea.textFormat=Qt.AutoText
                break
            default:
                textArea.textFormat=Qt.AutoText
                break
            }
            label.text=filePath
            textArea.text = text
        }
        //        onFileTypeChanged: {

        //            switch(fileType){
        //            case "PGM":
        //                textArea.textFormat=Qt.PlainText
        //                break
        //            case "html":
        //                textArea.textFormat=Qt.RichText
        //                break
        //            case "text":
        //                textArea.textFormat=Qt.AutoText
        //                break
        //            default:
        //                textArea.textFormat=Qt.AutoText
        //                break
        //            }


        //        }

        onError: {
            errorDialog.text = message
            errorDialog.visible = true
        }
    }

    Flickable {
        id: flickable
        anchors.rightMargin: 1
        anchors.leftMargin: 1
        anchors.bottomMargin: 1
        anchors.topMargin: 83
        flickableDirection: Flickable.VerticalFlick
        anchors.fill: parent




        TextArea.flickable: TextArea {
            id: textArea
            //textFormat:Qt.PlainText
            wrapMode: TextArea.Wrap
            font.family: "Calibri"
            font.pointSize: 12
            focus: true
            selectByMouse: true
            persistentSelection: true
            // Different styles have different padding and background
            // decorations, but since this editor is almost taking up the
            // entire window, we don't need them.
            leftPadding: 6
            rightPadding: 6
            topPadding: 0
            bottomPadding: 0
            background: Rectangle{
                color:"wheat"
            }


            onTextChanged: mytextChanged(text)
            MouseArea {
                x:flickable.visibleArea.xPosition*parent.width
                y:flickable.visibleArea.yPosition*parent.height
                width:flickable.visibleArea.widthRatio*parent.width
                height:flickable.visibleArea.heightRatio*parent.height

                cursorShape: Qt.IBeamCursor
                acceptedButtons: Qt.RightButton
                onClicked: {contextMenu.open();console.log(x,y,width,height)}
            }

            onLinkActivated: Qt.openUrlExternally(link)
        }

        ScrollBar.vertical: ScrollBar {}
    }

    Menu {
        id: contextMenu

        MenuItem {
            text: qsTr("Copy")
            enabled: textArea.selectedText
            onTriggered: textArea.copy()
        }
        MenuItem {
            text: qsTr("Cut")
            enabled: textArea.selectedText
            onTriggered: textArea.cut()
        }
        MenuItem {
            text: qsTr("Paste")
            enabled: textArea.canPaste
            onTriggered: textArea.paste()
        }

        MenuSeparator {}

        MenuItem {
            text: qsTr("Font...")
            onTriggered: fontDialog.open()
        }

        MenuItem {
            text: qsTr("Color...")
            onTriggered: colorDialog.open()
        }
    }

    Label {
        id: label

        height: 36
        text: qsTr(document.filePath)
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 12
        font.family: "Calibri"
        verticalAlignment: Text.AlignVCenter
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.left: parent.left
        anchors.leftMargin: 94
        anchors.top: parent.top
        anchors.topMargin: 1
        background: Rectangle{
            color: "Silver"
        }

    }

    Label {
        id: label1
        x: -3
        y: 0
        height: 36
        color: "Crimson"
        text: qsTr("current file: ")
        font.pointSize: 12
        font.family: "Calibri"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        anchors.top: parent.top
        anchors.rightMargin: 0
        anchors.leftMargin: 1
        anchors.left: parent.left
        anchors.right: label.left
        anchors.topMargin: 1
        background: Rectangle{
            color: "Silver"
        }
    }
}

/*##^## Designer {
    D{i:15;anchors_height:45}
}
 ##^##*/
