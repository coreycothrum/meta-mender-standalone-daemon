DESCRIPTION = "meta-mender-standalone-daemon packages"
SUMMARY     = "meta-mender-standalone-daemon packages"

inherit packagegroup

RDEPENDS_${PN} += "                          \
                    mender-bist-commit       \
                    mender-standalone-daemon \
                  "
