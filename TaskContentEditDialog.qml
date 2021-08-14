import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Popup {
    id: taskContentEditDialog

    property string taskTitle
    property string taskDescription


    signal pupilsDetailsAdded()

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 300
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    Column{
        height: parent.height

        width: parent.width

        Rectangle {
            id: titleTextInputRectangle

            width: parent.width
            height: 30
            border.color: "grey"
            border.width: 1

            TextInput {
                 id: titleTextInput

                 anchors.fill: parent
                 anchors.margins: 5
                 width: parent.width
                 focus: true
                 color: "black"
                 text: taskTitle
            }
        }


        Rectangle {
            id: descriptionTextEditRectangle

            width: parent.width
            height: descriptionTextEdit.contentHeight < 70 ? 70 : descriptionTextEdit.contentHeight
            border.color: "grey"
            border.width: 1

            TextEdit {
                id: descriptionTextEdit

                anchors.fill: parent
                focus: true
                wrapMode: TextEdit.Wrap

                color: "black"

                text: taskDescription
            }

        }

        Rectangle {
            id: okCancelRectangle

            width: parent.width
            height: 30

            Button {
                id: saveButton

                width: 100
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right

                palette {
                       button: "green"
                }

                text: qsTr("Save")
                onClicked: {
                    var tmpData = visualModel.model
                    console.log("tmpData[taskColumnIndex].tasks[taskIndex].description: " + tmpData[taskColumnIndex].tasks[taskIndex].description)
                    tmpData[taskColumnIndex].tasks[taskIndex].title = titleTextInput.text
                    tmpData[taskColumnIndex].tasks[taskIndex].description = descriptionTextEdit.text
                    console.log(visualModel.model)
                    visualModel.model = tmpData
                }
            }

            Button {
                id: cancelButton

                width: 100
                anchors.rightMargin: 5
                anchors.right: saveButton.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                text: qsTr("Cancel")

                onClicked: {
                   console.log("cancel...")
                   taskContentEditDialog.close();
                }
            }
        }
    }
}
