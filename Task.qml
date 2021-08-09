import QtQuick 2.0

Item {
    id: taskItem

    property int taskColumnIndex
    property int taskIndex
    property int droppedColumnIndex
    property int droppedTaskIndex



    height: taskAndPlaceholderColumn.height
    width: parent.width

    DropArea {
        id: taskDropArea

        property bool sourceAndTargetColumnsDifferent: true

        anchors.fill: parent
        width: parent.width

        keys: "task"

        onEntered: {

            console.log("--- onEntered DropArea1")
            console.log("on entered source column: " + drag.source.taskColumnIndex)
            console.log("on entered source task index: " + drag.source.taskIndex)
            console.log("on entered current column: " + taskcolumnHeaderDragArea.taskColumnIndex)
            console.log("on entered current task index: " + taskcolumnHeaderDragArea.taskIndex)
            console.log("on entered droppedColumnIndex: " + taskItem.droppedColumnIndex)
            console.log("on entered droppedTaskIndex : " + taskItem.droppedTaskIndex)
            console.log("--- onEntered DropArea1")


            if (taskcolumnHeaderDragArea.taskColumnIndex === drag.source.taskColumnIndex) {
                visualModelTasksContent.items.move(
                        drag.source.taskIndex,
                        taskcolumnHeaderDragArea.taskIndex)

                sourceAndTargetColumnsDifferent = false

            } else {
                sourceAndTargetColumnsDifferent = true
                taskItem.droppedColumnIndex = taskcolumnHeaderDragArea.taskColumnIndex
                taskItem.droppedTaskIndex = taskcolumnHeaderDragArea.taskIndex


                console.log("")
                console.log("--- onEntered DropArea1 + source and target different")
                console.log("on entered source column: " + drag.source.taskColumnIndex)
                console.log("on entered source task index: " + drag.source.taskIndex)
                console.log("on entered current column: " + taskcolumnHeaderDragArea.taskColumnIndex)
                console.log("on entered current task index: " + taskcolumnHeaderDragArea.taskIndex)
                console.log("on entered droppedColumnIndex: " + taskItem.droppedColumnIndex)
                console.log("on entered droppedTaskIndex : " + taskItem.droppedTaskIndex)
                console.log("--- onEntered DropArea1 + source and target different")
            }
        }


        MouseArea {
            id: taskcolumnHeaderDragArea

            property bool heldTask: false
            property int taskColumnIndex: taskItem.taskColumnIndex
            property int taskIndex: taskItem.taskIndex

            anchors.fill: parent
            width: parent.width

           // drag.target: heldTask ? taskAndPlaceholderColumn : undefined
            drag.target: taskAndPlaceholderColumn
            //drag.axis: Drag.YAxis

            onPressAndHold: {
                heldTask = true
                console.log("tt")
            }

            onReleased: {
                parent = taskAndPlaceholderColumn.Drag.target !== null ? taskAndPlaceholderColumn.Drag.target : taskItem
                heldTask = false
                console.log("drop signal")
                taskAndPlaceholderColumn.Drag.drop()
                taskAndPlaceholderColumn.parent = taskItem
                taskAndPlaceholderColumn.x = 0
                taskAndPlaceholderColumn.y = 0
            }


            Column {
                id: taskAndPlaceholderColumn

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

                    width: taskcolumnHeaderDragArea.width; //height: column.implicitHeight + 4
                    height: 100

                    border.width: 1
                    border.color: "green"

                    color: taskcolumnHeaderDragArea.held ? "lightsteelblue" : "white"
                    Behavior on color { ColorAnimation { duration: 100 } }

                    radius: 2

                    Column {
                        id: column
                        anchors { fill: parent; margins: 2 }

                        Text { text: 'title: ' + modelData.title + "##" + taskcolumnHeaderDragArea.taskColumnIndex}
                        Text { text: 'description: ' + modelData.description }
                    }
                }

                Rectangle {
                    id: bottomPlaceHolder

                    visible: taskDropArea.containsDrag && taskDropArea.sourceAndTargetColumnsDifferent //false// taskItemDropArea.containsDrag// && taskItemDropArea.sourceTaskAndTaskInDifferentColumns
                    width: parent.width
                    height: 100
                    color: !taskDropArea.containsDrag ? "grey" : "green"

                    Text {
                        anchors.fill: parent
                        text: "bottom placeholder"
                    }


                    DropArea {
                        id: bottomPlaceHolderDropArea

                        anchors.fill: parent

                        onDropped: {


                            console.log("--- onDropped droparea2")
                            console.log("on entered source column: " + drag.source.taskColumnIndex)
                            console.log("on entered source task index: " + drag.source.taskIndex)
                            console.log("on entered current column: " + taskcolumnHeaderDragArea.taskColumnIndex)
                            console.log("on entered current task index: " + taskcolumnHeaderDragArea.taskIndex)
                            console.log("on entered droppedColumnIndex: " + taskItem.droppedColumnIndex)
                            console.log("on entered droppedTaskIndex : " + taskItem.droppedTaskIndex)
                            console.log("--- onDropped droparea2")


                            var tmpData = visualModel.model
                            tmpData[taskColumnIndex].tasks.splice(index+1, 0,tmpData[drag.source.taskColumnIndex].tasks[drag.source.taskIndex])
                            tmpData[drag.source.taskColumnIndex].tasks.splice(drag.source.taskIndex, 1)
                            visualModel.model = tmpData

                            console.log("ddd:" + tmpData[0].headertitle)
                            console.log(drag.source.taskColumnIndex)
                            console.log(drag.source.taskIndex)


                        }
                    }
                }
            }
        }
    }
}




