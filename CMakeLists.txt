cmake_minimum_required(VERSION 3.16)
project(TheNinthLab VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# qt_add_resources(APP_RESOURCES qml.qrc)
# target_sources(TheNinthLab PRIVATE ${APP_RESOURCES})

find_package(Qt6 REQUIRED COMPONENTS Quick Qml)

qt_add_executable(appTheNinthLab
    main.cpp
    back.cpp
    student.cpp
    studentmodel.cpp
    back.h
    student.h
    studentmodel.h
    qml.qrc
    students_list.txt
)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 Qml)
target_link_libraries(appTheNinthLab
    PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Qml
)

target_link_libraries(appTheNinthLab PRIVATE Qt6::Quick Qt6::Qml)
