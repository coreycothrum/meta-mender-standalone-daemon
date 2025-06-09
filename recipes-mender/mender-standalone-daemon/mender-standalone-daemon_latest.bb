SUMMARY          = "Mender Standalone Update Daemon"
DESCRIPTION      = "Mender Standalone Update Daemon"
LICENSE          = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

################################################################################

inherit systemd
inherit bitbake-variable-substitution

SYSTEMD_AUTO_ENABLE    = "enable"
SYSTEMD_SERVICE:${PN} += "mender-standalone-daemon.path"

SRC_URI          = "                                         \
                     file://mender-standalone-daemon.sh      \
                     file://mender-standalone-daemon.path    \
                     file://mender-standalone-daemon.service \
                   "
FILES:${PN}      = "                                                            \
                     ${sbindir}/mender-standalone-daemon.sh                     \
                     ${systemd_unitdir}/system/mender-standalone-daemon.path    \
                     ${systemd_unitdir}/system/mender-standalone-daemon.service \
                   "
RDEPENDS:${PN}   = "               \
                     coreutils     \
                     expect        \
                     mender-client \
                     openssl       \
                   "

do_install () {
    install -d -m 755                                            ${D}${sbindir}
    install    -m 755 ${WORKDIR}/mender-standalone-daemon.sh     ${D}${sbindir}

    install -d                                                   ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/mender-standalone-daemon.path     ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/mender-standalone-daemon.service  ${D}${systemd_unitdir}/system
}
