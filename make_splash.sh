#!/usr/bin/env bash

: '
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
'

## Don't touch these
VERSION="INITIAL"
SPLASH_SCREEN_HEADER=bin/header.img
TWO_BYTES=bin/two_bytes.img
DESTROYED_IMAGE=/tmp/tulip_splash/destroyed.bmp
FASTBOOT_IMAGE=/tmp/tulip_splash/fastboot.bmp
BOOT_IMAGE=/tmp/tulip_splash/boot.bmp
TEMP_FASTBOOT_IMAGE=
TEMP_BOOT_IMAGE=
TEMP_DESTROYED_IMAGE=
OUTPUT_FILE=

function license_message() {
	echo "This software is licensed under:"
	echo "GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>"
	echo
	echo "This is free software; you are free to change and redistribute it."
	echo "There is NO WARRANTY, to the extent permitted by law."
}

function short_message() {
	echo
	echo "Xiaomi Redmi Note 6 Pro (tulip) Splash Creator - Version $VERSION"
	echo "Copyright (C) 2021 - RahulPalXDA"
	echo 
}

function help_usage() {
	echo
	echo "USAGE: $0 -b example/boot.png -f example/fastboot.png -d example/destroyed.png"
	echo
	echo "-b : Boot splash image."
	echo "-f : Fastboot splash image."
	echo "-d : System Destroyed image."
}

function creating_bmps() {
	mkdir /tmp/tulip_splash
	ffmpeg -hide_banner -loglevel quiet -i $TEMP_BOOT_IMAGE -pix_fmt rgb24 -s 1080x2160 -y $BOOT_IMAGE
	ffmpeg -hide_banner -loglevel quiet -i $TEMP_FASTBOOT_IMAGE -pix_fmt rgb24 -s 1080x2160 -y $FASTBOOT_IMAGE
	ffmpeg -hide_banner -loglevel quiet -i $TEMP_DESTROYED_IMAGE -pix_fmt rgb24 -s 1080x2160 -y $DESTROYED_IMAGE
}

function create_splash() {
	echo "STATUS: creating your splash image please wait..."
	if cat $SPLASH_SCREEN_HEADER $BOOT_IMAGE \
		$TWO_BYTES \
		$FASTBOOT_IMAGE \
		$TWO_BYTES \
		$BOOT_IMAGE \
		$TWO_Bytes \
		$DESTROYED_IMAGE > $OUTPUT_FILE ; then
		echo -e "\e[1m\e[32mDone! Your Splash created successfuly.\e[39m\e[0m"
		echo "filename is: $OUTPUT_FILE"
		echo
	else
		echo -e "\e[41m\e[5mOOOF! :\e[25m\e[49m Something Went Wrong!"
		echo
		housekeeping && rm -rf $OUTPUT_FILE
		exit 1
	fi
}

function housekeeping() {
	echo "Cleaning is Running.."
	echo "Done!"
	rm -rf /tmp/tulip_splash/* && rmdir /tmp/tulip_splash
}

for ((i = 1; i < ($#+1); i++)); do
    case "${!i}" in
	-b|--boot)
		((++i))
		TEMP_BOOT_IMAGE="${!i}"
        ;;
	-f|--fastboot)
		((++i))
		TEMP_FASTBOOT_IMAGE="${!i}"
        ;;
	-d|--destroyed)
		((++i))
		TEMP_DESTROYED_IMAGE="${!i}"
        ;;
	-o|--output)
		((++i))
		OUTPUT_FILE="${!i}"
        ;;
	-v|--version)
		short_message
		license_message
		exit 0
		;;
	-h|--help)
		help_usage
		exit 0
		;;
    esac
done

if [[  $TEMP_BOOT_IMAGE && $TEMP_FASTBOOT_IMAGE && $TEMP_DESTROYED_IMAGE && $OUTPUT_FILE ]]; then
	short_message
	echo "INFO: $TEMP_BOOT_IMAGE is choosen for Boot splash."
	echo "INFO: $TEMP_FASTBOOT_IMAGE is choosen for Fastboot splash."
	echo "INFO: $TEMP_DESTROYED_IMAGE is choosen for System Destroyed splash."
	echo
	rm *.img
	creating_bmps
	create_splash
	housekeeping
	exit 0
else
	short_message
	help_usage
fi
