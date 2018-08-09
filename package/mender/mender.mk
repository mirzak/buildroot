################################################################################
#
# mender
#
################################################################################

MENDER_VERSION = 1.4.0
MENDER_SITE = $(call github,mendersoftware,mender,$(MENDER_VERSION))
MENDER_LICENSE = Apache-2.0 & BSD-2-Clause & BSD-3-Clause & MIT & OLDAP-2.8
MENDER_LICENSE_FILES = LICENSE LIC_FILES_CHKSUM.sha256

ifeq ($(call qstrip,$(BR2_PACKAGE_MENDER_ARTIFACT_NAME)),)
$(error Mender device type not set. Check your BR2_PACKAGE_MENDER_ARTIFACT_NAME setting)
endif

ifeq ($(call qstrip,$(BR2_PACKAGE_MENDER_DEVICE_TYPE)),)
$(error Mender device type not set. Check your BR2_PACKAGE_MENDER_DEVICE_TYPE setting)
endif

define MENDER_INSTALL_CONFIG_FILES
	$(INSTALL) -d -m 755 $(TARGET_DIR)/data/mender
	$(INSTALL) -d -m 755 $(TARGET_DIR)/data/uboot
	$(INSTALL) -d -m 755 $(TARGET_DIR)/uboot
	$(INSTALL) -d -m 755 $(TARGET_DIR)/usr/share/mender/inventory

	$(INSTALL) -d -m 755 $(TARGET_DIR)/etc/mender/scripts
	echo -n "2" > $(TARGET_DIR)/etc/mender/scripts/version

	$(INSTALL) -D -m 0644 package/mender/server.crt \
		$(TARGET_DIR)/etc/mender/server.crt
	$(INSTALL) -D -m 0755 $(@D)/support/mender-device-identity \
		$(TARGET_DIR)/usr/share/mender/identity/mender-device-identity
	$(INSTALL) -D -m 0755 $(@D)/support/mender-inventory-* \
		$(TARGET_DIR)/usr/share/mender/inventory

	ln -sf /data/mender $(TARGET_DIR)/var/lib/mender

	echo "artifact_name=$(call qstrip,$(BR2_PACKAGE_MENDER_ARTIFACT_NAME))" > \
		$(TARGET_DIR)/etc/mender/artifact_info

	echo "device_type=$(call qstrip,$(BR2_PACKAGE_MENDER_DEVICE_TYPE))" > \
		$(TARGET_DIR)/data/mender/device_type

	sed -e 's#@MENDER_ROOTFS_PART_A@#$(call qstrip,$(BR2_PACKAGE_MENDER_ROOTFS_PART_A))#g' \
		-e 's#@MENDER_ROOTFS_PART_B@#$(call qstrip,$(BR2_PACKAGE_MENDER_ROOTFS_PART_B))#g' \
		-e 's/@MENDER_UPDATE_POLL_INTERVAL_SECONDS@/$(call qstrip,$(BR2_PACKAGE_MENDER_UPDATE_POLL_INTERVAL_SEC))/' \
		-e 's/@MENDER_INVENTORY_POLL_INTERVAL_SECONDS@/$(call qstrip,$(BR2_PACKAGE_MENDER_INVENTORY_POLL_INTERVAL_SEC))/' \
		-e 's/@MENDER_RETRY_POLL_INTERVAL_SECONDS@/$(call qstrip,$(BR2_PACKAGE_MENDER_RETRY_POLL_INTERVAL_SEC))/' \
		-e 's#@MENDER_SERVER_URL@#$(call qstrip,$(BR2_PACKAGE_MENDER_SERVER_URL))#g' \
		-e 's#@MENDER_CERT_LOCATION@#$(call qstrip,$(BR2_PACKAGE_MENDER_SERVER_CRT))#g' \
		-e 's/@MENDER_TENANT_TOKEN@/$(call qstrip,$(BR2_PACKAGE_MENDER_TENANT_TOKEN))/' \
		package/mender/mender.conf > $(TARGET_DIR)/etc/mender/mender.conf
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
