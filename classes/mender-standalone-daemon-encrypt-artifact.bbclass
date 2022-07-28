IMAGE_CMD:mender:append () {
  local artifact="${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.mender"
  local enc_file="${artifact}.${MENDER/STANDALONE_DAEMON_ARTIFACT_ENCRYPT_EXT}"

  local pln_file="${IMGDEPLOYDIR}/${ARTIFACTIMG_NAME}-${MENDER_ARTIFACT_NAME}.mender"
  local eln_file="${pln_file}.${MENDER/STANDALONE_DAEMON_ARTIFACT_ENCRYPT_EXT}"

  openssl enc ${MENDER/STANDALONE_DAEMON_ARTIFACT_OPENSSL_OPTS}       \
               -pass pass:${MENDER/STANDALONE_DAEMON_ARTIFACT_PASSWD} \
               -in   "${artifact}"                                    \
               -out  "${enc_file}"

  ln -sfn "$(basename ${artifact})" "${pln_file}"
  ln -sfn "$(basename ${enc_file})" "${eln_file}"
}
do_image_mender[depends] += "openssl-native:do_populate_sysroot"
