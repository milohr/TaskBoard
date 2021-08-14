import QtQuick 2.12
import QtQuick.Window 2.12
import QtQml.Models 2.1
import gcompris_tasks 1.0


Window {
    id: applicationWindow
    visible: true
    width: 1000
    height: 600
    title: qsTr("Hello World")

    Component.onCompleted: {
       applicationWindow.readDocument(":/Data.json")
    }

    Rectangle {
        id: root

        anchors.top: parent.top
        anchors.left: parent.left
        width: 800
        height: parent.height


        property int taskWidth: 200

        DelegateModel {
            id: visualModel

            delegate: TaskColumn {
                taskColumnIndex: DelegateModel.itemsIndex
            }
        }

        ListView {
            id: view

            anchors { fill: parent; margins: 2 }
            model: visualModel
            spacing: 4
            cacheBuffer: 50
            orientation: ListView.Horizontal
        }
    }


    //upfront insert task button
    Rectangle {
        id: insertColumnRectangle

        anchors.top: parent.top
        anchors.left: root.right

        width: 50
        height: 50  //! at the moment but must be relative later on
        color: "lightsteelblue"

        Text {
            id: insertUpFrontText

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("+")
            color: "red"
        }

        MouseArea {
            id: upFrontAddTaskButton

            anchors.fill: parent
            onClicked: {
                console.log("Insert a new column")
                var data = visualModel.model
                data.push({"headertitle": "Header Title n", "tasks": []})
                visualModel.model = data
            }
        }
    }


    FileIO {
        id: io
    }

    function readDocument(url) {
        io.source = url

        console.log("io.source: " + io.source)

        io.read()
        console.log("io.text: " + io.text)
        visualModel.model = JSON.parse(io.text)

        console.log("tttttttttt")
        console.log(JSON.stringify(visualModel.model))

    }
}
