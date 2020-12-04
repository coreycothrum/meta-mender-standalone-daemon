#!/bin/sh

echo "will check status in @@MENDER/STANDALONE_DAEMON_BIST_DELAY_SECS@@ seconds"

sleep @@MENDER/STANDALONE_DAEMON_BIST_DELAY_SECS@@

rc=0

if systemctl --quiet is-system-running; then
  echo "boot PASS : committing current mender artifact"
  mender commit
  rc=$?
else
  echo "boot ERROR: reboot to rollback"
fi

#nothing to commit, not an error
if [ $rc -eq 2 ]; then
  rc=0
fi

exit $rc
