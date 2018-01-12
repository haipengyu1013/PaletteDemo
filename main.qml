import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    visible: true
    width: 1200
    height: 800
    title: qsTr("Hello World")

    Item {
        anchors.fill: parent
        Column {
            spacing: 10
            anchors.verticalCenter: parent.verticalCenter
            x: 10
            HButton {
                text :qsTr("New")
                color: pressed ? "#00ffff" : "#00a6ff"
                onClicked: {
                    palette.clear()
                    palette.state = "show"
                    palette.drawType = 0
                }
            }

            HButton {
                text :qsTr("Save")
                color: pressed ? "#00ffff" : "#00a6ff"

                onClicked: {
                    palette.saveImage("test.png")
                    curImage.source = ""
                    curImage.source = "file:test.png"
                }
            }

            HButton {
                text :qsTr("Clear")
                color: pressed ? "#00ffff" : "#00a6ff"

                onClicked: {
                    palette.clear()
                }
            }

            HButton {
                text :qsTr("Draw")
                color: (palette.drawType == 0 || pressed ) ? "#00ffff" : "#00a6ff"
                onClicked: {
                    palette.drawType = 0
                }
            }


            HButton {
                text :qsTr("Eraser")
                color: (palette.drawType == 1 || pressed )? "#00ffff" : "#00a6ff"

                onClicked: {
                    palette.drawType = 1
                }
            }

            HButton {
                text :qsTr("LineWidth: ") + ((palette.customlineType + 1) * 6).toString()
                color: pressed ? "#00ffff" : "#00a6ff"

                Rectangle{
                    anchors.centerIn: parent
                    width: (palette.customlineType + 1) * 6
                    height: 50
                    color: "white"
                    opacity: 0.4
                }

                onClicked: {
                    if( palette.customlineType  == 3)
                        palette.customlineType = 0
                    else
                        palette.customlineType ++
                }


            }

            Rectangle {
                width: 200
                height: 200
                border.width: 2
                border.color: "black"
                color: "black"



                Image {
                    id: curImage
                    cache: false
                    anchors.fill: parent
                    source: "file:test.png"
                }

                Text {
                    width: 200
                    height: 20
                    y: 200
                    color: "black"
                    text: "double click to modify this image"
                }

                MouseArea {
                    anchors.fill: parent
                    onDoubleClicked: {
                        palette.clear()
                        palette.state = "show"
                        palette.drawType = 0
                        palette.loadCustomImage("test.png")
                    }
                }
            }

        }



        Palette {
            id: palette
            customlineType: 0
            drawType: 0
            customColor: "yellow"
            x: 250
            anchors.verticalCenter: parent.verticalCenter
            width: 950
            height: 800
        }
    }
}

