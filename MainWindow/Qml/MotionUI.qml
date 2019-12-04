import QtQuick 2.6
import QtQuick.Controls.Material 2.1
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4 as Control14
import QtQuick.Controls.Styles 1.4
import QtCharts 2.2
import myMotion 1.0
import "MyButton"

Rectangle {
    id: rectangle4

    width: 950
    height: 900
    antialiasing: true


    property var statusType: ["disconnect", "error",
            "disable", "homing", "moving", "ready"]

    property bool mEnable: true


    function homeAll(){
        myMotion.startHomeAll()
    }

    signal myhomeDone(var isSucceed);




    HMessageBox {
        id: messageBox
    }

    MotionHandler {
        id: myMotion

        onRefreshStatus: {
            tablemode.setProperty(axis, "value1", pos)
            tablemode.setProperty(axis, "value2", vel)
            tablemode.setProperty(axis, "value3", statusType[state])
        }

        onMoveDone: {
            if (!isSucceed) {
                messageBox.title = qsTr("error")
                messageBox.prompt = msg
                messageBox.doModal()
            }
        }
        onHomeDone:{
            messageBox.title = isSucceed?qsTr("note"):qsTr("error")
            messageBox.prompt = msg
            messageBox.doModal()
        }
        onHomeAllDone: {
            myhomeDone(isSucceed)
            messageBox.title = isSucceed?qsTr("note"):qsTr("error")
            messageBox.prompt = msg
            messageBox.doModal()
        }

    }

    Rectangle {
        id: rectangle1
        width: 542
        height: 349
        color: "#ffffff"
        anchors.left: parent.left
        anchors.leftMargin: 3
        anchors.top: parent.top
        anchors.topMargin: 47
        border.width: 2

        Rectangle {
            id: table
            anchors.bottomMargin: 0
            anchors.fill: parent
            ListModel {
                id: tablemode

                ListElement {

                    item: "θ"
                    value1: "0.000"
                    value2: "0.000"
                    value3: qsTr("disable")
                }

                ListElement {

                    item: "X"
                    value1: "0.000"
                    value2: "0.000"
                    value3: qsTr("ready")
                }

                ListElement {
                    item: "Y"
                    value1: "0.000"
                    value2: "0.000"
                    value3: qsTr("error")
                }

                ListElement {
                    item: "Z"
                    value1: "0.000"
                    value2: "0.000"
                    value3: qsTr("moving")
                }
            }

            onWidthChanged: {

                if (tableView.width !== table.width) {
                    tableView.width = table.width
                }
            }
            onHeightChanged: {
                if (tableView.height !== table.height) {
                    tableView.height = table.height
                }
            }

            Control14.TableView {
                id: tableView
                anchors.fill: parent
                alternatingRowColors: true
                selectionMode: Control14.SelectionMode.SingleSelection


                Control14.TableViewColumn {
                    role: "item"
                    title: "axis"

                    movable: false
                    resizable: false
                    delegate: Rectangle {
                        function getColor() {
                            switch (styleData.value) {
                            case "X":
                                return "#0CA68B"
                            case "Y":
                                return "#EFC849"
                            case "θ":
                                return "gray"
                            case "Z":
                                return  "#238DB1"
                            default:
                                return "white"
                            }
                        }
                        color: getColor()
                        border.width: 1
                        border.color: "palevioletred"
                        antialiasing: true
                        Text {

                            anchors.verticalCenter: parent.verticalCenter
                            //anchors.fill: parent
                            anchors.horizontalCenter: parent.horizontalCenter
                            //anchors.leftMargin: 50
                           // font.family: "Calibri"
                            color: "black"
                            text: styleData.value
                            font.pixelSize: parent.height * 0.3
                        }
                    }
                    width: 40 //tableView.viewport.width/tableView.columnCount+30
                }
                Control14.TableViewColumn {
                    role: "value1"
                    title: "pos(mm)"
                    movable: false
                    resizable: false
                    width: (tableView.viewport.width - 40) / (tableView.columnCount - 1)
                }

                Control14.TableViewColumn {
                    role: "value2"
                    title: "vel(mm/s)"
                    movable: false
                    resizable: false
                    width: (tableView.viewport.width - 40) / (tableView.columnCount - 1)
                }

                Control14.TableViewColumn {
                    role: "value3"
                    title: "status"
                    movable: false
                    resizable: false
                    width: (tableView.viewport.width - 40) / (tableView.columnCount - 1)
                }

                Control14.TableViewColumn {
                    role: "value4"
                    title: "home"
                    movable:false
                    resizable :false
                    width: (tableView.viewport.width-40)/(tableView.columnCount-1)

                    delegate:Rectangle{
                        id:homeButton
                        border.width: 1
                        border.color: "navy"
                        antialiasing:true
                        color : styleData.selected ? "moccasin":"plum"
                        enabled: true
                        MyButton {
                            id: leftmove9
                            anchors.centerIn: parent
                            height:parent.height<parent.width?parent.height:parent.width-10
                            width:parent.height<parent.width?parent.height:parent.width
                            imgRes: "qrc:/Resource/icons/home.svg"
                            rightButtonEnable:false

                            isEnable: mEnable
                            myRadius: 5
                            onMyButttonLeftclicked: {
                                myMotion.startHome(styleData.row)
                            }

                        }
                    }
                }

                Control14.TableViewColumn {
                    role: "value4"
                    title: "enabled"
                    movable:false
                    resizable :false
                    width: (tableView.viewport.width-40)/(tableView.columnCount-1)

                    delegate:Rectangle{
                        anchors.fill:parent
                        border.width: 1
                        border.color: "black"
                        Switch {
                            anchors.fill:parent
                            antialiasing: true
                            wheelEnabled: true
                            checked:true
                            enabled: mEnable
                            background: Rectangle {
                                anchors.fill: parent
                                color:"mistyrose"
                                border.width: parent.hovered?2:1
                                border.color: parent.hovered?"red":"black"
                            }

                            onClicked: {
                                myMotion.enableAxis(styleData.row,checked)
                            }


                        }
                    }
                }

                model: tablemode

                //自定义表头代理
                headerDelegate: Rectangle {
                    //color: "#00498C"
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: "gainsboro"
                        }
                        GradientStop {
                            position: 1.0
                            color: "darkgrey"
                        }
                    }

                    color: styleData.selected ? "blue" : "darkgray"
                    height: 40

                    border.color: "black"
                    border.width: 1
                    radius: 0
                    Text {
                        //font.family: "Calibri"
                        anchors.centerIn: parent
                        text: styleData.value
                        font.pixelSize: parent.height * 0.45
                    }
                }

                //行代理可以修改行高等信息
                rowDelegate: Rectangle {
                    height: (table.height - 42) / tablemode.count
                    color: "#052641"
                    anchors.leftMargin: 2
                }
                itemDelegate: Rectangle {
                    //color: "#052641"
                    border.width: 1
                    border.color: "navy"
                    antialiasing: true
                    color: styleData.selected ? "moccasin" : "aquamarine"
                    Text {
                        function getTextColor() {
                            switch (styleData.column) {
                            case 0:
                                switch (styleData.value) {
                                case "X":
                                    return "#EFC849"
                                default:
                                    return "black"
                                }
                            case 1:
                                return "black"
                            case 2:
                                return "black"
                            case 3:

                                switch (styleData.value) {
                                case "disconnect":
                                    return "red"
                                case "error":
                                    return "red"
                                case "disable":
                                    return "grey"
                                case "homing":
                                    return "blue"
                                case "ready":
                                    return "green"
                                default:
                                    return "black"
                                }
                            default:
                                return "black"
                            }
                        }
                        function getText() {
                            if (styleData.row === 0)
                                if (styleData.column === 1)
                                    return "Deg"
                                else
                                    return "Deg/s"
                            else if (styleData.column === 1)
                                return "mm"
                            else
                                return "mm/s"
                        }

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        //font.family: "Calibri"
                        color: getTextColor()
                        text: styleData.value
                        font.pixelSize: parent.height * 0.23
                    }
                }

                //                     style: TableViewStyle{
                //                         textColor: "white"
                //                         highlightedTextColor : "#00CCFE"  //选中的颜色
                //                         backgroundColor : "#052641"
                //                     }
            }
        }
    }

    Rectangle {
        id: motionTable
        height: 349
        color: "Burlywood"
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 47
        anchors.left: parent.left
        anchors.leftMargin: 557

        border.color: "#696969"

        MyButton {
            id: leftmove
            x: 216
            y: 182
            width: 70
            height: 70
            buttonText: "Y-"
            imgRes: "qrc:/Resource/icons/left2.svg"
             isEnable: mEnable
            onMyButttonLeftclicked: {
                //isEnable=false
                myMotion.startMove(1, 2, -spinBox.value / 1000,
                                   spinBox1.value / 1000)
            }

            onMyButttonRightpressed: {
                myMotion.startMove(0, 2, -24,spinBox1.value / 1000)
            }
            onMyButttonRightreleased: {
                myMotion.stopMove(2)
            }
        }

        MyButton {
            id: rightmove
            x: 307
            y: 182
            width: 70
            height: 70
            text: ""
            buttonText: "Y+"
            imgRes: "qrc:/Resource/icons/right1.svg"
              isEnable: mEnable
            onMyButttonLeftclicked: {
                //isEnable=false
                myMotion.startMove(1, 2, spinBox.value / 1000,
                                   spinBox1.value / 1000)
            }
            onMyButttonRightpressed: {
                myMotion.startMove(0, 2, 24,spinBox1.value / 1000)
            }
            onMyButttonRightreleased: {
                myMotion.stopMove(2)
            }
        }

        MyButton {
            id: backmove
            x: 307
            y: 266
            width: 70
            height: 70
            buttonText: "Z+"
            imgRes: "qrc:/Resource/icons/up.svg"
             isEnable: mEnable
            onMyButttonLeftclicked: {
                //isEnable=false
                myMotion.startMove(1, 3, spinBox.value / 1000,
                                   spinBox1.value / 1000)
            }
            onMyButttonRightpressed: {
                myMotion.startMove(0, 3, 20,spinBox1.value / 1000)
            }
            onMyButttonRightreleased: {
                myMotion.stopMove(3)
            }
        }

        MyButton {
            id: behindmove
            x: 216
            y: 266
            width: 70
            height: 70
            buttonText: "Z-"
            imgRes: "qrc:/Resource/icons/down.svg"
            isEnable: mEnable
            onMyButttonLeftclicked: {
                //isEnable=false
                myMotion.startMove(1, 3, -spinBox.value / 1000,
                                   spinBox1.value / 1000)
            }
            onMyButttonRightpressed: {
                myMotion.startMove(0, 3, -43,spinBox1.value / 1000)
            }
            onMyButttonRightreleased: {
                myMotion.stopMove(3)
            }
        }

        MyButton {
            id: ccwmove
            x: 216
            y: 16
            width: 70
            height: 70
            text: ""
            buttonText: "θ-"
            imgRes: "qrc:/Resource/icons/CCW.svg"
             isEnable: mEnable
            onMyButttonLeftclicked: {
                //isEnable=false
                myMotion.startMove(1, 0, -spinBox.value / 1000,
                                   spinBox1.value / 1000)
            }
            onMyButttonRightpressed: {
                myMotion.startMove(0, 0, -99999,spinBox1.value / 1000)
            }
            onMyButttonRightreleased: {
                myMotion.stopMove(0)
            }
        }

        MyButton {
            id: cwmove
            x: 307
            y: 16
            width: 70
            height: 70
            buttonText: "θ+"
            imgRes: "qrc:/Resource/icons/CW.svg"
             isEnable: mEnable
            onMyButttonLeftclicked: {
                //isEnable=false
                myMotion.startMove(1, 0, spinBox.value / 1000,
                                   spinBox1.value / 1000)
            }
            onMyButttonRightpressed: {
                myMotion.startMove(0, 0, 99999,spinBox1.value / 1000)
            }
            onMyButttonRightreleased: {
                myMotion.stopMove(0)
            }
        }

        MyButton {
            id: leftmove2
            x: 216
            y: 98
            width: 70
            height: 70
            buttonText: "X-"
            isEnable: mEnable

            imgRes: "qrc:/Resource/icons/left.svg"
            rotation: 0
            onMyButttonLeftclicked: {
                //isEnable=false
                myMotion.startMove(1, 1, -spinBox.value / 1000,
                                   spinBox1.value / 1000)
            }
            onMyButttonRightpressed: {
                myMotion.startMove(0, 1, -125, spinBox1.value / 1000)
            }
            onMyButttonRightreleased: {
                myMotion.stopMove(1)
            }
        }

        MyButton {
            id: rightmove2
            x: 307
            y: 98
            width: 70
            height: 70
            buttonText: "X+"
             isEnable: mEnable

            isMirror: true
            imgRes: "qrc:/Resource/icons/left.svg"
            rotation: 0
            onMyButttonLeftclicked: {
                //isEnable=false
                myMotion.startMove(1, 1, spinBox.value / 1000,
                                   spinBox1.value / 1000)
            }
            onMyButttonRightpressed: {

                myMotion.startMove(0, 1, 125,spinBox1.value / 1000)
            }
            onMyButttonRightreleased: {

                myMotion.stopMove(1)
            }
        }

        Rectangle {
            id: stepPara
            x: 8
            y: 29
            width: 195
            height: 307

            color: "Burlywood"
            anchors.top: parent.top
            anchors.topMargin: 21
            anchors.right: parent.right
            anchors.rightMargin: 182
            z: 0
            antialiasing: true

            border.color: "#696969"

            ColumnLayout {
                id: rowLayout
                y: 0
                height: 133
                antialiasing: true
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                spacing: 5

                Label {
                    id: label
                    width: 90
                    height: 43
                    text: qsTr("step(mm)")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredHeight: 43
                    Layout.preferredWidth: 90
                    font.pointSize: 13
                    //font.family: "Calibri"

                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: false
                    Layout.fillHeight: false
                }

                SpinBox {
                    id: spinBox

                    stepSize: 100
                     enabled:  mEnable

                    Layout.fillWidth: false
                    clip: true
                    from: 0
                    to: 1000000
                    editable: true
                    antialiasing: true
                   // font.family: "Calibri"

                    wheelEnabled: true

                    property int decimals: 3
                    property real realValue: value / 1000
                    x: 109
                    width: 180
                    height: 43
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredHeight: 43
                    Layout.preferredWidth: 180
                    value: 1000
                    font.pointSize: 12

                    Layout.fillHeight: false
                    validator: DoubleValidator {
                        bottom: spinBox.from
                        top: spinBox.to
                    }

                    textFromValue: function (value, locale) {
                        return Number(value / 1000).toLocaleString(locale, 'f',
                                                                   spinBox.decimals)
                    }

                    valueFromText: function (text, locale) {
                        return Number.fromLocaleString(locale, text) * 1000
                    }

                    onValueChanged: {
                        spinBox.value = value
                    }
                }
            }

            ColumnLayout {
                id: rowLayout1
                y: 159
                height: 148
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0

                Label {
                    id: label1
                    width: 90
                    height: 43

                    text: qsTr("vel(mm/s)")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredHeight: 43
                    Layout.preferredWidth: 90
                    Layout.fillHeight: false
                    Layout.fillWidth: false
                    font.pointSize: 13
                    horizontalAlignment: Text.AlignHCenter

                    verticalAlignment: Text.AlignVCenter
                    topPadding: 0
                    //font.family: "Calibri"
                }

                SpinBox {
                    id: spinBox1

                    value: 5000
                     enabled:  mEnable

                    //font.family: "Calibri"
                    antialiasing: true
                    editable: true
                    transformOrigin: Item.Center

                    wheelEnabled: true
                    stepSize: 1000
                    from: 0
                    to: 1000000
                    clip: true

                    property int decimals: 3
                    property real realValue: value / 1000
                    x: 109
                    width: 180
                    height: 43
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredHeight: 43
                    Layout.preferredWidth: 180
                    font.pointSize: 12
                    Layout.fillHeight: false
                    Layout.fillWidth: false
                    validator: DoubleValidator {
                        bottom: spinBox1.from
                        top: spinBox1.to
                    }

                    textFromValue: function (value, locale) {
                        return Number(value / 1000).toLocaleString(
                                    locale, 'f', spinBox1.decimals)
                    }

                    valueFromText: function (text, locale) {
                        return Number.fromLocaleString(locale, text) * 1000
                    }
                    onValueChanged: {
                        spinBox1.value = value
                    }
                }
            }
        }
    }

    //        Timer {
    //            interval: 100; running: true; repeat: true
    //            property int num: -20
    //            onTriggered: {
    //                //console.log(count,Math.random())
    //                var y=10*Math.random()
    //                y=y>5?y*1:y*(-2)
    //                lineSeries.append(num,y)
    //                point.clear()
    //                point.append(num,y)

    //                var k=10*Math.random()
    //                k=k>5?k*1:k*(-2)
    //                lineSeries1.append(num,k)

    //                if(num>19){
    //                    line.scrollRight(line.plotArea.width/lineSeries.axisX.tickCount/4);

    //                    line1.scrollRight(line1.plotArea.width/lineSeries.axisX.tickCount/4);

    //                    //            if(num>25){
    //                    //               //lineSeries.remove(0)
    //                    //            }
    //                }
    //                num++
    //            }
    //        }
    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            var x = myMotion.getCurrentPos(2)
            var y = myMotion.getCurrentPos(3)
            point1.clear()
            point1.append(x, y)
            if (x > line2x.max) {
                line.scrollRight((x - line2x.max) * line.plotArea.width
                                 / lineSeries.axisX.tickCount / 10)
            }
            if (x < line2x.min) {
                line.scrollLeft((-x + line2x.min) * line.plotArea.width
                                / lineSeries.axisX.tickCount / 10)
            }
            if (y > line2y.max) {
                line.scrollUp((y - line2y.max) * line.plotArea.height
                              / lineSeries.axisY.tickCount / 10)
            }
            if (y < line2y.min) {
                line.scrollDown((-y + line2y.min) * line.plotArea.height
                                / lineSeries.axisY.tickCount / 10)
            }
        }
    }



    ChartView {
        id: line1
        x: 513
        width: 435
        height: 341
        plotAreaColor: "honeydew"
        backgroundColor: "#65c8a7"
        backgroundRoundness: 0.1
        dropShadowEnabled: true
        anchors.top: parent.top
        anchors.topMargin: 416
        anchors.right: parent.right
        anchors.rightMargin: 2

        ScatterSeries {
            id: point1
            name: qsTr("Y-Z series")
            markerSize: 12
            axisX: ValueAxis {
                id: line2x
                titleText: "Y axis"
                min: -30
                max: 30
                tickCount: 6
                labelFormat: "%d"
            }
            axisY: ValueAxis {
                id: line2y
                titleText: "Z axis"
                min: -50
                max: 50
                tickCount: 10
                labelFormat: "%d"
            }
            useOpenGL: true
            color: "royalblue"
        }
        antialiasing: true
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        property int num: 0
        onTriggered: {
            //console.log(count,Math.random())
            if (num > 1000000){
                lineSeries.clear()
                num=0
            }
            var x = myMotion.getCurrentPos(1)
            var y = myMotion.getCurrentPos(0)

            if (Math.abs(point.at(0).x - x) > 0.001 || Math.abs(
                        point.at(0).y - y) > 0.001) {
                point.clear()
                point.append(x, y)
                lineSeries.append(x, y)
                if (x > line1x.max-1) {
                    line.scrollRight((x - (line1x.max-1)) * line.plotArea.width
                                     / lineSeries.axisX.tickCount / 4)
                }
                if (x < line1x.min+1) {
                    line.scrollLeft((-x + line1x.min+1) * line.plotArea.width
                                    / lineSeries.axisX.tickCount / 4)
                }
                if (y > line1y.max-1) {
                    line.scrollUp((y - (line1y.max-1)) * line.plotArea.height
                                  / lineSeries.axisY.tickCount / 4)
                }
                if (y < line1y.min+1) {
                    line.scrollDown((-y + line1y.min+1) * line.plotArea.height
                                    / lineSeries.axisY.tickCount / 4)
                }
                num++
            }
        }
    }

    ChartView {
        id: line
        x: 2
        y: 8
        width: 505
        height: 341
        z: 1
        plotAreaColor: "honeydew"
        backgroundColor: "#65c8a7"
        backgroundRoundness: 0.5
        dropShadowEnabled: true
        anchors.top: parent.top
        anchors.topMargin: 416
        anchors.left: parent.left
        anchors.leftMargin: 3
        antialiasing: true
        //margins: "50,50,50,50"
        //plotArea: Qt.rect(x + 100, y + 100, width * 0.6,width * 0.6 * (line1y.max - line1y.min) / (line1x.max - line1x.min))





        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            z: 2

            onClicked: {
                if (mouse.button === Qt.RightButton)
                    contextMenu.popup()
            }
            onPressAndHold: {
                if (mouse.source === Qt.MouseEventNotSynthesized)
                    contextMenu.popup()
            }

            Menu {
                id: contextMenu
                MenuItem {
                    text: qsTr("Clear dispaly")
                    onTriggered:{
                        lineSeries.clear()
                    }
                }

                MenuItem {
                    text: qsTr("Show maximized")
                    property bool isBig: false
                    onTriggered:{
                        if(!isBig){
                            line.anchors.leftMargin = -960
                            line.anchors.topMargin = 100
                            line.width = 1200
                            line.height = 695
                            text=qsTr("Show normal")
                            isBig=true
                        }
                        else{
                            line.anchors.top = rectangle4.top
                            line.anchors.topMargin = 416
                            line.anchors.left = rectangle4.left
                            line.anchors.leftMargin = 3
                            line.width = 505
                            line.height = 341
                            text=qsTr("Show maximized")
                            isBig=false
                        }
                    }
                }
            }
        }

        LineSeries {
            name: qsTr("X-Theta series")
            id: lineSeries
            axisX: ValueAxis {
                id: line1x
                titleText: "X axis"
                min: -20
                max: 20
                tickCount: 10
                labelFormat: "%d"
            }
            axisY: ValueAxis {
                id: line1y
                titleText: "Theta axis"
                min: -10
                max: 10
                tickCount: 5
                labelFormat: "%d"
            }
            useOpenGL: true
            color: "royalblue"
            width: 1
        }

        ScatterSeries {
            id: point
            name: qsTr("latest point")
            markerSize: 12
            XYPoint {
                x: myMotion.getCurrentPos(1)
                y: myMotion.getCurrentPos(0)
            }
        }

    }


}
