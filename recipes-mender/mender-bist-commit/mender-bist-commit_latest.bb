SUMMARY                = "commit a mender update on successful boot"
DESCRIPTION            = "commit a mender update on successful boot"
LICENSE                = "MIT"
LIC_FILES_CHKSUM       = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit systemd
inherit bitbake-variable-substitution-helpers
inherit mender-state-scripts

SYSTEMD_AUTO_ENABLE    = "enable"
SYSTEMD_SERVICE:${PN} += "mender-bist-commit.service"

SRC_URI               += "                                     \
                           file://abort-if-bist-in-progress.sh \
                           file://mender-bist-commit.service   \
                           file://mender-bist-commit.sh        \
                         "
FILES:${PN}           += "                                                      \
                           ${systemd_unitdir}/system/mender-bist-commit.service \
                           ${sbindir}/mender-bist-commit.sh                     \
                         "
RDEPENDS:${PN}        += "               \
                           coreutils     \
                           mender-client \
                           util-linux    \
                         "

do_compile[nostamp] = "1"
do_compile() {
    cp ${WORKDIR}/abort-if-bist-in-progress.sh            ${MENDER_STATE_SCRIPTS_DIR}/Download_Enter_00_mender-standalone-abort-if-bist-in-progress.sh
    ${@bitbake_variables_search_and_sub(                 "${MENDER_STATE_SCRIPTS_DIR}/", r"${BITBAKE_VAR_SUB_DELIM}", d)}
}

do_install:append() {
    install -d                                            ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/mender-bist-commit.service ${D}${systemd_unitdir}/system
    ${@bitbake_variables_search_and_sub(                 "${D}${systemd_unitdir}/system/", r"${BITBAKE_VAR_SUB_DELIM}", d)}

    install -d                                            ${D}${sbindir}
    install -m 0755 ${WORKDIR}/mender-bist-commit.sh      ${D}${sbindir}
    ${@bitbake_variables_search_and_sub(                 "${D}${sbindir}/", r"${BITBAKE_VAR_SUB_DELIM}", d)}
}
