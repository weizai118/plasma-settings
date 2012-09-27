project(active_settings_devel)
find_package(KDE4 REQUIRED)
include(KDE4Defaults)
add_definitions(${QT_DEFINITIONS} ${KDE4_DEFINITIONS})

include_directories(${KDE4_INCLUDES} ../../../../components/settings)

set(developmentsettings_SRCS develsettingsplugin.cpp)

if(Q_WS_X11)
    set(developmentsettings_SRCS ${developmentsettings_SRCS} cursors_x11.cpp)
endif(Q_WS_X11)

kde4_add_plugin(active_settings_devel ${developmentsettings_SRCS})

target_link_libraries(active_settings_devel ${KDE4_PLASMA_LIBS} ${QT_QTDECLARATIVE_LIBRARY})
if(Q_WS_X11)
   target_link_libraries(active_settings_devel ${X11_Xfixes_LIB} ${X11_Xrender_LIB} ${X11_X11_LIB} ${X11_Xcursor_LIB})
endif(Q_WS_X11)

install(TARGETS active_settings_devel DESTINATION ${PLUGIN_INSTALL_DIR})

install(DIRECTORY package/ DESTINATION ${DATA_INSTALL_DIR}/plasma/packages/org.kde.active.settings.development)
install(FILES package/metadata.desktop DESTINATION ${SERVICES_INSTALL_DIR} RENAME org.kde.active.settings.development.desktop)


########### helper ###############

kde4_add_executable(active-sshd-helper sshdhelper.cpp ${helper_mocs})
target_link_libraries(active-sshd-helper ${KDE4_KDECORE_LIBS})
install(TARGETS active-sshd-helper DESTINATION ${LIBEXEC_INSTALL_DIR})

kde4_install_auth_helper_files(active-sshd-helper org.kde.active.sshdcontrol root)
kde4_install_auth_actions(org.kde.active.sshdcontrol active_dev_sshd.actions)