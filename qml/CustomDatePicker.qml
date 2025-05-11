import QtQuick 2.15
import QtQuick.Controls 6.8
import QtQuick.Controls.Material 6.8
import QtQuick.Layouts 1.15

Item {
    id: root
    property var selectedDate: new Date()
    signal dateChanged(var newDate)

    Button {
        id: trigger
        text: Qt.formatDate(root.selectedDate, "dd.MM.yyyy")
        onClicked: popup.open()
    }

    Popup {
        id: popup
        modal: true
        focus: true
        onClosed: trigger.text = Qt.formatDate(root.selectedDate, "dd.MM.yyyy")

        ColumnLayout {
            width: 280; spacing: 4; anchors.centerIn: parent

            DayOfWeekRow {
                locale: Qt.locale()
                Layout.fillWidth: true
            }

            MonthGrid {
                id: grid
                month: root.selectedDate.getMonth() + 1
                year: root.selectedDate.getFullYear()
                locale: Qt.locale()
                Layout.fillWidth: true
                Layout.fillHeight: true
                onClicked: (date) => {
                    root.selectedDate = date
                    root.dateChanged(date)
                    popup.close()
                }
            }

            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignHCenter

                Button {
                    text: "<"
                    onClicked: {
                        if (grid.month > 1) {
                            grid.month--
                        } else {
                            grid.month = 12
                            grid.year--
                            yearSelector.value = grid.year
                        }
                    }
                }

                Text {
                    text: Qt.locale().standaloneMonthName(grid.month) + " " + grid.year
                    font.bold: true
                }

                Button {
                    text: ">"
                    onClicked: {
                        if (grid.month < 12) {
                            grid.month++
                        } else {
                            grid.month = 1
                            grid.year++
                            yearSelector.value = grid.year
                        }
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                Text { text: "Год:" }

                SpinBox {
                    id: yearSelector
                    from: 0
                    to: 2100
                    value: root.selectedDate.getFullYear()
                    onValueChanged: grid.year = value
                }
            }
        }
    }
}
