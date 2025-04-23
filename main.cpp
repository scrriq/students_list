#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "back.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    Back backend;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("backend", &backend);
    engine.rootContext()->setContextProperty("studentModel", backend.model());

    engine.load(QUrl("qrc:/qml/Main.qml"));
    if (engine.rootObjects().isEmpty()) return -1;
    return app.exec();
}
