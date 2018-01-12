/****************************************************************************
**
** This file is part of the KKUI Controls module
**
**
** HPalette
**
** to draw pictures
****************************************************************************/

import QtQuick 2.9

Rectangle{
    id:  root
    width: 727
    height: 360
    color: "#505050"
    opacity: 0
    visible: false

    property color customColor: "red"
    property int customlineType: 0 // 0: 6 , 1 : 12 , 2: 28, 3: 24
    property int drawType: 0 // 0: draw 1 : eraser
    property bool bisDrawImage: false
    property string curImagePath: ""
    //    property alias canvas: canvas

    readonly property double lineWidth: drawType == 0 ? penSize[customlineType] : eraserSize[customlineType]
    readonly property var eraserSize: [6 , 12 , 18 , 24]
    readonly property var penSize: [6 , 12 , 18 , 24]
    readonly property color paintColor: drawType == 0 ? customColor : "transparent"

    property var curCtx

    function saveImage(imgName)
    {
        return canvas.save(imgName)
    }

    function clear()
    {
        curCtx.clearRect(0 , 0 , canvas.width , canvas.height)
        canvas.requestPaint()
    }

    function loadCustomImage(filePath){
        print("loadCustomImage is " + filePath)

        curImagePath =  "file:"+ filePath //pay attention pls!  need add file:    !!!
        canvas.loadImage(curImagePath)
        canvas.imageLoaded.connect(loadCurImage)
    }

    function loadCurImage() {
        print("loadCurImage is ")

        bisDrawImage = true
        canvas.requestPaint()
    }

    //画板
    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        onAvailableChanged: {
            if(available){
                curCtx =  canvas.getContext('2d')
            }
        }


        property real lastX
        property real lastY

        onPaint: {
            if(bisDrawImage) {
                print("curImagePath is " + curImagePath)
                curCtx.drawImage(curImagePath , 0 , 0)
                bisDrawImage = false
                canvas.unloadImage(curImagePath)
                curImagePath = ""
            }

            if(mouseArea.pressed) {
                if(drawType != 0)
                    curCtx.globalCompositeOperation = "source-out"
                else
                    curCtx.globalCompositeOperation = "source-over"

                curCtx.lineWidth = lineWidth
                curCtx.strokeStyle = paintColor
                curCtx.beginPath()
                curCtx.moveTo(lastX, lastY)
                lastX = mouseArea.mouseX
                lastY = mouseArea.mouseY
                curCtx.lineTo(lastX, lastY)
                curCtx.stroke()
                curCtx.closePath()
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onPressed: {
                print("onPressed")
                canvas.lastX = mouseX
                canvas.lastY = mouseY
            }

            onPositionChanged: {
                if(mouseX > root.width || mouseY > root.height)
                    return
                if(mouseArea.pressed){
                    canvas.requestPaint()
                }
            }


            cursorShape: {
                if(containsMouse)
                    if(drawType == 1)
                        return Qt.BlankCursor
                    else{
                        if(pressed)
                            return Qt.CrossCursor
                        else
                            return Qt.ArrowCursor
                    }
                else
                    return Qt.ArrowCursor
            }
        }
    }

    Rectangle {
        id: eraser
        width: eraserSize[customlineType]
        height: eraserSize[customlineType]
        border.width: 3
        border.color: "black"
        x: mouseArea.mouseX - eraserSize[customlineType] / 2
        y: mouseArea.mouseY - eraserSize[customlineType] / 2
        visible: drawType == 1 && mouseArea.containsMouse
    }

    Rectangle {
        id: pen
        width:  penSize[customlineType]
        height:  penSize[customlineType]
        border.width: 1
        border.color: "black"
        color: "transparent"
        radius: penSize[customlineType] / 2
        x: mouseArea.mouseX - penSize[customlineType] / 2
        y: mouseArea.mouseY - penSize[customlineType] / 2
        visible: drawType == 0 && mouseArea.containsMouse
    }

    states: [
        State {
            name: "show"
            PropertyChanges {
                target: root
                opacity: 1
            }
        }
    ]

    transitions: [
        Transition {
            from: "show"
            to: ""
            SequentialAnimation {
                ScriptAction {
                    script: {
                        root.visible = false
                    }
                }
            }
        },
        Transition {
            from: ""
            to: "show"
            SequentialAnimation {
                ScriptAction {
                    script: {
                        root.visible = true
                    }
                }
                OpacityAnimator {duration: 200}
            }
        }
    ]
}
