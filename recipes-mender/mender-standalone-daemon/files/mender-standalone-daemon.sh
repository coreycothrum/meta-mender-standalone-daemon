#!/bin/sh
set -e

UPLOAD_DIR=@@MENDER/STANDALONE_DAEMON_DATA_DIR@@
LOG_FILE="${RUNTIME_DIRECTORY}/last_log"
LOG_STAT="${RUNTIME_DIRECTORY}/progress"

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
  echo -n "" > $LOG_STAT
}

function cleanup {
  rm -fr ${UPLOAD_DIR}/*
}
trap cleanup EXIT

################################################################################
init

FILENAME=$(find ${UPLOAD_DIR} -iname *.@@MENDER/STANDALONE_DAEMON_ARTIFACT_ENCRYPT_EXT@@ | head -1)
if [ -f "$FILENAME" ]; then
  log "decrypting $FILENAME" && sleep 2

  openssl enc -d    @@MENDER/STANDALONE_DAEMON_ARTIFACT_OPENSSL_OPTS@@ \
              -pass pass:@@MENDER/STANDALONE_DAEMON_ARTIFACT_PASSWD@@  \
              -in   "$FILENAME"                                        \
	      -out  "$(dirname $FILENAME)/$(basename $FILENAME .@@MENDER/STANDALONE_DAEMON_ARTIFACT_ENCRYPT_EXT@@)"

  rm -f "${FILENAME}"
fi

FILENAME=$(find ${UPLOAD_DIR} -iname *.mender | head -1)
if [ -f "$FILENAME" ]; then
  log "found $FILENAME, executing mender install $FILENAME" && sleep 2
  set -o pipefail
  unbuffer mender install $FILENAME 2>&1 | tee $LOG_FILE $LOG_STAT || fatal "update failed"
fi

exit
