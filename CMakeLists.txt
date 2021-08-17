cmake_minimum_required(VERSION 3.16)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

project(TaskBoard LANGUAGES CXX VERSION 1.0.0)

set(REQUIRED_QT_VERSION 5.14.0)
set(REQUIRED_KF5_VERSION 5.40.0)

find_package(ECM ${REQUIRED_KF5_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(GenerateExportHeader)
include(GNUInstallDirs)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings)
include(FeatureSummary)
include(ECMPoQmTools)
include(ECMQMLModules)
include(ECMSetupVersion)
include(CMakePackageConfigHelpers)
#include(KDEFrameworkCompilerSettings NO_POLICY_SCOPE)
include(KDEPackageAppTemplates)

set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/TaskBoard")

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/TaskBoardConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/TaskBoardConfig.cmake"
    INSTALL_DESTINATION ${CMAKECONFIG_INSTALL_DIR}
    PATH_VARS KF5_INCLUDE_INSTALL_DIR CMAKE_INSTALL_PREFIX
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/TaskBoardConfigVersion.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/TaskBoardConfig.cmake"
    DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
    COMPONENT Devel
)

    install(EXPORT TaskBoardTargets
        DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
        FILE TaskBoardTargets.cmake
        NAMESPACE TaskBoard::)

ecm_setup_version(${PROJECT_VERSION}
    VARIABLE_PREFIX TaskBoard
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/taskboard_version.h"
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/TaskBoardConfigVersion.cmake"
    SOVERSION 1
)

find_package(Qt5 ${REQUIRED_QT_VERSION} COMPONENTS Core Quick REQUIRED)

if(ANDROID)
find_package(Qt5 ${REQUIRED_QT_VERSION} COMPONENTS AndroidExtras)
endif()

find_package(KF5 ${REQUIRED_KF5_VERSION} REQUIRED COMPONENTS I18n CoreAddons)

add_subdirectory(src)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
