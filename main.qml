import QtQuick 2.12
import QtQuick.Window 2.12
import QtQml.Models 2.1
import gcompris_tasks 1.0

import "data.js" as Activity

Window {
    id: applicationWindow
    visible: true
    width: 910
    height: 480
    title: qsTr("Hello World")

//    property url defaultJsonFile: ":/Data.json"



    Component.onCompleted: {

       applicationWindow.readDocument(":/Data.json")

    }

    Rectangle {
        id: root

        anchors.fill: parent

        property int taskWidth: 300

        Component {
            id: columnDelegate


            Item {
                id: columnDragDelegateItem

                property int taskColumnIndex: DelegateModel.itemsIndex

                height: columnHeaderDragArea.height
                width: root.taskWidth

                Item {
                    id: taskColumn

                    height: 200
                    width: parent.width


                    MouseArea {
                        id: columnHeaderDragArea

                        property bool held: false

                        height: taskColumnHeader.height
                        width: root.taskWidth

                        property int taskColumnIndex: columnDragDelegateItem.taskColumnIndex

                        drag.target: held ? taskColumnHeader : undefined
                        drag.axis: Drag.XAxis

                        onPressAndHold: held = true
                        onReleased: held = false

                        Rectangle {
                            id: taskColumnHeader

                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                            }

                            width: root.taskWidth; height: column.implicitHeight + 4

                            Text {
                                anchors.left: parent.left
                                anchors.top: parent.top

                                height: taskColumnHeader.height
                                width: parent.width

                                color: "green"

                                text: taskColumnIndex
                            }


                            border.width: 1
                            border.color: "lightsteelblue"

                            color: columnHeaderDragArea.held ? "lightsteelblue" : "white"
                            Behavior on color { ColorAnimation { duration: 100 } }

                            radius: 2

                            Drag.keys: "columnHeader"
                            Drag.active: columnHeaderDragArea.held
                            Drag.source: columnHeaderDragArea
                            Drag.hotSpot.x: width / 2
                            Drag.hotSpot.y: height / 2

                            states: State {
                                when: columnHeaderDragArea.held

                                ParentChange { target: taskColumnHeader; parent: root }
                                AnchorChanges {
                                    target: taskColumnHeader
                                    anchors { horizontalCenter: undefined; verticalCenter: undefined }
                                }
                            }

                            Column {
                                id: column
                                anchors { fill: parent; margins: 2 }

                                Text { text: 'headertitle: ' + modelData.headertitle }
                                Text { text: 'description: ' + modelData.description }
//                                Text { text: 'Age: ' + age }
//                                Text { text: 'Size: ' + size }
                            }
                        }

                        DropArea {
                            anchors.fill: parent

                            keys: "columnHeader"

                            onEntered: {
                                console.log("drag.source.parent.DelegateModel.itemsIndex: " + drag.source)
                                console.log("drag.source.parent.DelegateModel.itemsIndex: " + drag.source.taskColumnIndex)
                                console.log("taskColumn.DelegateModel.itemsIndex: " + columnHeaderDragArea.taskColumnIndex)

                                visualModel.items.move(
                                        drag.source.taskColumnIndex,
                                        columnHeaderDragArea.taskColumnIndex)
                            }
                        }

                    }

//                    DropArea {
//                        id: taskDropArea

//                        property bool sourceAndTargetColumnsDifferent: true

//                        anchors { fill: parent; margins: 10 }

//                        onDropped: {
//                            console.log("tttttttttttttttttttttt")
//                        }

//                        onEntered: {
//                            console.log("drag.source.taskColumnIndex: " + drag.source.taskColumnIndex)
//                            console.log("taskcolumnHeaderDragArea.taskColumnIndex: " + taskcolumnHeaderDragArea.taskColumnIndex)

//                            console.log("drag.source.DelegateModel.itemsIndex: " + drag.source.DelegateModel.itemsIndex)
//                            console.log("taskcolumnHeaderDragArea.DelegateModel.itemsIndex: " + taskcolumnHeaderDragArea.DelegateModel.itemsIndex)

//                            if (taskcolumnHeaderDragArea.taskColumnIndex === drag.source.taskColumnIndex) {
//                                visualModelTaskContent.items.move(
//                                        drag.source.DelegateModel.itemsIndex,
//                                        taskcolumnHeaderDragArea.DelegateModel.itemsIndex)

//                                taskDropArea.sourceAndTargetColumnsDifferent = false

//                            } else {
//                                taskDropArea.sourceAndTargetColumnsDifferent = true
//                            }
//                        }
//                    }

                    Rectangle {
                        id: tasks

                        anchors.top: columnHeaderDragArea.bottom
                        anchors.left: columnHeaderDragArea.left

                        width: root.taskWidth
                        height: 300

                        color: "red"

                        states: State {
                            when: columnHeaderDragArea.held

                            ParentChange { target: tasks; parent: root; x: taskColumnHeader.x }
                            AnchorChanges {
                                target: tasks
                                anchors { horizontalCenter: undefined; verticalCenter: undefined }
                            }
                        }


                        DelegateModel {
                            id: visualModelTasksContent

                            property int taskColumnIndex: index

                            model: modelData.tasks
                            delegate: taskDelegate
                        }

                        ListView {
                            id: view

                            anchors { fill: parent; margins: 2 }
                            model: visualModelTasksContent
                            spacing: 4
                            cacheBuffer: 50
                        }

                        Component {
                            id: taskDelegate

                            Item {
                                id: taskDelegateItem

                                property int taskColumnIndex: visualModelTasksContent.taskColumnIndex
                                property int taskIndex: DelegateModel.itemsIndex

                                height: taskcolumnHeaderDragArea.height
                                width: root.taskWidth

                                MouseArea {
                                    id: taskcolumnHeaderDragArea

                                    property bool heldTask: false
                                    property int taskColumnIndex: taskDelegateItem.taskColumnIndex
                                    property int taskIndex: taskDelegateItem.taskIndex

                                    anchors { left: parent.left; right: parent.right }
                                    height: taskAndPlaceholderColumn.height

                                   // drag.target: heldTask ? taskAndPlaceholderColumn : undefined
                                    drag.target: taskAndPlaceholderColumn
                                    //drag.axis: Drag.YAxis

                                    onPressAndHold: {
                                        heldTask = true
                                        console.log("tt")
                                    }

                                    onReleased: {
                                        heldTask = false
                                        console.log("drop signal")
                                        taskAndPlaceholderColumn.Drag.drop()
                                    }



                                    Column {
                                        id: taskAndPlaceholderColumn

                                        anchors {
                                            horizontalCenter: parent.horizontalCenter
                                            verticalCenter: parent.verticalCenter
                                        }

                                        Drag.keys: "task"
                                        Drag.active: taskcolumnHeaderDragArea.drag.active
                                        Drag.source: taskcolumnHeaderDragArea
                                        Drag.hotSpot.x: width / 2
                                        Drag.hotSpot.y: height / 2

                                        states: State {
                                            when: taskcolumnHeaderDragArea.heldTask

                                            ParentChange { target: taskAndPlaceholderColumn; parent: root }
                                            AnchorChanges {
                                                target: taskAndPlaceholderColumn
                                                anchors { horizontalCenter: undefined; verticalCenter: undefined }
                                            }
                                        }


                                        Rectangle {
                                            id: taskRectangle

                                            width: taskcolumnHeaderDragArea.width; height: column.implicitHeight + 4

                                            border.width: 1
                                            border.color: "green"

                                            color: taskcolumnHeaderDragArea.held ? "lightsteelblue" : "white"
                                            Behavior on color { ColorAnimation { duration: 100 } }

                                            radius: 2

                                            Column {
                                                id: column
                                                anchors { fill: parent; margins: 2 }

                                                Text { text: 'title: ' + modelData.title }
                                                Text { text: 'description: ' + modelData.description }
                                            }
                                        }

                                        Rectangle {
                                            id: bottomPlaceHolder

                                            visible: bottomPlaceHolderDropArea.containsDrag && bottomPlaceHolderDropArea.sourceAndTargetColumnsDifferent //false// taskItemDropArea.containsDrag// && taskItemDropArea.sourceTaskAndTaskInDifferentColumns
                                            width: parent.width
                                            height: 100
                                            color: !bottomPlaceHolderDropArea.containsDrag ? "grey" : "green"

                                            Text {
                                                anchors.fill: parent
                                                text: "bottom placeholder"
                                            }
                                        }
                                    }

                                    DropArea {
                                        id: bottomPlaceHolderDropArea

                                        property bool sourceAndTargetColumnsDifferent: true
                                        property int droppedColumnIndex
                                        property int droppedTaskIndex

                                        anchors.fill: taskAndPlaceholderColumn

                                        keys: "task"

                                        onEntered: {



                                            if (taskcolumnHeaderDragArea.taskColumnIndex === drag.source.taskColumnIndex) {
                                                visualModelTasksContent.items.move(
                                                        drag.source.taskIndex,
                                                        taskcolumnHeaderDragArea.taskIndex)

                                                sourceAndTargetColumnsDifferent = false
                                            } else {
                                                sourceAndTargetColumnsDifferent = true


                                                console.log("")
                                                console.log("--- yyyy")
                                                console.log("on entered source column: " + drag.source.taskColumnIndex)
                                                console.log("on entered source task index: " + drag.source.taskIndex)
                                                console.log("on entered current column: " + taskcolumnHeaderDragArea.taskColumnIndex)
                                                console.log("on entered current task index: " + taskcolumnHeaderDragArea.taskIndex)
                                                console.log("--- yyyy")
                                                console.log("")
                                                droppedColumnIndex = taskcolumnHeaderDragArea.taskColumnIndex
                                                droppedTaskIndex = taskcolumnHeaderDragArea.taskIndex



                                            }
                                        }


    //                                    onContainsDragChanged: {
    //                                         console.log("contains drag changed")

    //                                    }

                                        onDropped: {

                                            console.log("")
                                            console.log("--- xxxxx")
                                            console.log("on dropped source column: " + drag.source.taskColumnIndex)
                                            console.log("on dropped source task index: " + drag.source.taskIndex)
//                                            console.log("on dropped current column: " + taskcolumnHeaderDragArea.taskColumnIndex)
//                                            console.log("on dropped current task index: " + taskcolumnHeaderDragArea.taskIndex)
                                            console.log("on dropped current column: " + droppedColumnIndex)
                                            console.log("on dropped current task index: " + droppedTaskIndex)




                                            console.log("--- xxxxx")
                                            console.log("")

                                            //if (1) //taskcolumnHeaderDragArea.taskColumnIndex !== drag.source.taskColumnIndex) {


                                                console.log("visual model")
                                                var tmpData = visualModel.model
                                                console.log(JSON.stringify(visualModel.model))

                                                console.log("JSON.stringify(tmpData[drag.source.taskColumnIndex]")
                                                console.log(JSON.stringify(tmpData[drag.source.taskColumnIndex]))

                                                console.log("JSON.stringify(tmpData[drag.source.taskColumnIndex].tasks[drag.source.taskIndex]")
                                                console.log(JSON.stringify(tmpData[drag.source.taskColumnIndex].tasks[drag.source.taskIndex]))


                                                tmpData[taskcolumnHeaderDragArea.taskColumnIndex].tasks.splice(1 + taskcolumnHeaderDragArea.taskIndex, 0,tmpData[drag.source.taskColumnIndex].tasks[drag.source.taskIndex])
                                                console.log("taskcolumnHeaderDragArea.taskIndex+1: ")
                                                console.log(taskcolumnHeaderDragArea.taskIndex+1)


                                                console.log("insert: ")
                                                console.log(JSON.stringify(tmpData[drag.source.taskColumnIndex].tasks[drag.source.taskIndex]))


                                                console.log(JSON.stringify(visualModel.model))


                                                //tmpData[drag.source.taskColumnIndex].tasks.splice(drag.source.taskIndex, 1)
                                                visualModel.model = tmpData

                                                console.log("xxx xxxx")
                                                console.log("xxx xxxx")
                                                console.log(JSON.stringify(tmpData))

                                           // }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        DelegateModel {
            id: visualModel

            delegate: columnDelegate
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
