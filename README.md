# meta-mender-standalone-daemon
Provide *semi*-automated install with standalone deployments of [Mender](https://github.com/mendersoftware/meta-mender). This can be useful in order to deploy updates to devices which do not have network connectivity or otherwise cannot use a managed deployment.

## Overview
* An encrypted version of the mender artifact is generated with password: ``MENDER/STANDALONE_DAEMON_ARTIFACT_PASSWD``
* ``mender-standalone-daemon.service`` automatically installs any mender artifact (stock or encrypted) found in ``MENDER/STANDALONE_DAEMON_DATA_DIR``
* ``mender-bist-commit.service`` commits the update if no systemd services have failed after ``MENDER/STANDALONE_DAEMON_BIST_DELAY_SECS`` (i.e. a successful boot).
  Additional dependencies can be added with ``MENDER/STANDALONE_DAEMON_BIST_SYSTEMD_AFTER``.

## Dependencies
This layer depends on:

    URI: git://git.openembedded.org/bitbake

    URI: git://git.openembedded.org/openembedded-core
    layers: meta
    branch: master

    URI: https://github.com/mendersoftware/meta-mender.git
    layers: meta-mender-core
    branch: master

    URI: https://github.com/coreycothrum/meta-bitbake-variable-substitution.git
    layers: meta-bitbake-variable-substitution
    branch: master

## Installation
### Add Layer to Build
In order to use this layer, the build system must be aware of it.

Assuming this layer exists at the top-level of the yocto build tree; add the location of this layer to ``bblayers.conf``, along with any additional layers needed:

    BBLAYERS ?= "                                       \
      /path/to/yocto/meta                               \
      /path/to/yocto/meta-poky                          \
      /path/to/yocto/meta-yocto-bsp                     \
      /path/to/yocto/meta-mender/meta-mender-core       \
      /path/to/yocto/meta-bitbake-variable-substitution \
      /path/to/yocto/meta-mender-standalone-daemon      \
      "

Alternatively, run bitbake-layers to add:

    $ bitbake-layers add-layer /path/to/yocto/meta-mender-standalone-daemon

### Configure Layer
The following definitions should be added to ``local.conf`` or ``custom_machine.conf``:

    require conf/include/mender-standalone-daemon.inc

    # encrypted mender artifact password
    MENDER/STANDALONE_DAEMON_ARTIFACT_PASSWD  = "n3w_p@ssw0rd"

    # directory on target that triggers an update
    #MENDER/STANDALONE_DAEMON_DATA_DIR        = "/run/.mender-standalone-daemon/uploads"

    # commit new artifact if system is running w/o error after this many seconds
    #MENDER/STANDALONE_DAEMON_BIST_DELAY_SECS = "300"

#### kas
Alternatively, a [kas](https://github.com/siemens/kas) file has been provided to help with setup/config. [Include](https://kas.readthedocs.io/en/latest/userguide.html#including-configuration-files-from-other-repos) `kas/kas.yml` from this layer in the top level kas file:

    header:
      version : 1
      includes:
        - repo: meta-mender-standalone-daemon
          file: kas/kas.yml

    local_conf_header:
      01_meta-mender-standalone-daemon: |
        # define here, or somewhere else in a custom layer
        MENDER/STANDALONE_DAEMON_ARTIFACT_PASSWD = "n3w_p@ssw0rd"

## Contributing
Please submit any patches against this layer via pull request.

Commits must be signed off.

Use [conventional commits](https://www.conventionalcommits.org/).
