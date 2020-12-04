IMAGE_CLASSES += "                          \
  mender-standalone-daemon-encrypt-artifact \
"

python do_mender_standalone_daemon_checks() {
  ##############################################################################
  if not bb.utils.contains('DISTRO_FEATURES', 'systemd', True, False, d):
    bb.fatal("mender-standalone-daemon requires systemd")

  ##############################################################################
  passwd         = str(d.getVar('MENDER/STANDALONE_DAEMON_ARTIFACT_PASSWD'        , '')).lower()
  passwd_default = str(d.getVar('MENDER/STANDALONE_DAEMON_ARTIFACT_PASSWD_DEFAULT', '')).lower()

  if (passwd in passwd_default) or (passwd_default in passwd):
    bb.fatal("MENDER/STANDALONE_DAEMON_ARTIFACT_PASSWD (%s) is too similar to default (%s)" % (passwd, passwd_default))
}
addhandler do_mender_standalone_daemon_checks
do_mender_standalone_daemon_checks[eventmask] = "bb.event.ParseCompleted"
