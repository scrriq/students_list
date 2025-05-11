import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 6.8
import QtQuick.Layouts 1.15

Rectangle {
    width: 500; height: 400
    color: "#EEEEEE"; radius: 8; border.color: "#CCCCCC"

    signal studentAdded

    ColumnLayout {
        anchors.fill: parent; anchors.margins: 20; spacing: 15

        RowLayout { spacing: 25; Layout.fillWidth: true
            ColumnLayout { spacing: 15
                RowLayout { spacing: 6;
                    Label { text: "Фамилия:" }
                    TextField { id: tfSurname; Layout.fillWidth: true }
                }
                RowLayout { spacing: 6;
                    Label { text: "Имя:" }
                    TextField { id: tfName;Layout.fillWidth: true }
                }
                RowLayout { spacing: 6;
                    Label { text: "Отчество:" }
                    TextField { id: tfPat; Layout.fillWidth: true }
                }
            }
            ColumnLayout { spacing: 25
                RowLayout { spacing: 6
                    Label { text: "Дата рождения:" }
                    CustomDatePicker {
                        id: datePicker
                        Layout.topMargin: -50
                    }
                }
                RowLayout { spacing: 6
                    Label { text: "Рост (м):" }
                    TextField { id: tfHeight; Layout.fillWidth: true; inputMethodHints: Qt.ImhFormattedNumbersOnly }
                }
                RowLayout { spacing: 6
                    Label { text: "Город:" }
                    ComboBox { id: cbCity; model: ["Москва","Санкт-Петербург","Казань","Новосибирск","Екатеринбург"] }
                }
            }
        }

        Button {
            text: "Добавить студента"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                // Имя: каждое слово начинается с заглавной, за ним строчные; между словами ровно один пробел
                var namePattern    = /^[А-ЯЁ][а-яё]+(?: [А-ЯЁ][а-яё]+)*$/;
                // Фамилия: одно слово с необязательным "-ВтораяЧасть", дефис не в начале и не в конце
                var surnamePattern = /^[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?$/;
                // Отчество: одно слово без дефисов/пробелов, но может быть пустым
                var patPattern     = /^[А-ЯЁ][а-яё]+$/;

                // Проверяем имя
                if (!namePattern.test(tfName.text)) {
                    errorMessage.text = "Некорректное имя";
                    errorDialog.open();
                    return;
                }

                // Проверяем фамилию
                if (!surnamePattern.test(tfSurname.text)) {
                    errorMessage.text = "Некорректная фамилия";
                    errorDialog.open();
                    return;
                }

                // Проверяем отчество только если оно непустое
                if (tfPat.text !== "" && !patPattern.test(tfPat.text)) {
                    errorMessage.text = "Некорректное отчество";
                    errorDialog.open();
                    return;
                }

                var dateString = Qt.formatDate(datePicker.selectedDate, "dd.MM.yyyy");
                if (tfHeight.text === "") tfHeight.text = "0";
                backend.addStudentFromString(
                    tfSurname.text,
                    tfName.text,
                    tfPat.text,
                    dateString,
                    parseFloat(tfHeight.text),
                    cbCity.currentText
                );
                studentAdded();
            }
        }

    }

    Dialog {
        id: errorDialog; title: "Ошибка ввода"; standardButtons: Dialog.Ok
        Label { id: errorMessage; text: "Ошибка" }
    }
    Connections {
        target: backend
        function onDateParseError(error) {
            errorMessage.text = error; errorDialog.open();
        }
    }
}
