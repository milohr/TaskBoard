import QtQuick 2.0
import QtQml.Models 2.1

Item {
    id: columnTaskItem

    property int taskColumnIndex

    height: columnHeaderDragArea.height
    width: root.taskWidth

    Item {
        id: taskColumn

        height: 200
        width: parent.width


        MouseArea {
            id: columnHeaderDragArea

            property int taskColumnIndex: columnTaskItem.taskColumnIndex
            property bool held: false

            height: taskColumnHeader.height
            width: root.taskWidth

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
                    console.log("drag.source.taskColumnIndex: " + drag.source.taskColumnIndex)
                    console.log("columnHeaderDragArea.taskColumnIndex: " + columnHeaderDragArea.taskColumnIndex)

                    visualModel.model.move(
                            drag.source.taskColumnIndex,
                            columnHeaderDragArea.taskColumnIndex)
                }
            }
        }



        Rectangle {
            id: tasks

            anchors.top: columnHeaderDragArea.bottom
            anchors.left: columnHeaderDragArea.left

            width: root.taskWidth
            height: 600

            color: "red"

            states: State {
                when: columnHeaderDragArea.held

                ParentChange { target: tasks; parent: root; x: taskColumnHeader.x }
                AnchorChanges {
                    target: tasks
                    anchors { horizontalCenter: undefined; verticalCenter: undefined }
                }
            }



            //upfront insert task button
            Rectangle {
                id: insertTaskUpFrontRectangle

                anchors.top: parent.top
                anchors.left: parent.left

                width: parent.width
                height: 50
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
                        var tmpData = visualModel.model
                        tmpData[taskColumnIndex].tasks.splice(0,0,{"description": "task number: 0", "color":"red", "title": "Task title"})
                        visualModel.model = tmpData
                    }
                }
            }


            Column {

                anchors.top: insertTaskUpFrontRectangle.bottom
                anchors.left: insertTaskUpFrontRectangle.left
                width: parent.width
                height: 500  //!to be improved

                NoTaskPlaceholder {
                    id: noTaskPlaceholder

                    taskColumnIndex: columnTaskItem.taskColumnIndex
                    visible: modelData.tasks.length === 0
                }


                DelegateModel {
                    id: visualModelTasksContent

                    model: modelData.tasks
                    delegate: Task{
                        taskColumnIndex: columnTaskItem.taskColumnIndex
                        taskIndex: DelegateModel.itemsIndex
                    }
                }

                ListView {
                    id: view

                    //anchors { fill: parent; margins: 2 }

                    model: visualModelTasksContent
                    spacing: 4
                    cacheBuffer: 50
                    height: tasks.height - noTaskPlaceholder.height
                    width: tasks.width
                }

            }
        }
    }
}




