import QtQuick 2.0

Item {
    id: noTaskPlaceholder

    property int taskColumnIndex

    height: 100
    width: parent.width


    DropArea {
        id: taskDropArea

        property bool sourceAndTargetColumnsDifferent: true

        anchors.fill: parent
        width: parent.width

        onDropped: {
            var tmpData = visualModel.model
            tmpData[taskColumnIndex].tasks.splice(index+1, 0,tmpData[drag.source.taskColumnIndex].tasks[drag.source.taskIndex])
            tmpData[drag.source.taskColumnIndex].tasks.splice(drag.source.taskIndex, 1)
            //if no task anymore in the column, needs to create a placeholder
            if (tmpData[drag.source.taskColumnIndex].tasks.length === 0) {

            }
            visualModel.model = tmpData
        }


        Rectangle {
            id: taskRectangle

            width: parent.width
            height: 100

            border.width: 1
            border.color: "green"

            color: taskDropArea.containsDrag ? "lightsteelblue" : "grey"

            radius: 2

            Text {
                text: "Drop task here."
            }


        }
    }
}
