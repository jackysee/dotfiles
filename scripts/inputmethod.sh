#!/bin/sh
gdbus call -e -d org.fcitx.Fcitx -o "/inputmethod" -m "org.fcitx.Fcitx.InputMethod.GetCurrentIM" | awk -F"'" '{print $2}'
