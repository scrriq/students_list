import QtQuick 2.15
import QtQuick.Controls 6.8
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 6.8

Rectangle {
    anchors.fill: parent
    color: "transparent"
    signal addStudentRequested

    property bool acquaintanceView: backend.model ? backend.model.acquaintanceView : false

    Connections {
        target: backend.model
        function onAcquaintanceViewChanged() {
            acquaintanceView = backend.model.acquaintanceView
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 10
        anchors {
            top:    parent.top
            left:   parent.left
            right:  parent.right
            margins: 16    // отступ со всех сторон
        }

        Frame {
            id: item
            Layout.preferredWidth: parent.width * 0.7
            Layout.fillHeight: true
            background: Rectangle {
                border.width:3 ; border.color: "gray"
                color: "white"
            }
            padding: 3
            topPadding: 3
            bottomPadding: 3
            property bool acquaintanceView: backend.model.acquaintanceView
            // Заголовки — теперь RowLayout
            RowLayout {
                id: headerRow
                height: 40
                width: parent.width
                spacing: 10
                Layout.leftMargin: 4

                // фон под всеми колонками
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#DDDDDD"
                    border.width: 1
                    border.color: "#CCCCCC"
                    z: -1
                }

                Text {
                    text: "Фамилия"
                    Layout.preferredWidth: 100 + acquaintanceView * 40
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    text: "Имя"
                    Layout.preferredWidth: 100 + acquaintanceView * 35
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    text: "Отчество"
                    Layout.preferredWidth: 120 + acquaintanceView * 55
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    text: "Дата рождения"
                    Layout.preferredWidth: 120
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    visible: !acquaintanceView
                }
                Text {
                    text: "Рост (м)"
                    Layout.preferredWidth: 80
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    visible: !acquaintanceView
                }
                Text {
                    text: "Город"
                    Layout.preferredWidth: 140 + acquaintanceView * 50
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                }
                Text {
                    text: "Возраст"
                    Layout.preferredWidth: 80 + acquaintanceView * 50
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // Список с прокруткой
            ListView {
                id: listView
                anchors {
                    top: headerRow.bottom
                    left: parent.left; right: parent.right; bottom: parent.bottom
                }
                model: backend.model
                clip: true
                interactive: true

                delegate: Rectangle {
                    width: listView.width
                    height: 40
                    border.width: 1
                    border.color: "#CCCCCC"
                    color: listView.currentIndex === index
                          ? "#D6EAF8"
                          : index % 2 === 0
                            ? "#FFFFFF"
                            : "#F7F9F9"

                    RowLayout {
                        anchors.fill: parent
                        spacing: 10
                        anchors {
                            left:   parent.left
                            margins: 8
                        }

                        Text {
                            text: surname
                            Layout.preferredWidth: 100
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            text: name
                            Layout.preferredWidth: 100
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            text: patronymic
                            Layout.preferredWidth: 120
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            text: Qt.formatDate(birthDate, "d MMMM yyyy")
                            Layout.preferredWidth: 120
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            visible: !acquaintanceView
                        }
                        Text {
                            text: studentHeight.toFixed(2)
                            Layout.preferredWidth: 80
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            visible: !acquaintanceView
                        }
                        Text {
                            text: city
                            Layout.preferredWidth: 140
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            text: age.toString()
                            Layout.preferredWidth: 80
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: listView.currentIndex = index
                    }
                }
            }
        }

        ColumnLayout {
            Layout.preferredWidth: parent.width * 0.3
            Layout.fillHeight: true
            spacing: 10

            Button { text: "Добавить студента";onClicked: addStudentRequested(); }
            Button { text: "Сброс";                onClicked: backend.model.reset() }
            Button { text: "Москва";              onClicked: backend.model.filterCity("Москва") }
            Button { text: "Взрослые 18+";         onClicked: backend.model.filterAdults() }

            RowLayout {
                spacing: 10
                TextField {
                    id: yearInput
                    placeholderText: "YYYY"
                    width: 60
                    inputMethodHints: Qt.ImhDigitsOnly
                }
                Button { text: "Год"; onClicked: backend.model.filterByYear(parseInt(yearInput.text)) }
            }

            Button {
                text: "Знакомство"
                onClicked: backend.model.viewAcquaintance()
            }
            Button { text: "Дальний гость";       onClicked: backend.model.sortByDistanceAndSurname() }
            Button { text: "Алфавит";             onClicked: backend.model.sortAlphabetic() }
        }
    }
}
