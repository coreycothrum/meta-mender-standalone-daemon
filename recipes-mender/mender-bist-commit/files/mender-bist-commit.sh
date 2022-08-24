#!/bin/sh

rc=0

if ! systemctl --quiet is-failed "*"; then
  echo "boot PASS : committing current mender artifact"
  mender commit
  rc=$?
else
  echo "boot ERROR: reboot to rollback"
  rc=1
fi

#nothing to commit, not an error
if [ $rc -eq 2 ]; then
  rc=0
fi

exit $rc
