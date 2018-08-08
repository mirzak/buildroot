################################################################################
#
# mender
#
################################################################################

MENDER_VERSION = 1.4.0
MENDER_SITE = $(call github,mendersoftware,mender,$(MENDER_VERSION))
MENDER_LICENSE = Apache-2.0 & BSD-2-Clause & BSD-3-Clause & MIT & OLDAP-2.8
MENDER_LICENSE_FILES = LICENSE LIC_FILES_CHKSUM.sha256

define MENDER_INSTALL_CONFIG_FILES
	$(INSTALL) -d -m 755 $(TARGET_DIR)/data/mender
	$(INSTALL) -d -m 755 $(TARGET_DIR)/data/uboot
	$(INSTALL) -d -m 755 $(TARGET_DIR)/uboot
	$(INSTALL) -d -m 755 $(TARGET_DIR)/usr/share/mender/inventory

	$(INSTALL) -d -m 755 $(TARGET_DIR)/etc/mender/scripts
	echo -n "2" > $(TARGET_DIR)/etc/mender/scripts/version

	$(INSTALL) -D -m 0644 package/mender/mender.conf \
		$(TARGET_DIR)/etc/mender/mender.conf
	$(INSTALL) -D -m 0644 package/mender/server.crt \
		$(TARGET_DIR)/etc/mender/server.crt
	$(INSTALL) -D -m 0755 $(@D)/support/mender-device-identity \
		$(TARGET_DIR)/usr/share/mender/identity/mender-device-identity
	$(INSTALL) -D -m 0755 $(@D)/support/mender-inventory-* \
		$(TARGET_DIR)/usr/share/mender/inventory

	ln -sf /data/mender $(TARGET_DIR)/var/lib/mender
endef

MENDER_POST_INSTALL_TARGET_HOOKS += MENDER_INSTALL_CONFIG_FILES

define MENDER_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/mender/mender.service \
		$(TARGET_DIR)/usr/lib/systemd/system/mender.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/mender.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/mender.service
endef

$(eval $(golang-package))
