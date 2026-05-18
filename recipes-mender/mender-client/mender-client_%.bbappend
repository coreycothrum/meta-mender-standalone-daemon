do_install:append() {
  ln --relative --symbolic ${D}/${bindir}/mender ${D}/${bindir}/mender-auth
  ln --relative --symbolic ${D}/${bindir}/mender ${D}/${bindir}/mender-update
}
