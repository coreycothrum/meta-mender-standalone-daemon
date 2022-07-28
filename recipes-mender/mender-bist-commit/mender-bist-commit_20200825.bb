SUMMARY                = "commit a mender update on successful boot"
DESCRIPTION            = "commit a mender update on successful boot"
LICENSE                = "MIT"
LIC_FILES_CHKSUM       = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit systemd
inherit bitbake-variable-substitution

SYSTEMD_AUTO_ENABLE    = "enable"
SYSTEMD_SERVICE:${PN} += "mender-bist-commit.service"

SRC_URI               += "                                   \
                           file://mender-bist-commit.service \
                           file://mender-bist-commit.sh      \
                         "
FILES:${PN}            = "                                                      \
                           ${systemd_unitdir}/system/mender-bist-commit.service \
                           ${sbindir}/mender-bist-commit.sh                     \
                         "
RDEPENDS:${PN}         = "               \
                           coreutils     \
                           mender-client \
                         "

do_install:append() {
    install -d                                            ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/mender-bist-commit.service ${D}${systemd_unitdir}/system

    install -d                                            ${D}${sbindir}
    install -m 0755 ${WORKDIR}/mender-bist-commit.sh      ${D}${sbindir}
}
