import QtQuick 2.9

Rectangle {
    id: root
    width: 200
    height: 60
    radius: 3
    property alias text: label.text
    property bool pressed: mousearea.pressed
    signal clicked()

    Text {
        id: label
        anchors.centerIn: parent
        text: qsTr("New")
        font.pixelSize: 20
        color: "white"
    }

    MouseArea {
        id: mousearea
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }
}
