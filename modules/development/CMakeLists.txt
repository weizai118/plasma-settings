project(kcm_settings_devel)

set(developmentsettings_SRCS
    develsettings.cpp
)

add_library(kcm_settings_devel MODULE ${developmentsettings_SRCS})

target_link_libraries(kcm_settings_devel
    Qt5::Core
    Qt5::Qml
    Qt5::Quick
    Qt5::DBus
    KF5::Auth
    KF5::Plasma
    KF5::I18n
    KF5::QuickAddons
)

kcoreaddons_desktop_to_json(kcm_settings_devel "develsettings.desktop")

install(TARGETS kcm_settings_devel DESTINATION ${PLUGIN_INSTALL_DIR}/kcms)
install(FILES develsettings.desktop DESTINATION ${SERVICES_INSTALL_DIR})

kpackage_install_package(package kcm_settings_devel kcms)

###SSH
add_executable(active-sshd-helper sshdhelper.cpp ${helper_mocs})
target_link_libraries(active-sshd-helper
    Qt5::Core
    KF5::Auth
)

install(TARGETS active-sshd-helper DESTINATION ${KAUTH_HELPER_INSTALL_DIR})

kauth_install_helper_files(active-sshd-helper org.kde.active.sshdcontrol root)
kauth_install_actions(org.kde.active.sshdcontrol active_dev_sshd.actions)
