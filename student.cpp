#include "student.h"

Student::Student(const QString &surname,
                 const QString &name,
                 const QString &patronymic,
                 const QDate &birthDate,
                 double height,
                 const QString &city,
                 QObject *parent)
    : QObject(parent)
    , m_surname(surname)
    , m_name(name)
    , m_patronymic(patronymic)
    , m_birthDate(birthDate)
    , m_height(height)
    , m_city(city)
{}

QString Student::surname() const { return m_surname; }
QString Student::name() const { return m_name; }
QString Student::patronymic() const { return m_patronymic; }
QDate Student::birthDate() const { return m_birthDate; }
double Student::height() const { return m_height; }
QString Student::city() const { return m_city; }
int Student::age() const { return m_birthDate.daysTo(QDate::currentDate()) / 365; }
