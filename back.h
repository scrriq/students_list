#ifndef BACK_H
#define BACK_H

#include <QObject>
#include <QDate>
#include "studentmodel.h"

class Back : public QObject {
    Q_OBJECT
    Q_PROPERTY(StudentModel* model READ model CONSTANT)

public:
    explicit Back(QObject *parent = nullptr);
    StudentModel* model() const;

    // Основной метод для добавления студента с QDate
    Q_INVOKABLE void addStudent(
        const QString &surname,
        const QString &name,
        const QString &patronymic,
        const QDate &birthDate,
        double height,
        const QString &city
        );

    // Метод для добавления из строки с датой
    Q_INVOKABLE void addStudentFromString(
        const QString &surname,
        const QString &name,
        const QString &patronymic,
        const QString &birthDateString,
        double height,
        const QString &city
        );

signals:
    void dateParseError(const QString &error);

private:
    QDate parseDate(const QString &dateString);
    StudentModel m_model;
};

#endif // BACK_H
