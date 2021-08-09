import QtQuick 2.12
import QtQuick.Window 2.12
import QtQml.Models 2.1
import gcompris_tasks 1.0


Window {
    id: applicationWindow
    visible: true
    width: 910
    height: 480
    title: qsTr("Hello World")

    Component.onCompleted: {
       applicationWindow.readDocument(":/Data.json")
    }

    Rectangle {
        id: root

        anchors.fill: parent

        property int taskWidth: 300

        DelegateModel {
            id: visualModel

            delegate: TaskColumn{
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


    FileIO {
        id: io
    }

    function readDocument(url) {
        io.source = url

        console.log("io.source: " + io.source)

        io.read()
        console.log("io.text: " + io.text)
        //taskBoard.taskBoardData = JSON.parse(io.text)
        visualModel.model = JSON.parse(io.text)

        //console.log(JSON.stringify(taskBoard.taskBoardData, null, 4))

    }
}
