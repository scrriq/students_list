#include "studentmodel.h"
#include <QFile>
#include <QTextStream>
#include <QDate>
#include <algorithm>
#include <climits>
#include <QDebug>
#include <iostream>
#include <QCoreApplication>

static const QMap<QString,int> kCityDistances = {
    {"Москва", 0},
    {"Санкт-Петербург", 700},
    {"Казань", 800},
    {"Новосибирск", 2000},
    {"Екатеринбург", 1800}
};

StudentModel::StudentModel(QObject *parent)
    : QAbstractListModel(parent)
{}


void StudentModel::setAcquaintanceView(bool value) {
    if (m_acquaintanceView != value) {
        m_acquaintanceView = value;
        emit acquaintanceViewChanged();
    }
}

void StudentModel::viewAcquaintance() {
    setAcquaintanceView(true);
    reset();
}


int StudentModel::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent)
    return m_filtered.size();
}

QVariant StudentModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_filtered.size())
        return {};
    Student* s = m_filtered.at(index.row());
    switch (role) {
    case SurnameRole:    return s->surname();
    case NameRole:       return s->name();
    case PatronymicRole: return s->patronymic();
    case BirthDateRole:  return s->birthDate();
    case HeightRole:     return s->height();
    case CityRole:       return s->city();
    case AgeRole:        return s->age();
    }
    return {};
}

QHash<int, QByteArray> StudentModel::roleNames() const {
    return {
        {SurnameRole,    "surname"},
        {NameRole,       "name"},
        {PatronymicRole, "patronymic"},
        {BirthDateRole,  "birthDate"},
        {HeightRole,     "studentHeight"},
        {CityRole,       "city"},
        {AgeRole,        "age"}
    };
}


void StudentModel::sortAlphabetic() {
    beginResetModel();
    m_filtered = m_all;
    std::sort(m_filtered.begin(), m_filtered.end(),
              [](Student* a, Student* b) {
                  // сначала по фамилии, потом по имени и отчества
                  if (a->surname() != b->surname())
                      return a->surname() < b->surname();
                  if (a->name() != b->name())
                      return a->name() < b->name();
                  return a->patronymic() < b->patronymic();
              });
    endResetModel();
}

void StudentModel::loadFromFile(const QString &filePath) {
    beginResetModel();
    qDeleteAll(m_all);
    m_all.clear();
    QFile file(filePath);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        while (!in.atEnd()) {
            auto fields = in.readLine().split(';');
            if (fields.size() != 6) continue;
            Student* s = new Student(
                fields[0], fields[1], fields[2],
                QDate::fromString(fields[3], Qt::ISODate),
                fields[4].toDouble(), fields[5], this
                );
            m_all.push_back(s);
        }
    }
    m_filtered = m_all;
    endResetModel();
}

void StudentModel::reset() {
    beginResetModel();
    m_filtered = m_all;
    endResetModel();
    // setAcquaintanceView(true);
}


void StudentModel::applyFilter(const std::function<bool(Student*)> &predicate) {
    beginResetModel();
    m_filtered.clear();
    for (Student* s : m_all) {
        if (!predicate(s)) m_filtered.push_back(s);
    }
    endResetModel();
}

void StudentModel::filterCity(const QString &city) {
    setAcquaintanceView(false);
    applyFilter([&](Student* s){ return s->city() != city; });
}
void StudentModel::filterAdults() {
    applyFilter([](Student* s){ return s->age() < 18; });
}

void StudentModel::filterByYear(int year) {
    applyFilter([&](Student* s){ return s->birthDate().year() != year; });
}


void StudentModel::sortByDistanceAndSurname() {
    beginResetModel();
    m_filtered = m_all;
    std::sort(m_filtered.begin(), m_filtered.end(), [](Student* a, Student* b) {
        int da = kCityDistances.value(a->city(), INT_MAX);
        int db = kCityDistances.value(b->city(), INT_MAX);
        if (da != db) return da > db;
        return a->surname() > b->surname();
    });
    endResetModel();
}

void StudentModel::addStudent(const QString &surname,
                              const QString &name,
                              const QString &patronymic,
                              const QDate &birthDate,
                              double height,
                              const QString &city) {
    int row = m_all.size();
    beginInsertRows({}, row, row);
    Student* s = new Student(surname, name, patronymic, birthDate, height, city, this);
    m_all.push_back(s);
    m_filtered.push_back(s);
    endInsertRows();




    // открытие файла
    QString path = QCoreApplication::applicationDirPath() + "/students_list.txt";
    QFile file(path);
    // qDebug() << path;
    // qDebug() << path.toUtf8();
    // qDebug() << "Существует ли файл?" << QFile::exists(path);

    if (file.open(QIODevice::Append | QIODevice::Text)) { //  вывод в файлик
        QTextStream out(&file);
        out << surname << ";" << name << ";" << patronymic << ";"
            << birthDate.toString(Qt::ISODate) << ";" << height << ";" << city << "\n";
        qDebug() << "Добавление студента:" << surname << name << patronymic << birthDate << height << city;
        file.close();

    }else {
        qWarning() << "Не удалось открыть файл для записи:" << file.errorString();
    }

}
