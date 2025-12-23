import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

ApplicationWindow {
    width: 600
    height: 400
    visible: true
    title: "Hello World"

    Rectangle {
        anchors.centerIn: parent
        width: 300
        height: 100
        color: "green"
    }
}
