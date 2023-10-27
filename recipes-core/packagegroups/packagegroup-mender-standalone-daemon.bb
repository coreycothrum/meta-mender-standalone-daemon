DESCRIPTION = "meta-mender-standalone-daemon packages"
SUMMARY     = "meta-mender-standalone-daemon packages"

inherit packagegroup

RDEPENDS:${PN} += "                          \
                    mender-bist-commit       \
                    mender-standalone-daemon \
                    ${@mender_feature_is_enabled("mender-grub","mender-grubenv-socket","",d)} \
                  "
