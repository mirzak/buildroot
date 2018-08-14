################################################################################
#
# mender-artifact
#
################################################################################

MENDER_ARTIFACT_VERSION = 2.2.0
MENDER_ARTIFACT_SITE = $(call github,mendersoftware,mender-artifact,$(MENDER_ARTIFACT_VERSION))
MENDER_ARTIFACT_LICENSE = Apache-2.0, BSD-2-Clause, BSD-3-Clause, ISC, MIT
MENDER_ARTIFACT_LICENSE_FILES = \
	LICENSE \
	LIC_FILES_CHKSUM.sha256 \
	vendor/github.com/mendersoftware/mendertesting/LICENSE \
	vendor/github.com/pkg/errors/LICENSE \
	vendor/github.com/pmezard/go-difflib/LICENSE \
	vendor/github.com/davecgh/go-spew/LICENSE \
	vendor/github.com/stretchr/testify/LICENSE \
	vendor/github.com/stretchr/testify/LICENCE.txt \
	vendor/github.com/urfave/cli/LICENSE

$(eval $(host-golang-package))
