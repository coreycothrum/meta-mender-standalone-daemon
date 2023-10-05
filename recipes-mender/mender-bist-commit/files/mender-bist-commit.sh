#!/bin/sh

rc=0
UPGRADE_AVAIL="$(fw_printenv upgrade_available | sed 's/[^=]*=//')"

if [ "$UPGRADE_AVAIL" -ne "0" ]; then
  echo "mender upgrade_available"

  if ! systemctl --quiet is-failed "*"; then
    echo "systemctl reports all good; committing current mender artifact"
    mender commit
    rc=$?
  else
    echo "systemctl reports failures; not commiting current mender artifact; reboot to rollback"
    rc=1
  fi

  # redundant now? # nothing to commit, not an error
  # redundant now? if [ $rc -eq 2 ]; then
  # redundant now?   rc=0
  # redundant now? fi
else
  echo "no mender upgrade_available; continuing to boot"
fi

exit $rc