//            onDropped: {

//                console.log("")
//                console.log("--- xxxxx")
//                console.log("on dropped source column: " + drag.source.taskColumnIndex)
//                console.log("on dropped source task index: " + drag.source.taskIndex)
//                console.log("on dropped current column: " + parent.taskColumnIndex)
//                console.log("on dropped current task index: " + taskcolumnHeaderDragArea.taskIndex)
//                console.log("on dropped current column memo: " + taskItem.taskColumnIndex)
//                console.log("on dropped current task index memo: " + taskItem.taskIndex)
//                console.log("--- xxxxx")
//                console.log("")


////                console.log("visual model")
////                var tmpData = visualModel.model
////                console.log(JSON.stringify(visualModel.model))

////                console.log("\nSource data")
////                console.log("\nAll data")
////                console.log("JSON.stringify(tmpData[drag.source.taskColumnIndex]")
////                console.log(JSON.stringify(tmpData[drag.source.taskColumnIndex]))
////                console.log("\nTask moved")
////                console.log("JSON.stringify(tmpData[drag.source.taskColumnIndex].tasks[drag.source.taskIndex]")
////                console.log(JSON.stringify(tmpData[drag.source.taskColumnIndex].tasks[drag.source.taskIndex]))
////                console.log("\nColumn index to insert")
////                console.log(taskcolumnHeaderDragArea.taskColumnIndex)

////                tmpData[taskcolumnHeaderDragArea.taskColumnIndex].tasks.splice(1 + taskcolumnHeaderDragArea.taskIndex, 0,tmpData[drag.source.taskColumnIndex].tasks[drag.source.taskIndex])
////                console.log("taskcolumnHeaderDragArea.taskIndex+1: ")
////                console.log(taskcolumnHeaderDragArea.taskIndex+1)


////                console.log("insert: ")
////                console.log(JSON.stringify(tmpData[drag.source.taskColumnIndex].tasks[drag.source.taskIndex]))


////                console.log(JSON.stringify(visualModel.model))


////                //tmpData[drag.source.taskColumnIndex].tasks.splice(drag.source.taskIndex, 1)
////                visualModel.model = tmpData

////                console.log("xxx xxxx")
////                console.log("xxx xxxx")
////                console.log(JSON.stringify(tmpData))

//            }
