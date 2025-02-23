
ecm_create_qm_loader(taskboard_QM_LOADER libtaskboardplugin_qt)

set(
    sources
    code/taskboard_plugin.cpp
    code/documenthandler.cpp
    resources.qrc
    ${taskboard_QM_LOADER}
)

set(
    pluginData
    controls/qmldir
)

add_library(
    TaskBoard
    SHARED
    ${sources} ${pluginData}
)

if(ANDROID)
    target_link_libraries(TaskBoard PRIVATE Qt5::AndroidExtras)
endif()

target_link_libraries(
    TaskBoard

    PRIVATE
        Qt5::Core
        Qt5::Quick
        Qt5::Qml
        KF5::I18n
        KF5::CoreAddons
)

if (BUILD_SHARED_LIBS)
    add_custom_target(copy_to_bin ALL
        COMMAND ${CMAKE_COMMAND} -E
                make_directory ${CMAKE_BINARY_DIR}/bin/org/kde/taskboard/
        COMMAND ${CMAKE_COMMAND} -E
                copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/controls ${CMAKE_BINARY_DIR}/bin/org/kde/taskboard/
        COMMAND ${CMAKE_COMMAND} -E
                copy $<TARGET_FILE:MauiKitTextEditor> ${CMAKE_BINARY_DIR}/bin/org/kde/taskboard/
    )

    install(DIRECTORY controls/ DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/taskboard)

    #include(ECMGeneratePriFile)
    #ecm_generate_pri_file(BASE_NAME KQuickImageEditor LIB_NAME KQuickImageEditor DEPS "core qml quick svg" FILENAME_VAR PRI_FILENAME )
    #install(FILES ${PRI_FILENAME}
            #DESTINATION ${ECM_MKSPECS_INSTALL_DIR})

endif()

install(TARGETS MauiKitTextEditor DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/taskboard )
