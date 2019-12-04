import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.1
import "MyButton/"


//import hjl.laser 1.0
Item {
    width: 800
    height: 800

    //    LaserControl {
    //        id:laser
    //    }
    Rectangle {

        id: rectangle
        color: "#e9ffd6"
        z: 0
        antialiasing: true
        border.color: "#5a8754"
        anchors.fill: parent

        Rectangle {
            id: rectangle2
            x: 154
            y: 8
            width: 638
            height: 460
            color: "darkgray"
            antialiasing: true
            border.width: 1
            border.color: "black"

            TableSetting {

                id: tableViewMain
                x: -71
                y: -471
                width: 638
                height: 460
                anchors.rightMargin: 2
                anchors.leftMargin: 2
                anchors.bottomMargin: 2
                anchors.topMargin: 2
                anchors.fill: parent
                myListModel: myTable.get(mylistView.currentIndex).content
            }
        }

        ListModel {
            id: buttonInfo

            ListElement {
                name: "Laser"
                img: "qrc:/Resource/icons/laser.svg"
            }

            ListElement {
                name: "Flow"
                img: "qrc:/Resource/icons/strategy.svg"
            }

            ListElement {
                name: "Common"
                img: "qrc:/Resource/icons/paper-plane.svg"
            }

            ListElement {
                name: "Test"
                img: "qrc:/Resource/icons/paper-plane.svg"
            }
        }

        ListModel {
            id: myTable

            ListElement {

                content: [
                    ListElement {
                        item: "MCS"
                        value1: 100
                        value2: "Set the output power level,range:0-1000"
                    },

                    ListElement {

                        item: "PRF"
                        value1: 10
                        value2: "Set the pulse rate,range:1-100kHz"
                    },

                    ListElement {
                        item: "PSN"
                        value1: 6
                        value2: "Set number of Pulses in Burst Mode,range:1-14"
                    },

                    ListElement {
                        item: "ID1"
                        value1: 45
                        value2: "Set the Diode 1 current,range:40-100"
                    },

                    ListElement {

                        item: "ID2"
                        value1: 45
                        value2: "Set the Diode 2 current,range:40-100"
                    },

                    ListElement {

                        item: "ID3"
                        value1: 45
                        value2: "Set the Diode 3 current,range:40-100"
                    },
                    ListElement {
                        item: "T1S"
                        value1: 45
                        value2: "Set the laser operation to Green operation or IR operating.,range:0-9"
                    }
                ]
            }

            ListElement {

                content: [
                    ListElement {
                        item: "openLaser"
                        value1: 0
                        value2: "Whether open laser when processing"
                    },
                    ListElement {
                        item: "currentPosStart"
                        value1: 0
                        value2: "Whether start processing on current position"
                    }
                ]
            }
            ListElement {

                content: [
                    ListElement {
                        item: "CheckDoor"
                        value1: 1
                        value2: "Whether check the door before processing"
                    },
                    ListElement {
                        item: "CheckTube"
                        value1: 1
                        value2: "Whether check the Tube before processing"
                    },
                    ListElement {
                        item: "UseGas"
                        value1: 1
                        value2: "Whether use gas when processing"
                    },
                    ListElement {
                        item: "CloseDoor"
                        value1: 1
                        value2: "Whether close front door before processing"
                    }
                ]
            }
            ListElement {

                content: [
                    ListElement {
                        item: "MCS1"
                        value1: 1
                        value2: "Set the output power level,range:0-1000"
                    }
                ]
            }
        }

        HMessageBox {
            id: kmg
        }

        Rectangle {
            id: rectangle1
            x: 15
            y: 8
            width: 140
            height: 460
            antialiasing: true
            border.width: 1
            border.color: "black"

            ScrollView {
                anchors.rightMargin: 1
                anchors.leftMargin: 1
                anchors.bottomMargin: 1
                anchors.topMargin: 1
                anchors.fill: parent
                focusPolicy: Qt.WheelFocus | Qt.ClickFocus
                clip: true
                contentHeight: 460
                contentWidth: 140
                background: Rectangle {
                    color: "ivory"
                }

                ListView {
                    id: mylistView
                    anchors.fill: parent
                    model: buttonInfo
                    delegate: Item {
                        width: 140
                        height: 40
                        MouseArea {
                            anchors.fill: parent
                            onClicked: mylistView.currentIndex = index
                        }

                        RowLayout {
                            id: rowLayout
                            anchors.rightMargin: 0
                            anchors.bottomMargin: 0
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            Image {
                                width: 25
                                height: 25
                                antialiasing: true
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.preferredHeight: 25
                                Layout.preferredWidth: 25
                                clip: false
                                Layout.fillHeight: false
                                Layout.fillWidth: false
                                source: img
                            }

                            Text {
                                text: name
                                verticalAlignment: Text.AlignVCenter
                                Layout.preferredHeight: 25
                                Layout.preferredWidth: 97
                                font.pixelSize: 15
                               // font.family: "Calibri"
                            }
                        }
                    }

                    highlight: Rectangle {
                        color: "lightsteelblue"
                        radius: 5
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

                    //                    onCurrentIndexChanged: {
                    //                        tableViewMain.clearAll()
                    //                        switch(currentIndex)
                    //                        {
                    //                        case 0:
                    //                            for(var i=0;i<myTable.count;i++)
                    //                                tableViewMain.addRowData(myTable.get(i))
                    //                            break
                    //                        case 1:
                    //                            for(i=0;i<myTable1.count;i++)
                    //                                tableViewMain.addRowData(myTable1.get(i))
                    //                            break
                    //                        case 2:
                    //                            for(i=0;i<myTable2.count;i++)
                    //                                tableViewMain.addRowData(myTable2.get(i))
                    //                            break
                    //                        case 3:
                    //                            for(i=0;i<myTable3.count;i++)
                    //                                tableViewMain.addRowData(myTable3.get(i))
                    //                            break
                    //                        default:

                    //                        }

                    //                    }
                }
            }
        }

        MyButton {
            id: myButton
            x: 154
            y: 506
            width: 152
            height: 52
            buttonText: "Apply"
            onMyButttonLeftclicked: {
                //console.log(myTable.get(0).value1)
                var temp1 = []
                for (var j = 1; j < myTable.get(
                         mylistView.currentIndex).content.count + 1; j++) {
                    if (laser.setValue(j, myTable.get(
                                           mylistView.currentIndex).content.get(
                                           j - 1).value1) === -1) {
                        //console.log(myTable.get(mylistView.currentIndex).content.get(j-1).item)
                        temp1.push(myTable.get(
                                       mylistView.currentIndex).content.get(
                                       j - 1).item)
                    }
                }
                if (temp1.length !== 0) {
                    kmg.title = "warning"
                    kmg.prompt = temp1.join(",") + " apply failed!"
                    kmg.doModal()
                }
            }
        }

        MyButton {
            id: myButton1
            x: 497
            y: 506
            width: 152
            height: 52
            buttonText: "Save"
            onMyButttonLeftclicked: {

                var temp1 = []
                for (var j = 0; j < myTable.get(
                         mylistView.currentIndex).content.count; j++) {
                    //console.log(j,myTable.get(mylistView.currentIndex).content.get(j-1).value1)
                    if (laser.saveValue(
                                myTable.get(
                                    mylistView.currentIndex).content.get(
                                    j).item, myTable.get(
                                    mylistView.currentIndex).content.get(
                                    j).value1) === -1) {

                        temp1.push(myTable.get(
                                       mylistView.currentIndex).content.get(
                                       j).item)
                    }
                }
                if (temp1.length !== 0) {
                    kmg.title = "warning"
                    kmg.prompt = temp1.join(",") + " save failed!"
                    kmg.doModal()
                }
                if (!laser.writeProgram()) {
                    kmg.title = "warning"
                    kmg.prompt = temp1.join(",") + " write to file failed!"
                    kmg.doModal()
                }
            }
        }
    }
}
