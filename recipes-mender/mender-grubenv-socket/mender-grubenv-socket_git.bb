SUMMARY                  = "mender grubenv output available via systemd socket"
DESCRIPTION              = "mender grubenv output available via systemd socket"
LICENSE                  = "MIT"
LIC_FILES_CHKSUM         = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

################################################################################
SYSTEMD_AUTO_ENABLE    = "enable"
SYSTEMD_SERVICE:${PN} += "mender-grubenv.socket"

RDEPENDS:${PN}        += "                     \
                           grub-mender-grubenv \
                           mender-client       \
                         "
SRC_URI                = "                                \
                           file://mender-grubenv.socket   \
                           file://mender-grubenv@.service \
                         "
FILES:${PN}           += "                                             \
                           ${systemd_unitdir}/system/mender-grubenv*.* \
                         "

inherit systemd

do_install:append() {
    install -d                                         ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/mender-grubenv.socket   ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/mender-grubenv@.service ${D}${systemd_unitdir}/system
}
