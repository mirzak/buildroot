################################################################################
#
# mender-artifact
#
################################################################################

MENDER_ARTIFACT_VERSION = 2.2.0
MENDER_ARTIFACT_SITE = $(call github,mendersoftware,mender-artifact,$(MENDER_ARTIFACT_VERSION))
MENDER_ARTIFACT_LICENSE = Apache-2.0 & BSD-2-Clause & BSD-3-Clause & ISC & MIT
MENDER_ARTIFACT_LICENSE_FILES = LICENSE LIC_FILES_CHKSUM.sha256

HOST_MENDER_ARTIFACT_SRC_SUBDIR = github.com/mendersoftware/mender-artifact

HOST_MENDER_ARTIFACT_INSTALL_BINS = mender-artifact
HOST_MENDER_ARTIFACT_BIN_NAME = mender-artifact

$(eval $(host-golang-package))
