
import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id:table


    //[add header]
    function addColunm(rolorstr, titlestr)
    {

        var prefix = 'import QtQuick 2.7;import QtQuick.Controls 1.4;TableViewColumn {width: tableView.viewport.width/tableView.columnCount;';
        //创建TableViewColumn的代码
        //循环添加TableViewColumn
        var str = prefix  +"role:\"" + rolorstr + "\";title:\"" + titlestr + "\"}";
        tableView.addColumn(Qt.createQmlObject(str,tableView,"qrc:/TableViewItem.qml"));
    }
    //[!add header]

    //[addrowdata]
    function addRowData(d)
    {
        tablemode.append(d);
    }
    //[!addrowdata]

    function modifyRowData(index,name,value){
        tablemode.setProperty(index,name,value)
    }

    /////////////////////////////
    ListModel {
        id: tablemode

        ListElement {

            item: "X"
            value1:"100.000"
            value2:"200.000"
            value3:qsTr("disable")



        }


        ListElement {

            item: "Y"
            value1:"1000.000"
            value2:"2000.000"
            value3:qsTr("ready")


        }

        ListElement {
            item: "R"
            value1:"521.000"
            value2:"5412.000"
            value3:qsTr("error")


        }

        ListElement {
            item: "Z"
            value1:"5214.000"
            value2:"21.000"
            value3:qsTr("moving")


        }

        ListElement {

            item: "S"
            value1:"12.000"
            value2:"0.000"
            value3:qsTr("moving")


        }

    }

    onWidthChanged: {
        if(tableView.width!==table.width){
            tableView.width=table.width}
    }
    onHeightChanged: {
        if(tableView.height!==table.height){
            tableView.height=table.height}
    }

    TableView{
        id :tableView
        alternatingRowColors : true
        selectionMode:SelectionMode.SingleSelection

        TableViewColumn {
            role: "item"
            title: "axis"
            movable:false
            resizable :false
            delegate: Rectangle{
                function getColor(){
                    switch(styleData.value){
                    case "X":
                        return "#EFC849"
                    case "Y":
                        return "#238DB1"
                    case"R":
                        return "gray"
                    case"Z":
                        return "#0CA68B"
                    default:
                        return "white"
                    }

                }
                color:getColor()
                border.width: 1
                border.color: "palevioletred"
                antialiasing:true
                Text {


                    anchors.verticalCenter: parent.verticalCenter
                    //anchors.fill: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    //anchors.leftMargin: 50
                    font.family: "Calibri"
                    color : "black"
                    text: styleData.value
                    font.pixelSize: parent.height*0.4

                }
            }
            width: 40//tableView.viewport.width/tableView.columnCount+30
        }
        TableViewColumn {
            role: "value1"
            title: "pos(mm)"
            movable:false
            resizable :false
            width: (tableView.viewport.width-40)/(tableView.columnCount-1)
        }

        TableViewColumn {
            role: "value2"
            title: "vel(mm/s)"
            movable:false
            resizable :false
            width: (tableView.viewport.width-40)/(tableView.columnCount-1)
        }

        TableViewColumn {
            role: "value3"
            title: "status"
            movable:false
            resizable :false
            width: (tableView.viewport.width-40)/(tableView.columnCount-1)
        }

        TableViewColumn {
            role: "value4"
            title: "initialize"
            movable:false
            resizable :false
            width: (tableView.viewport.width-40)/(tableView.columnCount-1)
            delegate:Rectangle{
                border.width: 1
                border.color: "navy"
                antialiasing:true
                color : styleData.selected ? "moccasin":"plum"
                MyButton {
                    id: leftmove
                    anchors.centerIn: parent
                    height:parent.height<parent.width?parent.height:parent.width-10
                    width:parent.height<parent.width?parent.height:parent.width
                    imgRes: "qrc:/Resource/icons/home.svg"
                    rightButtonEnable:false
                    isEnable: true
                    myRadius: 5
                    onMyButttonLeftclicked: {
                        //leftMove.width=200
                    }

                }
            }
        }


        model: tablemode

        //自定义表头代理
        headerDelegate:
            Rectangle{
            //color: "#00498C"
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
                font.family: "Calibri"
                anchors.centerIn : parent
                text: styleData.value
                font.pixelSize: parent.height*0.4
            }
        }


        //行代理可以修改行高等信息
        rowDelegate: Rectangle {
            height: (table.height-42)/tablemode.count
            color: "#052641"
            anchors.leftMargin: 2


        }
        itemDelegate: Rectangle{
            //color: "#052641"
            border.width: 1
            border.color: "navy"
            antialiasing:true
            color : styleData.selected ? "moccasin":"aquamarine"
            Text {
                function getTextColor(){
                    switch(styleData.column){
                    case 0:

                        switch(styleData.value){
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
                        switch(styleData.value){
                        case "moving":
                            return "blue"
                        case "disable":
                            return "darkgrey"
                        case "error":
                            return "red"
                        case "ready":
                            return "black"
                        }
                        break
                    default:
                        return "black"
                    }
                }
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Calibri"
                color : getTextColor()
                text: styleData.value
                font.pixelSize: styleData.column===3?parent.height*0.4:parent.height*0.35
            }
        }

        //                     style: TableViewStyle{
        //                         textColor: "white"
        //                         highlightedTextColor : "#00CCFE"  //选中的颜色
        //                         backgroundColor : "#052641"
        //                     }
    }

}
