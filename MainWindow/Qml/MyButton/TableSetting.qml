import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.1

Item {
    id:table
    antialiasing: true

    function addRowData(d)
    {

        myListModel.append(d)

    }


    function modifyRowData(index,name,value){

        myListModel.setProperty(index,name,value)
    }

    function clearAll(){

        myListModel.clear()
    }

    function reSet(){
        myListModel.clear()
        for(var k=0;k<myProgramModel.count;k++){
            myListModel.append(myProgramModel.get(k))
        }
    }

    property var typeArray: [/*2, 2, 2, 2, 1,*/0,0, 1, 1, 1, 0, 2]
    property ListModel myListModel:ListModel{}


    signal mydataChanged(var index,var value)

    Component.onCompleted: {
       reSet()
    }


    ListModel {
        id: myProgramModel
//        ListElement {
//            item: "MCS"
//            value1: "10"
//            value2: qsTr("  Set the output power level,range:0-1000")
//        }
//        ListElement {
//            item: "PRF"
//            value1: "100"
//            value2: qsTr("  Set the pulse rate,range:1-100kHz")
//        }
//        ListElement {
//            item: "PSN"
//            value1: "1"
//            value2: qsTr("  Set number of Pulses in Burst Mode,range:1-14")
//        }
        //        ListElement {
        //            item: "ID1"
        //            value1: "4500"
        //            value2: qsTr("  Set the Diode 1 current,range:4000-10000")
        //        }
        //        ListElement {
        //            item: "ID2"
        //            value1: "4500"
        //            value2: qsTr("  Set the Diode 2 current,range:4000-10000")
        //        }
        //        ListElement {
        //            item: "ID3"
        //            value1: "4500"
        //            value2: qsTr("  Set the Diode 3 current,range:4000-10000")
        //        }
//        ListElement {
//            item: "T1S"
//            value1: "5526"
//            value2: "  Set the laser operation to Green operation,range:4536-5526"
//        }
//        ListElement {
//            item: "openLaser"
//            value1: "1"
//            value2: qsTr("  Whether open laser when processing")
//        }
        ListElement {
            item: qsTr("Focus-Y")
            value1: "0"
            value2: qsTr("  The laser focus of Y axis")
        }
        ListElement {
            item: qsTr("Focus-Z")
            value1: "0"
            value2: qsTr("  The laser focus of Z axis")
        }
//        ListElement {
//            item: qsTr("currentPosStart")
//            value1: "0"
//            value2: qsTr("  Whether start processing on current position")
//        }

        ListElement {
            item: qsTr("checkTube")
            value1: "1"
            value2: qsTr("  Whether check the Tube before processing")
        }
        ListElement {
            item: qsTr("useGas")
            value1: "1"
            value2: qsTr("  Whether use gas when processing")
        }
        ListElement {
            item: qsTr("closeDoor")
            value1: "1"
            value2: qsTr("  Whether close front door before processing")
        }
        ListElement {
            item: qsTr("processLength")
            value1: "10"
            value2: qsTr("  The length of per process,unit:mm")
        }
        ListElement {
            item: qsTr("processCount")
            value1: "1"
            value2: qsTr("  The count of process,Automatic continuous processing when it is -1")
        }
    }


    TableView{
        id :tableView

        anchors.fill: parent
        antialiasing: true
        highlightOnFocus: true
        selectionMode:SelectionMode.SingleSelection



        Component{
            id:textField
            TextField{
                readOnly: false
                selectByMouse:true
                anchors.fill:parent
                //font.family: "Calibri"
                text:myValue
                color : "black"
                horizontalAlignment:TextInput.AlignHCenter
                verticalAlignment :TextInput.AlignVCenter
                font.pixelSize: parent.height*0.35
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor;
                    acceptedButtons: Qt.NoButton
                }
                background: Rectangle {
                    anchors.fill: parent
                    color:"mistyrose"
                    border.width: parent.activeFocus?2:1
                    border.color: parent.activeFocus?"red":"black"
                }
                onDisplayTextChanged:{
                    if(myRow!==-1)
                        myListModel.setProperty(myRow,"value1",text)
                }


            }
        }


        Component{
            id:textField1
            Label{
                color : "black"
                verticalAlignment: Text.AlignVCenter
                //font.family: "Calibri"
                text: styleData.value
                font.pixelSize: parent.height*0.25
                background: Rectangle {
                    anchors.fill: parent
                    //border.color: "#333"
                    color:"paleturquoise"
                    border.width: 1
                }
            }
            //            TextField{
            //                readOnly: true
            //                color : "black"
            //                selectByMouse:true
            //                anchors.verticalCenter: parent.verticalCenter
            //                anchors.horizontalCenter: parent.horizontalCenter
            //                font.family: "Calibri"
            //                text: styleData.value
            //                font.pixelSize: parent.height*0.4
            //                background: Rectangle {
            //                    anchors.fill: parent
            //                    //border.color: "#333"
            //                    color:"paleturquoise"
            //                    border.width: 1
            //                }
            //            }

        }
        Component{
            id:mySwitch
            Rectangle{
                anchors.fill:parent
                border.width: 1
                border.color: "black"
                Switch {
                    anchors.fill:parent
                    antialiasing: true
                    wheelEnabled: true
                    checked:Number(myValue)
                    background: Rectangle {
                        anchors.fill: parent
                        color:"mistyrose"
                        border.width: parent.hovered?2:1
                        border.color: parent.hovered?"red":"black"
                    }

                    onClicked: {
                        if(myRow!==-1){
                            mydataChanged(myRow,Number(checked).toString())
                            myListModel.setProperty(myRow, "value1",Number(checked).toString())
                        }
                    }


                }
            }
        }
        Component{
            id:mySpinBox

            Rectangle{
                anchors.fill:parent
                border.width: 1
                border.color: "black"

                SpinBox {
                    anchors.centerIn: parent
                    width:parent.width-2
                    //height: parent.height-2
                    Material.foreground: "black"
                    value:Number(myValue)
                    function getFromTo(){
                        switch(myRow){
//                        case 0:
//                            return [0,1000,10]
//                        case 1:
//                            return [1,100,1]
//                        case 2:
//                            return [1,14,1]
//                        case 3:
//                            return [4536,5526,1]
//                        case 4:
//                            return [1,1000,1]
                        case 6:
                            return [-1,1000,1]
                        default:
                            return [0,1,1]
                        }
                    }
                    from:getFromTo()[0]
                    to: getFromTo()[1]
                    stepSize: getFromTo()[2]
                    topPadding: 6
                    padding: 6
                    leftPadding: 46
                    font.weight: Font.Medium
                    editable: true
                    hoverEnabled:true
                    wheelEnabled: true
                    antialiasing: true
                    font.pointSize: parent.height*0.3
                    //font.family: "Calibri"
                    onValueModified: {
                        if(myRow!==-1){
                            mydataChanged(myRow,value.toString())
                            myListModel.setProperty(myRow, "value1",value.toString())
                        }

                    }

                }
            }

        }

        Component{
            id:myComboBox
            Rectangle{
                anchors.fill:parent
                border.width: 1
                border.color: "black"
                ComboBox{
                    anchors.fill:parent
                    antialiasing: true
                    wheelEnabled: true
                    currentIndex: 0
                    flat: true
                    editable: false
                    font.pointSize: 12
                    //font.family: "Calibri"
                    model:myValue
                    onCurrentTextChanged: {
                        if(myRow!==-1)
                            myListModel.setProperty(myRow, "value1",currentText)
                    }
                }
            }
        }
        Component{
            id:chooseType
            Loader{
                property var myValue: styleData.value
                property var myRow: styleData.row
                function getType(){

                    switch(typeArray[myRow]){
                    case 0:
                        return textField
                    case 1:
                        return mySwitch
                    case 2:
                        return mySpinBox
                    case 3:
                        return myComboBox
                    default:
                        return textField
                    }

                }

                sourceComponent: getType()

            }

        }


        TableViewColumn {
            id:firstcol
            role: "item"
            title: qsTr("Item")
            movable:false
            resizable :false
            delegate: Rectangle{
                color:"gray"
                border.width: 1
                //border.color: "palevioletred"
                antialiasing:true

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    //anchors.fill: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    //anchors.leftMargin: 50
                    //font.family: "Calibri"
                    color : "black"
                    text: styleData.value.toString()
                    font.pixelSize: parent.height*0.35

                }
            }
            width: 130//tableView.viewport.width/tableView.columnCount+30
        }

        TableViewColumn {
            id:col1
            role: "value1"
            title: qsTr("value")
            movable:false
            resizable :false
            width: 150//(tableView.viewport.width-firstcol.width)/(tableView.columnCount-1)
            delegate:chooseType

        }

        TableViewColumn {

            role: "value2"
            title: qsTr("explain")
            movable:false
            resizable :false
            width: tableView.viewport.width-firstcol.width-col1.width//(tableView.viewport.width-firstcol.width)/(tableView.columnCount-1)

            delegate: textField1
        }

        model:myListModel

        //自定义表头代理
        headerDelegate:
            Rectangle{
            gradient: Gradient {
                GradientStop { position: 0.0; color: "gainsboro" }
                GradientStop { position: 1.0; color: "darkgrey" }
            }

            color : styleData.selected ? "blue": "darkgray"
            height: 40

            border.color: "black"
            border.width: 1
            radius: 0
            Text{
                //font.family: "Calibri"
                anchors.centerIn : parent
                text: styleData.value
                font.pixelSize: parent.height*0.45
            }
        }


        //行代理可以修改行高等信息
        rowDelegate: Component{
            Rectangle {
                color:"wheat"
                height: 50//(table.height-42)/tablemode.count
            }
        }

        //item 代理
        //        itemDelegate: Rectangle{
        //            //color: "#052641"
        //            border.width: 1
        //            //border.color: "navy"
        //            antialiasing:true
        //            //color : styleData.selected ? "moccasin":"aquamarine"
        //            Text {
        //                anchors.verticalCenter: parent.verticalCenter
        //                anchors.horizontalCenter: parent.horizontalCenter
        //                font.family: "Calibri"
        //                color : "blue"
        //                text: styleData.value
        //                font.pixelSize: styleData.column===3?parent.height*0.4:parent.height*0.35
        //            }
        //        }


        style: TableViewStyle{
            highlightedTextColor : "#00CCFE"  //选中的颜色
            backgroundColor : "wheat"
        }
    }

}


/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
