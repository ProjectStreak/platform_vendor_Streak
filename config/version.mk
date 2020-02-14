# Copyright (C) 2016-2019 AOSiP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Versioning System
BUILD_DATE ?= $(shell date +%Y%m%d)
TARGET_PRODUCT_SHORT := $(subst derp_,,$(DERP_BUILDTYPE))

DERP_BUILDTYPE ?= Community
AOSIP_BUILD_VERSION := 10
DERP_BUILD_ZIP_TYPE ?= GAPPS

ifeq ($(DERP_BUILD_ZIP_TYPE), VANILLA)
    DERP_BUILD_ZIP_TYPE := VANILLA
endif

ifeq ($(DERP_BUILDTYPE), CI)
    AOSIP_VERSION := $(AOSIP_BUILD_VERSION)-$(DERP_BUILDTYPE)-$(AOSIP_BUILD)-$(shell date -u +%Y%m%d-%H%M)
endif

ifeq ($(FORCE_TIME_STAMP), true)
	ifneq ($(DERP_BUILDTYPE), CI)
		AOSIP_VERSION := $(AOSIP_BUILD_VERSION)-$(DERP_BUILDTYPE)-$(AOSIP_BUILD)-$(shell date -u +%Y%m%d-%H%M)
	endif
endif

ifndef AOSIP_VERSION
    AOSIP_VERSION := $(AOSIP_BUILD_VERSION)-$(DERP_BUILDTYPE)-$(AOSIP_BUILD)-$(BUILD_DATE)
endif

ifneq ($(DERP_BUILD_ZIP_TYPE), GAPPS)
		AOSIP_VERSION := $(AOSIP_VERSION)-$(DERP_BUILD_ZIP_TYPE)
endif

ROM_FINGERPRINT := DerpFest/$(PLATFORM_VERSION)/$(TARGET_PRODUCT_SHORT)/$(shell date -u +%H%M)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
  ro.aosip.build.version=$(AOSIP_BUILD_VERSION) \
  ro.aosip.build.date=$(BUILD_DATE) \
  ro.aosip.buildtype=$(DERP_BUILDTYPE) \
  ro.aosip.fingerprint=$(ROM_FINGERPRINT) \
  ro.aosip.version=$(AOSIP_VERSION) \
  ro.derp.device=$(AOSIP_BUILD) \
  ro.derp.ziptype=$(DERP_BUILD_ZIP_TYPE) \
  ro.modversion=$(AOSIP_VERSION)

ifneq ($(OVERRIDE_OTA_CHANNEL),)
    PRODUCT_PROPERTY_OVERRIDES += \
        aosip.updater.uri=$(OVERRIDE_OTA_CHANNEL)
endif
