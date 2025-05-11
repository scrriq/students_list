#ifndef STUDENTMODEL_H
#define STUDENTMODEL_H

#include <QAbstractListModel>
#include <QVector>
#include <functional>
#include "student.h"

class StudentModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(bool acquaintanceView READ acquaintanceView NOTIFY acquaintanceViewChanged)
public:
    enum Roles { SurnameRole = Qt::UserRole + 1,
                 NameRole,
                 PatronymicRole,
                 BirthDateRole,
                 HeightRole,
                 CityRole,
                 AgeRole };
    explicit StudentModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE void loadFromFile(const QString &filePath);
    Q_INVOKABLE void reset();
    Q_INVOKABLE void filterCity(const QString &city);
    Q_INVOKABLE void filterAdults();
    Q_INVOKABLE void filterByYear(int year);
    Q_INVOKABLE void viewAcquaintance();
    Q_INVOKABLE void sortByDistanceAndSurname();
    Q_INVOKABLE void addStudent(const QString &surname,
                                const QString &name,
                                const QString &patronymic,
                                const QDate &birthDate,
                                double height,
                                const QString &city);
    Q_INVOKABLE void sortAlphabetic();
    Q_INVOKABLE void setAcquaintanceView(bool value);
signals:
    void acquaintanceViewChanged();

private:
    QVector<Student*> m_all;
    QVector<Student*> m_filtered;
    void applyFilter(const std::function<bool(Student*)> &predicate);
    bool m_acquaintanceView = false;
    bool acquaintanceView() const { return m_acquaintanceView; }
};
#endif // STUDENTMODEL_H
