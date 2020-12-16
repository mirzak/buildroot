################################################################################
#
# python-mender
#
################################################################################

PYTHON_MENDER_VERSION = master
PYTHON_MENDER_SITE = $(call github,mirzak,mender-python-client,$(PYTHON_MENDER_VERSION))
PYTHON_MENDER_LICENSE = Apache-2.0
PYTHON_MENDER_LICENSE_FILES = LICENSE
PYTHON_MENDER_SETUP_TYPE = setuptools

$(eval $(python-package))
