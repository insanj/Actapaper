THEOS_PACKAGE_DIR_NAME = debs
TARGET=:clang
ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = Actapaper
Actapaper_OBJC_FILES = Actapaper.xm Actasender.m NWURLConnection.m
Actapaper_FRAMEWORKS = Foundation UIKit
Actapaper_LDFLAGS = -lactivator -Ltheos/lib

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk

SUBPROJECTS += actapreferences
include $(THEOS_MAKE_PATH)/aggregate.mk