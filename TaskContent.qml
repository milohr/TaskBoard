import QtQuick 2.12

Item {
    id: taskContent

    property bool taskTitleTextEditEnabled: false
    property bool taskDescriptionTextEditEnabled: false
    property string taskTitle
    property string taskDescription

    width: parent.width
    anchors.top: parent.top
    anchors.left: parent.left

    Column {
        id: taskContentColumn

        property bool enableTextEdit

        //    property var computedTaskHeight: actionsRectangle.height + taskTitleTextEdit.height + taskDescriptionTextEdit.height + 15   //? why +15 no idea :( but otherwise the taskDescriptionTextEdit is not taken into account
        property var computedTaskHeight: actionsRectangle.height + taskTitleTextEdit.height + taskDescriptionTextEdit.height + 15   //? why +15 no idea :( but otherwise the taskDescriptionTextEdit is not taken into account

        width: parent.width
        spacing: 4

        anchors.top: parent.top
        anchors.left: parent.left

        Rectangle {
            id: actionsRectangle

            width: parent.width
            height: 20
            color: "#e75858"
            radius: 3

            MouseArea {
                id: editTitleMouseArea
                width: 30
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.right: parent.right

                Text {
                    id: editTextSymbol
                    text: qsTr("Edit")
                    font.pixelSize: 12
                }
            }

            MouseArea {
                id: removeTaskMouseArea
                width: 30
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 30
                anchors.right: editTitleMouseArea.left

                Text {
                    id: removeTextSymbol
                    text: qsTr("Remove")
                    font.pixelSize: 12
                }

                onClicked: {
                    var tmpData = visualModel.model
                    tmpData[taskColumnIndex].tasks.splice(taskIndex,1)
                    visualModel.model = tmpData
                }

            }

            MouseArea {
                id: optionsMouseArea
                width: 30
                height: 20
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 30
                anchors.right: removeTaskMouseArea.left


                Text {
                    id: optionsTextSymbol
                    text: qsTr("Options")
                    font.pixelSize: 12
                }
            }
        }


        Rectangle {

            width: parent.width
            height: 30

            color: "green"



            TextEdit {
                id: taskTitleTextEdit

                anchors.fill: parent

                wrapMode: TextEdit.Wrap
                font.pointSize: 10
                text: taskTitle
              //  activeFocusOnPress: false
              //  color: "green"
                enabled: taskTitleTextEditEnabled

    //            onEditingFinished : {
    //                console.log("taskTitleTextEdit.text: " + taskTitleTextEdit.text)

    //                var tmpData = visualModel.model
    //                console.log("tmpData[taskColumnIndex].tasks[taskIndex].title: " + tmpData[taskColumnIndex].tasks[taskIndex].title)
    //                tmpData[taskColumnIndex].tasks[taskIndex].title = taskTitleTextEdit.text
    //                visualModel.model = tmpData
    //            }

            }

        }

        TextEdit {
            id: taskDescriptionTextEdit

            width: parent.width
            height: 80
            wrapMode: TextEdit.Wrap
            font.pointSize: 9
            text: taskContent.taskDescription
            enabled: taskDescriptionTextEditEnabled



            onEditingFinished : {
                var tmpData = visualModel.model
                console.log("tmpData[taskColumnIndex].tasks[taskIndex].description: " + tmpData[taskColumnIndex].tasks[taskIndex].description)
                tmpData[taskColumnIndex].tasks[taskIndex].description = taskDescriptionTextEdit.text
                visualModel.model = tmpData
            }
        }
    }

}


