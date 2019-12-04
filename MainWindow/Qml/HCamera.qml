import QtQuick 2.7
import QtMultimedia 5.8
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3
import "MyButton"

Rectangle {
    id: cameraUI

    width: 820
    height: 600
    signal cameraStateChanged(var index,var isOK)
    Timer {
        id: timer
        interval: 30
        running: false
        repeat: true
        onTriggered: CodeImage.getImage() /*?{}:stop()*/
    }

    Component.onCompleted: {
        if (CodeImage.openCamera()) {
            switch1.checked = true
            timer.start()
        }
    }

    Connections {
        target: CodeImage
        onCallQmlRefeshImg: {
            video1.source = "image://CodeImg/" + Math.random()
        }
        onAvStop: {
            camera.stop()
            video.visible = false
        }
        onAvStart: {
            camera.start()
            video.visible = true
        }

        onCameraStataus:{
            cameraStateChanged(index,isOK)
        }

    }
    Timer {
        id: timer1
        interval: 1500
        running: true
        repeat: false
        onTriggered: {
            captureImg.visible = false
            video.visible = true
        }
    }
    Camera {
        id: camera

        function getCameraId() {
            for (var k = 0; k < QtMultimedia.availableCameras.length; ++k) {

                if (QtMultimedia.availableCameras[k].displayName === "USB Camera DMC-1213") {
                    // console.log(k, QtMultimedia.availableCameras[k].displayName)
                    return QtMultimedia.availableCameras[k].deviceId
                }
            }
            return QtMultimedia.availableCameras[0].deviceId
        }
        deviceId: getCameraId() //QtMultimedia.availableCameras[0].deviceId
        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash
        exposure {
            manualShutterSpeed: -1
            manualIso: -1
            manualAperture: -1
            exposureCompensation: -1.0
            meteringMode: Camera.MeteringAverage
            exposureMode: Camera.ExposureModeVendor
        }
        captureMode: Camera.CaptureViewfinder

        imageCapture {
            onImageSaved: {
                // Show the preview in an Image
                label.text = qsTr("picture has saved in: ") + path
            }

            onImageCaptured: {
                captureImg.source = preview
                video.visible = false
                captureImg.visible = true
                timer1.start()
            }
        }

        videoRecorder {
            mediaContainer: "avi"
            resolution: "640x480"
            videoBitRate: 100000
            videoCodec: "h264"
            outputLocation: "D:/aj/test.avi"
            frameRate: 24
        }

        //flash.mode: Camera.FlashRedEyeReduction
    }

    //    Camera{
    //        id: camera1
    //        deviceId:QtMultimedia.availableCameras[1].deviceId
    //        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceAuto

    //        exposure {
    //            exposureCompensation: 1
    //            exposureMode: Camera.ExposurePortrait
    //        }

    //        flash.mode: Camera.FlashRedEyeReduction

    //        imageCapture {
    //            onImageCaptured: {

    //                photoPreview.source = preview  // Show the preview in an Image
    //            }
    //        }
    //    }
    TabBar {
        id: tabBar
        height: 60
        width: parent.width * 0.6
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        currentIndex: 0

        onCurrentIndexChanged: {

            switch (currentIndex) {
            case 0:
                video.state = "state1"
                video1.state = "state3"
                switch1.state = "camera1"

                break
            case 1:
                video.state = "state3"
                video1.state = "state1"
                switch1.state = "camera2"
                break
            case 2:
                video.state = "state2"
                video1.state = "state2"
                switch1.state = "cameraAll"
                break
            }
        }

        TabButton {
            id: tabButtonCamera1
            height: tabBar.height
            width: tabBar.width / 3
            //font.family: "Calibri"
            text: qsTr("auxiliary camera")
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            rotation: 0
            font.pointSize: 12
        }

        TabButton {
            id: tabButtonCamera2

            height: tabBar.height
            width: tabBar.width / 3

            //font.family: "Calibri"
            text: qsTr("cutter camera")
            anchors.left: tabButtonCamera1.right
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            rotation: 0
            font.pointSize: 12
        }

        TabButton {
            id: tabButtonALL
            height: tabBar.height
            width: tabBar.width / 3

            //font.family: "Calibri"
            text: qsTr("all dispaly")
            clip: false
            anchors.left: tabButtonCamera2.right
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            rotation: 0
            font.pointSize: 12
        }
    }

    Rectangle {
        id: rectangle
        color: "grey"

        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        anchors.top: tabBar.bottom
        anchors.right: cameraUI.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 5


        Image {
            id: captureImg
            anchors.centerIn: video
            width: video.width
            height: video.width * (video.sourceRect.height / video.sourceRect.width)
            visible: false

        }

        VideoOutput {
            id: video
            width: 640
            height: 480
            visible: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            source: camera
            focus: visible

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    if (mouse.button === Qt.RightButton)
                        contextMenu1.popup()
                }
                onPressAndHold: {
                    if (mouse.source === Qt.MouseEventNotSynthesized)
                        contextMenu1.popup()
                }

                Menu {
                    id: contextMenu1
                    MenuItem {
                        id:mcross1
                        text: "Show cross"
                        checked: false
                        onTriggered:{
                            cross3.visible=!cross3.visible
                            cross4.visible=!cross4.visible
                            checked=cross3.visible
                        }
                    }
                }
            }
            Rectangle{
                id:cross3
                antialiasing: true
                visible: false
                anchors.centerIn: parent
                width:parent.width
                height:1
                color:"red"
                z:1
            }
            Rectangle{
                id:cross4
                 antialiasing: true
                visible: false
                anchors.centerIn: parent
                width:1
                color:"red"
                height:parent.height
                z:1
            }



            state: "state1"
            states: [
                State {
                    name: "state1"
                    PropertyChanges {
                        target: video
                        width: rectangle.width
                        height: width * (sourceRect.height / sourceRect.width)
                        anchors.verticalCenterOffset: 0
                        visible: switch1.checked
                    }
                },

                State {
                    name: "state2"
                    PropertyChanges {
                        target: video

                        height: rectangle.height / 2 - 1
                        width: height / (sourceRect.height / sourceRect.width)
                        anchors.verticalCenterOffset: -rectangle.height / 4
                        visible: true
                    }
                },

                State {
                    name: "state3"
                    PropertyChanges {
                        target: video
                        visible: false
                    }
                }
            ]
        }



        Image {
            id: video1
            visible: false
            anchors.verticalCenter: parent.verticalCenter
            //fillMode: Image.PreserveAspectFith
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter


            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
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
                        id:mcross
                        text: "Show cross"
                        checked: false
                        onTriggered:{
                            cross1.visible=!cross1.visible
                            cross2.visible=!cross2.visible
                            checked=cross1.visible
                        }
                    }
                }
            }

            Rectangle{
                id:cross1
                 antialiasing: true
                visible: false
                anchors.centerIn: parent
                width:parent.width
                height:1
                color:"red"
                z:1
            }
            Rectangle{
                id:cross2
                 antialiasing: true
                visible: false
                anchors.centerIn: parent
                width:1
                color:"red"
                height:parent.height
                z:1
            }


            state: "state3"
            states: [
                State {
                    name: "state1"
                    PropertyChanges {
                        target: video1
                        width: rectangle.width
                        height: width * (480 / 640)
                        anchors.verticalCenterOffset: 0
                        visible: switch1.checked
                    }
                },
                State {
                    name: "state2"
                    PropertyChanges {
                        target: video1
                        height: rectangle.height / 2 - 1
                        width: height / (480 / 640)
                        anchors.verticalCenterOffset: rectangle.height / 4
                        visible: true
                    }
                },
                State {
                    name: "state3"
                    PropertyChanges {
                        target: video1
                        visible: false
                    }
                }
            ]
        }

        Rectangle {
            id: rectangle1
              antialiasing: true
            color: "black"
            z: -1
            anchors.fill: parent
        }

        Image {
            id: image
              antialiasing: true
            width: 120
            height: 50
            fillMode: Image.PreserveAspectFit
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            visible: false
            source: "qrc:/Resource/icons/rec.svg"
        }

        Timer {
            id: timer3
            interval: 3000
            running: false
            repeat: false
            onTriggered: label.visible = false
        }

        Label {
            id: label
            width: 600
            height: 50
              antialiasing: true
            color: "#2ef69c"
            text: qsTr("")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 15
            //font.family: "Calibri"
            anchors.left: image.right
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0

            onTextChanged: {
                visible = true
                timer3.stop()
                timer3.start()
            }
        }
    }

    Switch {
        id: switch1
        width: 119
        height: 41
        text: checked ? qsTr("open") : qsTr("close")
        anchors.left: parent.left
        anchors.leftMargin: 18
        anchors.top: parent.top
        anchors.topMargin: 16
        font.pointSize: 13
       // font.family: "Calibri"
        state: "camera1"
        states: [
            State {
                name: "camera1"
                PropertyChanges {
                    target: switch1
                    checked: camera.cameraStatus === 8 ? true : false
                }
            },
            State {
                name: "camera2"
                PropertyChanges {
                    target: switch1
                    checked: CodeImage.isOpen
                }
            },

            State {
                name: "cameraAll"
                PropertyChanges {
                    target: switch1
                    checked: false
                    enabled: false
                }
            }
        ]

        onClicked: {

            switch (tabBar.currentIndex) {
            case 0:
                checked ? camera.start() : camera.stop()
                video.visible = checked ? true : false
                break
            case 1:
                function temp() {
                    CodeImage.closeCamera()
                    timer.stop()
                }
                checked ? (CodeImage.openCamera() ? timer.start() : timer.stop(
                                                        )) : temp()
                video1.visible = checked ? true : false
                break
            case 2:
                break
            }
        }
    }

    MyButton {
        id: myButton
        width: 50
        height: 50
          antialiasing: true
        anchors.left: parent.left
        anchors.leftMargin: 143
        anchors.top: parent.top
        anchors.topMargin: 11
        myRadius: 0
        imgRes: "qrc:/Resource/icons/capture.svg"
        function getEnable() {
            switch (tabBar.currentIndex) {
            case 0:
                return camera.imageCapture.ready
            case 1:
                return CodeImage.isOpen
            case 2:
                return CodeImage.isOpen || camera.imageCapture.ready
            }
        }
        isEnable: getEnable()

        onMyButttonLeftclicked: {
            switch (tabBar.currentIndex) {
            case 0:
                camera.captureMode = Camera.CaptureStillImage
                camera.imageCapture.capture()

                break
            case 1:
                break
            case 2:
                break
            }
        }
    }

    MyButton {
        id: myButton1
        visible: false
        x: 231
        y: 11
        width: 50
        height: 50
        myRadius: 0
          antialiasing: true
        imgRes: "qrc:/Resource/icons/startrec.svg"
        function getEnable() {
            switch (tabBar.currentIndex) {
            case 0:
                return camera.videoRecorder.recorderStatus === CameraRecorder.LoadedStatus
            case 1:
                return CodeImage.isOpen
            case 2:
                return CodeImage.isOpen
                        || camera.videoRecorder.recorderStatus === CameraRecorder.LoadedStatus
            }
        }

        isEnable: getEnable()
        onMyButttonLeftclicked: {
            //console.log(camera.cameraStatus,camera.captureMode,camera.videoRecorder.errorString,Camera.CaptureVideo)
            if (image.visible === false) {
                camera.setCaptureMode(Camera.CaptureVideo)

                image.visible = true
                camera.videoRecorder.record()
                imgRes = "qrc:/Resource/icons/stoprec.svg"
            } else if (image.visible === true) {
                image.visible = false
                camera.videoRecorder.stop()
                imgRes = "qrc:/Resource/icons/startrec.svg"
            }
            //console.log(camera.captureMode,camera.videoRecorder.errorString,Camera.CaptureVideo)
        }
    }
}
