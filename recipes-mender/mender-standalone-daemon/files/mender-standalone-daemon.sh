#!/bin/sh
set -e

UPLOAD_DIR=@@MENDER/STANDALONE_DAEMON_DATA_DIR@@
WORK_DIR="${RUNTIME_DIRECTORY}"
LOG_FILE="${LOGS_DIRECTORY}/last_log"

function log {
  echo $@
  echo $@ >> $LOG_FILE
}

function fatal {
  log  $@
  echo $@
  exit 1
}

function init {
  echo -n "" > $LOG_FILE

  #move upload/session directory into RUNTIME
  FILES=$( ls -dt ${UPLOAD_DIR}/*/ | head -1 )

  mkdir -p           ${WORK_DIR}/uploads/
  mv        ${FILES} ${WORK_DIR}/uploads/
  rm    -fr ${FILES}
}

function cleanup {
  rm -fr ${UPLOAD_DIR}/*
}
trap cleanup EXIT

################################################################################
init

FILENAME=$(find ${WORK_DIR}/uploads/ -iname *.@@MENDER/STANDALONE_DAEMON_ARTIFACT_ENCRYPT_EXT@@)
if [ -f "$FILENAME" ]; then
  log "decrypting $FILENAME" && sleep 5

  openssl enc -d    @@MENDER/STANDALONE_DAEMON_ARTIFACT_OPENSSL_OPTS@@ \
              -pass pass:@@MENDER/STANDALONE_DAEMON_ARTIFACT_PASSWD@@  \
              -in   "$FILENAME"                                   \
	      -out  "$(dirname $FILENAME)/$(basename $FILENAME .@@MENDER/STANDALONE_DAEMON_ARTIFACT_ENCRYPT_EXT@@)"
fi

FILENAME=$(find ${WORK_DIR}/uploads/ -iname *.mender)
if [ -f "$FILENAME" ]; then
  log     "found $FILENAME, executing mender install $FILENAME" && sleep 5
  mender install $FILENAME >>$LOG_FILE || fatal "update failed"
fi

exit
