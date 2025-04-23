import QtQuick 2.15
import QtQuick.Controls 6.8
import QtQuick.Controls.Material 6.8
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: window
    width: 1200; height: 600
    visible: true
    title: qsTr("Lab9 — Классы и данные")

    property bool showAddForm: false

    ColumnLayout { anchors.fill: parent; spacing: 10
        // Панель управления
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            Button {
                id: constructorButton
                text: "Конструктор"
                checkable: true
                onClicked: showAddForm = checked
            }
        }

        // Контейнер, в котором по булеву флажку чередуем виджеты
        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: showAddForm ? addFormComponent : gridComponent
        }

        Component { id: addFormComponent
            AddStudentForm {
                id: addForm
                onStudentAdded: {
                    showAddForm = false
                }
            }
        }
        Component { id: gridComponent
            StudentGridView {
                id: studentView
                onAddStudentRequested: {
                    showAddForm = true
                    constructorButton.checked = true
                }
            }
        }
    }
}
