IMAGE_INSTALL:append  = " packagegroup-mender-standalone-daemon"
INHERIT              += "mender-standalone-daemon-setup"

PREFERRED_PROVIDER_mender-native  = "mender-client-native"
PREFERRED_RPROVIDER_mender-auth   = "mender-client"
PREFERRED_RPROVIDER_mender-update = "mender-client"
