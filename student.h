#ifndef STUDENT_H
#define STUDENT_H

#include <QObject>
#include <QDate>

class Student : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString surname READ surname CONSTANT)
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString patronymic READ patronymic CONSTANT)
    Q_PROPERTY(QDate birthDate READ birthDate CONSTANT)
    Q_PROPERTY(double height READ height CONSTANT)
    Q_PROPERTY(QString city READ city CONSTANT)
    Q_PROPERTY(int age READ age CONSTANT)
public:
    explicit Student(const QString &surname,
                     const QString &name,
                     const QString &patronymic,
                     const QDate &birthDate,
                     double height,
                     const QString &city,
                     QObject *parent = nullptr);
    QString surname() const;
    QString name() const;
    QString patronymic() const;
    QDate birthDate() const;
    double height() const;
    QString city() const;
    int age() const;
private:
    QString m_surname;
    QString m_name;
    QString m_patronymic;
    QDate m_birthDate;
    double m_height;
    QString m_city;
};
#endif // STUDENT_H
