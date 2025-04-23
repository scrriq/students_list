#include "back.h"
#include <QStringList>
#include <QDebug>
#include <QCoreApplication>
#include <QFile>
#include <iostream>
#include <QString>

Back::Back(QObject *parent)
    : QObject(parent)
{
    QString path = QCoreApplication::applicationDirPath() + "/students_list.txt";
    m_model.loadFromFile(path);
}

StudentModel* Back::model() const {
    return const_cast<StudentModel*>(&m_model);
}

void Back::addStudent(
    const QString &surname,
    const QString &name,
    const QString &patronymic,
    const QDate &birthDate,
    double height,
    const QString &city
    ) {
    m_model.addStudent(surname, name, patronymic, birthDate, height, city);
    std::cout << "Сработало" << "\n";
}

void Back::addStudentFromString(
    const QString &surname,
    const QString &name,
    const QString &patronymic,
    const QString &birthDateString,
    double height,
    const QString &city
    ) {
    QDate date = parseDate(birthDateString);
    if (date.isValid()) {
        addStudent(surname, name, patronymic, date, height, city);
    }
}

QDate Back::parseDate(const QString &dateString) {
    if (dateString.isEmpty()) {
        emit dateParseError("Пустая дата");
        return QDate();
    }

    QStringList parts = dateString.split('.');
    if (parts.size() != 3) {
        emit dateParseError("Неверный формат: используйте дд.мм.гггг");
        return QDate();
    }

    bool ok;
    int day = parts[0].toInt(&ok);
    if (!ok || day < 1 || day > 31) {
        emit dateParseError("Некорректный день (1-31)");
        return QDate();
    }

    int month = parts[1].toInt(&ok);
    if (!ok || month < 1 || month > 12) {
        emit dateParseError("Некорректный месяц (1-12)");
        return QDate();
    }

    int year = parts[2].toInt(&ok);
    if (!ok || year < 1900 || year > QDate::currentDate().year()) {
        emit dateParseError(QString("Год должен быть между 1900 и %1").arg(QDate::currentDate().year()));
        return QDate();
    }

    QDate date(year, month, day);
    if (!date.isValid()) {
        emit dateParseError("Несуществующая календарная дата");
    }

    return date;
}
