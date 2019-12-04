import QtQuick 2.8
import QtQuick.Window 2.10
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
//import QtQuick.Dialogs.qml 1.0
import Qt.labs.platform 1.0 as FileDialog10
import QtQuick.Controls.Material 2.1
//import QtQuick.Controls.Imagine 2.4
//import QtQuick.Controls.Universal 2.4
//import QtQuick.Dialogs 1.2
import myAdvance 1.0
import QtCharts 2.2
import QtMultimedia 5.8

//import "qrc:/Qml/"
import "MyButton/"
import "textEditor/qml/"

ApplicationWindow {
    id: applicationWindow
    width:1366 /*Window.width*/
    height: 768/*Window.height*/
    x:100
    y:200

    visible: true

    minimumHeight: 640
    minimumWidth: 480
//    maximumHeight: 1040
//    maximumWidth: 1920



    visibility: Window.Maximized
    flags: Qt.Window /*| Qt.CustomizeWindowHint*/ //|Qt.WindowStaysOnBottomHint



    title: qsTr("AOC Femto M-T Cutting")

//    onVisibilityChanged: {
//        if (visibility === Window.Windowed) {
//            applicationWindow.showMaximized()
//        }
//    }

    FileDialog10.MessageDialog {
        id: aboutDialog
        //buttons: MessageDialog.Ok
        text: qsTr("AOC\nVersion 1.0.0\ncontact us:hongjianli@inno-laser.com")
    }

    AdvanceSetting {
        id: advance
    }

    HMessageBox {
        id: pro
    }

    LightSwitch {
        id: lightSwitch
    }

    function reLang() {
        men.title = qsTr("View")
    }

    function saveToFile() {
        myMainWindow.setValue(0, codeEdit.getText())
        for (var b = 0; b < programTableSetting.myListModel.count; ++b) {
            myMainWindow.setValue(b + 1, programTableSetting.myListModel.get(b).value1)
        }
    }

    function newProgram() {
        codeEdit.setText("")
        myMainWindow.setNew()
        programTableSetting.reSet()
        //        for (var b = 0; b < programTableSetting.myListModel.count; ++b) {
        //            programTableSetting.myListModel.setProperty(b, "value1", "0")
        //        }
    }

    function getFromFile() {
        codeEdit.setText(myMainWindow.getValue(0))
        for (var b = 0; b < programTableSetting.myListModel.count; ++b) {
            programTableSetting.myListModel.setProperty(b, "value1", myMainWindow.getValue(b + 1))
        }
        myMainWindow.isModified(false)
    }

    Connections {
        target: myMainWindow
        onProgramChanged: {
            programTitle.text = name

            getFromFile()
        }

        onLanguageChanged: {
            reLang()
        }

        onTo_openProgram:{
            var k = myMainWindow.newProgram()
            if (k === 1) {
                saveToFile()
                myMainWindow.saveProgram()
            } else if (k === -1) {
                return
            }
            myMainWindow.openProgramPath(filePath)
            applicationWindow.showMaximized()
        }

        onProgramDone: {
            switch(msgType){
            case -1:
                pro.title = "error"
                break
            case 0:
                pro.title = "message"
                break
            case 1:
                pro.title = "attention"
                break
            default:
                pro.title = "message"
                break
            }

            pro.prompt = msg
            pro.doModal()
            mystate.state="ready"
        }
    }

    Item{
        id:mystate
        states: [
            State {
                name: "ready"
                PropertyChanges {
                    target: start
                    isEnable:true
                }
                PropertyChanges {
                    target: stop
                    isEnable:true
                }
                PropertyChanges {
                    target: home
                    isEnable:true
                }

                PropertyChanges {
                    target: startPos
                    isEnable:true
                }
                PropertyChanges {
                    target: endPos
                    isEnable:true
                }

                PropertyChanges {
                    target: motion
                    mEnable:true
                }
                //                PropertyChanges {
                //                    target: laser
                //                    enabled:true
                //                }
                PropertyChanges {
                    target: deviceState
                    enabled:true
                }
                PropertyChanges {
                    target: sysSwitch
                    enabled:true
                }

                PropertyChanges {
                    target: laserSwitch
                    enabled:true
                }
            },

            State {
                name: "running"
                PropertyChanges {
                    target: start
                    isEnable:false

                }
                PropertyChanges {
                    target: stop
                    isEnable:true
                }
                PropertyChanges {
                    target: home
                    isEnable:false
                }

                PropertyChanges {
                    target: startPos
                    isEnable:false
                }
                PropertyChanges {
                    target: endPos
                    isEnable:false
                }
                PropertyChanges {
                    target: home
                    isEnable:false
                }
                PropertyChanges {
                    target: home
                    isEnable:false
                }

                PropertyChanges {
                    target: motion
                    mEnable:false
                }

                //PropertyChanges {
                //target: laser
                //enabled:false
                //}

                PropertyChanges {
                    target: deviceState
                    enabled:false
                }

                PropertyChanges {
                    target: sysSwitch
                    enabled:false
                }

                PropertyChanges {
                    target: laserSwitch
                    enabled:false
                }
            },

            State {
                name: "error"
                PropertyChanges {
                    target: start
                    isEnable:false

                }
                PropertyChanges {
                    target: stop
                    isEnable:false
                }
                PropertyChanges {
                    target: home
                    isEnable:false
                }
            },

            State {
                name: "disable"
                PropertyChanges {
                    target: start
                    isEnable:false

                }
                PropertyChanges {
                    target: stop
                    isEnable:false
                }
                PropertyChanges {
                    target: home
                    isEnable:false
                }
                PropertyChanges {
                    target: motion
                    mEnable:false
                }

                PropertyChanges {
                    target: startPos
                    isEnable:false
                }
                PropertyChanges {
                    target: endPos
                    isEnable:false
                }
                PropertyChanges {
                    target: sysSwitch
                    enabled:false
                }

                PropertyChanges {
                    target: laserSwitch
                    enabled:false
                }

            }

        ]
    }

    //    FileDialog10.FileDialog {
    //        id: saveDialog
    //        title: qsTr("save HProgram file")
    //        fileMode: FileDialog10.FileDialog.SaveFile
    //        defaultSuffix: document.fileType
    //        nameFilters: openDialog.nameFilters
    //        // selectedNameFilter.index: 0
    //        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
    //        onAccepted: myMainWindow.saveProgramAs(file)
    //    }

    //    FileDialog10.FileDialog {
    //        id: openDialog
    //        title: qsTr("open HProgram file")
    //        fileMode: FileDialog10.FileDialog.OpenFile
    //        //        selectedNameFilter.index: 0
    //        nameFilters: ["HProgram files (*.hpro)"]
    //        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
    //        onAccepted: myMainWindow.openProgram(file)
    //    }


//////////////////////title///////////////////////////////////////
    menuBar: Rectangle {
        id: rectangle

        height: 30
        color: "SteelBlue"
        Label {
            id: programTitle
            width: parent.width - 120
            color: "black"
            text: "untitled"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.right: parent.left
            anchors.rightMargin: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            //font.family: "Calibri"
            font.pointSize: 14
        }

//        RowLayout {
//            id: rowLayout1
//            width: 120
//            spacing: 0
//            anchors.top: parent.top
//            anchors.topMargin: 0
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 0
//            anchors.right: parent.right
//            anchors.rightMargin: 0

//            Rectangle {

//                color: mouseArea1.containsMouse ? mouseArea1.pressed ? "lightgrey" : "grey" : "#00000000"
//                border.color: "#00000000"

//                Layout.preferredWidth: rowLayout1.width / 3
//                Layout.fillHeight: true
//                MouseArea {
//                    id: mouseArea1
//                    anchors.fill: parent
//                    hoverEnabled: true
//                    onClicked: {
//                        applicationWindow.showMinimized()
//                    }
//                }
//                Image {
//                    width: 18
//                    height: 18
//                    fillMode: Image.PreserveAspectFit
//                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    source: "qrc:/Resource/icons/minus-horizontal-straight-line.svg"
//                }
//            }

//            Rectangle {
//                color: mouseArea2.containsMouse ? mouseArea2.pressed ? "lightgrey" : "grey" : "#00000000"
//                border.color: "#00000000"

//                Layout.preferredWidth: rowLayout1.width / 3
//                Layout.fillHeight: true
//                MouseArea {
//                    id: mouseArea2
//                    anchors.fill: parent
//                    hoverEnabled: true
//                    onClicked: {
//                        applicationWindow.showMaximized()
//                    }
//                }
//                Image {
//                    width: 18
//                    height: 18
//                    fillMode: Image.PreserveAspectFit
//                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    source: "qrc:/Resource/icons/square-outlined-shape.svg"
//                }
//            }
//            Rectangle {
//                color: mouseArea3.containsMouse ? mouseArea3.pressed ? "pink" : "red" : "#00000000"
//                border.color: "#00000000"
//                Layout.preferredWidth: rowLayout1.width / 3
//                Layout.fillHeight: true
//                MouseArea {
//                    id: mouseArea3
//                    anchors.fill: parent
//                    hoverEnabled: true
//                    onClicked: {
//                        close()
//                    }
//                }
//                Image {
//                    width: 18
//                    height: 18

//                    fillMode: Image.PreserveAspectFit
//                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    source: "qrc:/Resource/icons/cross.svg"
//                }
//            }
//        }
    }

    header: MenuBar {

       background:Rectangle{
           color:"LightSkyBlue"
       }

        //font.family: "Calibri"

        Menu {

            //font.family: "Calibri"
            title: qsTr("File")

            MenuItem {
                text: qsTr("Open")
                //font.family: "Calibri"
                onTriggered: { myMainWindow.openProgram()}
            }
            MenuItem {
                text: qsTr("New")
                // font.family: "Calibri"
                onTriggered: {
                    var k = myMainWindow.newProgram()
                    if (k === 1) {
                        saveToFile()
                        myMainWindow.saveProgram()
                    } else if (k === -1) {
                        return
                    }
                    newProgram()
                }
            }
            MenuItem {
                //font.family: "Calibri"
                text: qsTr("Save")
                onTriggered: {saveToFile();myMainWindow.saveProgram()}
            }
            MenuItem {
                //font.family: "Calibri"
                text: qsTr("Save as...")
                onTriggered: {saveToFile();myMainWindow.saveProgramAs()}
            }
            MenuSeparator {
            }
            MenuItem {
                //font.family: "Calibri"
                text: qsTr("Quit")
                onTriggered: close()
            }
        }

        Menu {

            title: qsTr("Advance")
            //font.family: "Calibri"


            MenuItem {
                id:avcamera
                //font.family: "Calibri"
                text: qsTr("AVCamera")
                onTriggered: advance.openAVCamera()
            }

            MenuItem {
                id:stcamera
                // font.family: "Calibri"
                text: qsTr("STCamera")
                onTriggered: advance.openStCamera()
            }
            MenuItem {
                // font.family: "Calibri"
                text: qsTr("Settings")
                onTriggered: lightSwitch.show()
            }
        }

        Menu {
            id: men
            title: qsTr("View")
            //font.family: "Calibri"


            Menu {

                title: qsTr("Theme")
                //font.family: "Calibri"

                MenuItem {
                    id: style_Default
                    text: qsTr("Default")
                    // font.family: "Calibri"
                    onTriggered: {
                        myMainWindow.switchStyle("Default")
                        style_Default.checked=true
                        style_Material.checked=false
                        style_Fusion.checked=false
                        style_Imagine.checked=false
                        style_Universal.checked=false
                    }
                    checked: myMainWindow.getStyle()===text
                }

                MenuItem {
                    id: style_Material
                    //font.family: "Calibri"
                    text: qsTr("Material")
                    onTriggered: {
                        myMainWindow.switchStyle("Material")
                        style_Default.checked=false
                        style_Material.checked=true
                        style_Fusion.checked=false
                        style_Imagine.checked=false
                        style_Universal.checked=false
                    }
                    checked: myMainWindow.getStyle()===text
                }

                MenuItem {
                    id:style_Fusion
                    text: qsTr("Fusion")
                    onTriggered: {
                        myMainWindow.switchStyle("Fusion")
                        style_Default.checked=false
                        style_Material.checked=false
                        style_Fusion.checked=true
                        style_Imagine.checked=false
                        style_Universal.checked=false
                    }
                     checked: myMainWindow.getStyle()===text
                }
                MenuItem {
                    id:style_Imagine
                    text: qsTr("Imagine")
                    onTriggered: {
                        myMainWindow.switchStyle("Imagine")
                        style_Default.checked=false
                        style_Material.checked=false
                        style_Fusion.checked=false
                        style_Imagine.checked=true
                        style_Universal.checked=false
                    }
                     checked: myMainWindow.getStyle()===text
                }

                MenuItem {
                    id:style_Universal
                    text: qsTr("Universal")
                    onTriggered: {
                        myMainWindow.switchStyle("Universal")
                        style_Default.checked=false
                        style_Material.checked=false
                        style_Fusion.checked=false
                        style_Imagine.checked=false
                        style_Universal.checked=true
                    }
                     checked: myMainWindow.getStyle()===text
                }
            }

            Menu {

                title: qsTr("Language")
                //font.family: "Calibri"

                MenuItem {
                    id: en
                    text: qsTr("English")
                    // font.family: "Calibri"
                    onTriggered: {
                        myMainWindow.setLanguage("en")
                        checked = true
                        zh.checked = false
                    }
                    checked: myMainWindow.getLanguage() === "en" ? true : false
                }

                MenuItem {
                    id: zh
                    //font.family: "Calibri"
                    text: qsTr("简体中文")
                    onTriggered: {
                        myMainWindow.setLanguage("zh")
                        checked = true
                        en.checked = false
                    }
                    checked: myMainWindow.getLanguage() === "zh" ? true : false
                }

                MenuItem {
                    // font.family: "Calibri"
                    text: qsTr("日本語")
                    checked: false
                    enabled: false
                }
            }

        }

        Menu {
            title: qsTr("Help")
            //font.family: "Calibri"


            MenuItem {
                text: qsTr("About")
                //font.family: "Calibri"
                onTriggered: aboutDialog.open()
            }

        }
    }

    HMessageBox {
        id: kmg
        onMyMessageBoxOK: {
            if(myMainWindow.exitApp())
                Qt.quit(1)
        }
    }

    onClosing: {
        close.accepted = false

        //        if(laser.isConnected===2){
        //            pro.title = qsTr("warning")
        //            pro.prompt = qsTr("Laser Dio is initializing ,do not close application!!")
        //            pro.doModal()
        //            return
        //        }
        //        else if(laser.isConnected===1){
        //           laser.closeLaser()
        //        }

        kmg.title = qsTr("warning")
        kmg.prompt = qsTr("Are you sure to exit?")
        kmg.doModal()
    }
    ScrollView{
        id:scroll
        anchors.fill: parent
        contentHeight:947
        contentWidth:1920
        clip: true


        Rectangle {
            id: headRect
            height: 110
            color: "#00000000"
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
           // border.color: "black"

            TabBar {
                id: tabBar
                height: 30
                contentHeight: 38
                anchors.right: parent.right
                anchors.rightMargin: 0
                currentIndex: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                background: Rectangle {
                    color: "SeaGreen"
                }

                TabButton {
                    id: tabButton
                    width: 180
                    //font.family: "Calibri"
                    text: qsTr("START")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    background: Rectangle {
                        color: parent.checked ? "CornflowerBlue" : "SeaGreen"
                    }

                    //                Behavior on x {
                    //                    //SpringAnimation { spring: 5; damping: 0.2 }
                    //                }
                }



                TabButton {
                    id: tabButton3
                    width: 180
                    //font.family: "Calibri"
                    text: qsTr("Tools")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.left: tabButton.right
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    background: Rectangle {
                        color: parent.checked ? "CornflowerBlue" : "SeaGreen"
                    }
                }

                TabButton {
                    id: tabButton4
                    //font.family: "Calibri"
                    text: qsTr("")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    enabled: false
                    checkable: false
                    anchors.left: tabButton3.right
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    background: Rectangle {
                        color: parent.checked ? "powderblue" : "SeaGreen"
                    }
                }
            }
            StackLayout {
                height: 200
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: tabBar.bottom
                anchors.topMargin: 0
                antialiasing: true
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                currentIndex: tabBar.currentIndex

                Rectangle {
                    color: "powderblue"
                    ToolBar {

                        anchors.fill: parent
                        background: Rectangle {
                            gradient: Gradient {
                                GradientStop {
                                    position: 0
                                    color: "#eee"
                                }
                                GradientStop {
                                    position: 0.5
                                    color: "#ccc"
                                }
                            }
                        }

                        Flow {
                            anchors.fill: parent
                            Row {
                                id: row
                                height: parent.height
                                spacing: 0

                                MyButton {
                                    height: parent.height
                                    width: parent.height
                                    myRadius: 0
                                    buttonText: qsTr("open")
                                    buttonBorderWidth: 0
                                    imgRes: "qrc:/Resource/icons/folder.svg"

                                    onMyButttonLeftclicked: {
                                        var k = myMainWindow.newProgram()
                                        if (k === 1) {
                                            saveToFile()
                                            myMainWindow.saveProgram()
                                        } else if (k === -1) {
                                            return
                                        }
                                        newProgram()
                                        myMainWindow.openProgram()
                                    }
                                }
                                MyButton {
                                    myRadius: 0
                                    height: parent.height
                                    width: parent.height
                                    buttonBorderWidth: 0
                                    buttonText: qsTr("new")
                                    imgRes: "qrc:/Resource/icons/new.svg"
                                    onMyButttonLeftclicked: {
                                        var k = myMainWindow.newProgram()
                                        if (k === 1) {
                                            saveToFile()
                                            myMainWindow.saveProgram()
                                        } else if (k === -1) {
                                            return
                                        }
                                        newProgram()
                                    }
                                }

                                MyButton {
                                    myRadius: 0
                                    height: parent.height
                                    width: parent.height
                                    buttonBorderWidth: 0
                                    buttonText: qsTr("save")
                                    imgRes: "qrc:/Resource/icons/save.svg"
                                    onMyButttonLeftclicked: {
                                        saveToFile()
                                        myMainWindow.saveProgram()
                                    }
                                }
                                MyButton {
                                    myRadius: 0
                                    height: parent.height
                                    width: parent.height
                                    buttonBorderWidth: 0
                                    buttonText: qsTr("save as")
                                    imgRes: "qrc:/Resource/icons/export.svg"
                                    onMyButttonLeftclicked: {
                                        saveToFile()
                                        myMainWindow.saveProgramAs()
                                    }
                                }



                                ToolSeparator {
                                    id: toolSeparator1
                                    height: parent.height
                                }

                                MyButton {
                                    id:startPos
                                    myRadius: 0
                                    height: parent.height
                                    width: parent.height
                                    buttonBorderWidth: 0
                                    buttonText: qsTr("focus pos")
                                    imgRes: "qrc:/Resource/icons/compass.svg"
                                    onMyButttonLeftclicked: {

                                        myMainWindow.moveToFocus()
                                    }
                                }
                                MyButton {
                                    id:endPos
                                    myRadius: 0
                                    height: parent.height
                                    width: parent.height
                                    buttonBorderWidth: 0
                                    imgRes: "qrc:/Resource/icons/finish.svg"
                                    buttonText: qsTr("wait pos")
                                    onMyButttonLeftclicked: {

                                        myMainWindow.moveToWait()
                                    }
                                }
                                ToolSeparator {
                                    id: toolSeparator
                                    height: parent.height
                                }
                                MyButton {
                                    id:start
                                    height: parent.height
                                    width: parent.height
                                    myRadius: 0
                                    buttonText: qsTr("start")
                                    buttonBorderWidth: 0
                                    imgRes: "qrc:/Resource/icons/start.svg"
                                    onMyButttonLeftclicked: {
                                        //                                        if(laser.isConnected===2){
                                        //                                            pro.title=qsTr("error")
                                        //                                            pro.prompt = qsTr("laser controller is busy!")
                                        //                                            pro.doModal()
                                        //                                            return
                                        //                                        }

                                        if(programTitle.text==="untitled"){
                                            pro.title=qsTr("error")
                                            pro.prompt = qsTr("program is empty!")
                                            pro.doModal()
                                            return
                                        }
                                        saveToFile()
                                        myMainWindow.saveProgram()
                                        if(myMainWindow.runProgram()){
                                            mystate.state="running"
                                        }

                                    }
                                }
                                MyButton {
                                    id:stop
                                    myRadius: 0
                                    height: parent.height
                                    width: parent.height
                                    buttonBorderWidth: 0
                                    buttonText: qsTr("stop")
                                    imgRes: "qrc:/Resource/icons/stop.svg"
                                    onMyButttonLeftclicked: {
                                        if(myMainWindow.stopProgram()){
                                            mystate.state="ready"
                                        }
                                    }
                                }

                                MyButton {
                                    id:home
                                    myRadius: 0
                                    height: parent.height
                                    width: parent.height
                                    buttonBorderWidth: 0
                                    buttonText: qsTr("home")
                                    imgRes: "qrc:/Resource/icons/home.svg"
                                    onMyButttonLeftclicked: {
                                        motion.homeAll()
                                        mystate.state="disable"
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    ToolBar {
                        anchors.fill: parent
                        background: Rectangle {
                            gradient: Gradient {
                                GradientStop {
                                    position: 0
                                    color: "#eee"
                                }
                                GradientStop {
                                    position: 0.5
                                    color: "#ccc"
                                }
                            }
                        }
                        Flow {
                            anchors.fill: parent
                            Row {
                                height: parent.height
                                spacing: 0
                                MyButton {
                                    id:sysSwitch
                                    height: parent.height
                                    width: parent.height
                                    myRadius: 0
                                    buttonText: qsTr("Main sys")
                                    buttonBorderWidth: 0
                                    imgRes: "qrc:/Resource/icons/homepage.svg"

                                    property int type: 1

                                    onMyButttonLeftclicked: {
                                        if(type){
                                            if(myMainWindow.switchSystem(false)){
                                                pro.title=qsTr("message")
                                                pro.prompt =qsTr("switch to Coaxial system succeeded!")

                                                buttonText=qsTr("Coaxial sys")
                                                startPos.isEnable=false
                                                imgRes="qrc:/Resource/icons/homepage-grey.svg"
                                            }
                                            else{
                                                pro.title=qsTr("error")
                                                pro.prompt = qsTr("switch to Coaxial system failed!")
                                            }

                                            pro.doModal()

                                            type=0
                                        }
                                        else{


                                            if(myMainWindow.switchSystem(true)){
                                                buttonText=qsTr("Main sys")
                                                imgRes="qrc:/Resource/icons/homepage.svg"
                                                mystate.state="ready"
                                                startPos.isEnable=true
                                                pro.title=qsTr("message")
                                                pro.prompt = qsTr("switch to Main system succeeded!")
                                            }
                                            else{
                                                pro.title=qsTr("error")
                                                pro.prompt =qsTr("switch to Main system failed!")
                                            }


                                            pro.doModal()

                                            type=1
                                        }
                                    }
                                }
                                MyButton {
                                    id:laserSwitch
                                    height: parent.height
                                    width: parent.height
                                    myRadius: 0
                                    buttonText: qsTr("continues-off")
                                    buttonBorderWidth: 0
                                    imgRes: "qrc:/Resource/icons/laser-red.svg"
                                    property bool type: true

                                    onMyButttonLeftclicked: {
                                        if(type){
                                            if(myMainWindow.laserOn()){
                                                type=false
                                                buttonText=qsTr("continues-on")
                                                imgRes= "qrc:/Resource/icons/laser-green.svg"
                                            }
                                            else{
                                                pro.title=qsTr("error")
                                                pro.prompt =qsTr("Laser on failed!")
                                                pro.doModal()
                                            }
                                        }
                                        else{
                                            if(myMainWindow.laseroff()) {
                                                type=true
                                                buttonText=qsTr("continues-off")
                                                imgRes= "qrc:/Resource/icons/laser-red.svg"
                                            }
                                            else{
                                                pro.title=qsTr("error")
                                                pro.prompt =qsTr("Laser off failed!")
                                                pro.doModal()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    color: "powderblue"
                }
                Rectangle {

                    color: "powderblue"
                }
            }
        }

        ListModel {
            id: buttonInfo

            ListElement {
                name: qsTr("G-code")
                img: "qrc:/Resource/icons/paper-plane.svg"
            }

            ListElement {
                name: qsTr("processing parameters")
                img: "qrc:/Resource/icons/laser-red.svg"
            }

            ListElement {
                name: qsTr("Cameras")
                img: "qrc:/Resource/icons/camera.svg"
            }

            //        ListElement {
            //            name: qsTr("Flow")
            //            img: "qrc:/Resource/icons/strategy.svg"
            //        }

            //        ListElement {
            //            name: qsTr("Common")
            //            img: "qrc:/Resource/icons/paper-plane.svg"
            //        }
        }


        Rectangle {
            id: programRect
            width: scroll.contentWidth * 0.5
            color: "#ffffff"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: headRect.bottom
            anchors.topMargin: 0

            border.color: "lightcoral"
            border.width: 6

            Rectangle {
                id: listRect
                width: programRect.width * 0.25
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 7
                anchors.top: parent.top
                anchors.topMargin: 7
                anchors.left: parent.left
                anchors.leftMargin: 7

                antialiasing: true
                border.width: 1
                border.color: "black"

                ScrollView {
                    anchors.rightMargin: 1
                    anchors.leftMargin: 1
                    anchors.bottomMargin: 1
                    anchors.topMargin: 1
                    anchors.fill: parent
                    antialiasing: true
                    focusPolicy: Qt.WheelFocus | Qt.ClickFocus
                    clip: true
                    contentHeight: 460
                    contentWidth: listRect.width - 2

                    background: Rectangle {
                        color: "ivory"
                    }

                    ListView {
                        id: mylistView
                        anchors.bottomMargin: -408
                        anchors.rightMargin: 36
                        anchors.fill: parent
                        contentWidth: listRect.width - 2
                        contentHeight: 60
                        clip: false
                        model: buttonInfo
                        delegate: Item {
                            width: listRect.width - 2
                            height: 60
                            MouseArea {
                                anchors.fill: parent
                                onClicked: mylistView.currentIndex = index
                            }

                            RowLayout {
                                id: rowLayout
                                anchors.rightMargin: 0
                                anchors.bottomMargin: 0
                                anchors.fill: parent
                                anchors.leftMargin: 5
                                Image {
                                    id: imgh
                                    antialiasing: true
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    Layout.preferredHeight: 40
                                    Layout.preferredWidth: 40
                                    clip: false
                                    Layout.fillHeight: false
                                    Layout.fillWidth: false
                                    source: img
                                }

                                Text {
                                    text: name
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignLeft
                                    font.pixelSize: parent.width * 0.08
                                    //font.family: "Calibri"
                                }
                            }
                        }

                        highlight: Rectangle {
                            color: "lightsteelblue"
                            radius: 10
                            y: mylistView.currentItem.y
                            Behavior on y {
                                SpringAnimation {
                                    spring: 5
                                    damping: 0.2
                                }
                            }
                        }
                        focus: true
                        currentIndex: 0
                    }
                }
            }

            Rectangle {
                id: listContentRect
                width: programRect.width - listRect.width
                color: "#ffffff"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 7
                anchors.left: listRect.right
                anchors.leftMargin: 1
                anchors.top: parent.top
                anchors.topMargin: 7
                anchors.right: parent.right
                anchors.rightMargin: 6
                border.width: 1
                border.color: "black"

                StackLayout {
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0
                    anchors.rightMargin: 0
                    anchors.fill: parent
                    currentIndex: mylistView.currentIndex

                    MyTexteditor {
                        id: codeEdit
                        onMytextChanged: {
                            myMainWindow.isModified(true)
                        }
                    }

                    TableSetting {
                        id: programTableSetting
                        onMydataChanged: {
                            myMainWindow.isModified(true)
                        }
                    }

                    HCamera {
                        color: "beige"
                        onCameraStateChanged: {
                            if(index===0){
                                avcamera.enabled=isOK
                            }
                            if(index===1){
                                stcamera.enabled=isOK
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: tabRect
            x: -6
            y: 3
            width: scroll.contentWidth - programRect.width

            antialiasing: true
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            border.width: 6
            border.color: "tan"
            TabBar {
                id: tabBar1
                width: parent.width
                height: 38
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.topMargin: 6
                anchors.leftMargin: 6
                currentIndex: 0
                background: Rectangle {
                    color: tabBar1.currentIndex === 3 ? "beige" : "SeaGreen"
                }
                contentHeight: 38
                anchors.top: parent.top
                anchors.rightMargin: 6

                TabButton {
                    id: tabButton5
                    //width: 180
                    height: 38
                    text: qsTr("Motion")
                    font.pixelSize: 19
                    //font.family: "Calibri"

                    anchors.left: parent.left
                    anchors.topMargin: 0
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    icon.color: "skyblue"
                    icon.source: "qrc:/Resource/icons/motion.svg"
                    antialiasing: true

                    background: Rectangle {
                        color: parent.checked ? "beige" : "SeaGreen"
                    }
                }

                TabButton {
                    id: tabButton6
                    //width: 180
                    height: 38
                    text: qsTr("State")
                    font.pixelSize: 19
                    //font.family: "Calibri"
                    anchors.left: tabButton5.right
                    anchors.topMargin: 0
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    icon.color: "skyblue"
                    icon.source: "qrc:/Resource/icons/computer.svg"
                    background: Rectangle {
                        color: tabButton6.checked ? "beige" : "SeaGreen"
                    }
                }

                //            TabButton {
                //                id: tabButton7
                //                // width: 180
                //                height: 38
                //                text: qsTr("Camera")
                //                font.pixelSize: 19
                //                //font.family: "Calibri"
                //                anchors.left: tabButton6.right
                //                anchors.topMargin: 0
                //                anchors.leftMargin: 0
                //                anchors.top: parent.top
                //                icon.color: "skyblue"
                //                icon.source: "qrc:/Resource/icons/camera.svg"
                //                background: Rectangle {
                //                    color: tabButton7.checked ? "beige" : "#353637"
                //                }
                //            }

                //            TabButton {
                //                id: tabButton8
                //                //width: 180
                //                height: 38
                //                text: qsTr("Laser")
                //                clip: true
                //                font.pixelSize: 19
                //                font.family: "Calibri"
                //                anchors.left: tabButton7.right
                //                anchors.topMargin: 0
                //                anchors.leftMargin: 0
                //                anchors.top: parent.top
                //                icon.color: "skyblue"
                //                icon.source: "qrc:/Resource/icons/menu.svg"
                //                background: Rectangle {
                //                    color: tabButton8.checked ? "beige" : "#353637"
                //                }
                //            }

                //            TabButton {
                //                id: tabButton9
                //                height: 38
                //                text: qsTr("")
                //                anchors.left: tabButton8.right
                //                anchors.topMargin: 0
                //                enabled: false
                //                anchors.leftMargin: 0
                //                checkable: false
                //                anchors.top: parent.top
                //                background :Rectangle{
                //                    color:tabButton9.checked?"beige":"darkgreen"
                //                }
                //            }
            }

            StackLayout {
                anchors.bottomMargin: 6

                MotionUI {
                    id:motion
                    color: "beige"
                    onMyhomeDone: {
                        mystate.state="ready"
                    }
                }

                IoStatus {
                    id: deviceState
                    color: "beige"
                    onOutPutChanged: {
                        //console.log(index,value)
                    }
                }



                //            LaserSetting {
                //                id:laser
                //                color: "beige"
                //            }

                anchors.right: parent.right
                anchors.left: parent.left
                anchors.topMargin: 0
                anchors.leftMargin: 6
                anchors.bottom: parent.bottom
                currentIndex: tabBar1.currentIndex
                anchors.top: tabBar1.bottom
                anchors.rightMargin: 6
            }
            anchors.right: parent.right
            anchors.left: programRect.right
            anchors.topMargin: 0
            anchors.leftMargin: 0
            anchors.top: headRect.bottom
            anchors.rightMargin: 0
        }
    }
}

/*##^## Designer {
    D{i:123;anchors_width:60}
}
 ##^##*/
