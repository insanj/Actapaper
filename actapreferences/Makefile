TARGET=:clang
ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = ActaPreferences
ActaPreferences_FILES = ActaPreferences.xm
ActaPreferences_INSTALL_PATH = /Library/PreferenceBundles
ActaPreferences_FRAMEWORKS = UIKit Twitter
ActaPreferences_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ActaPreferences.plist$(ECHO_END)

internal-after-install::
	install.exec "killall -9 backboardd"