
Debian
====================
This directory contains files used to package wildfired/wildfire-qt
for Debian-based Linux systems. If you compile wildfired/wildfire-qt yourself, there are some useful files here.

## wildfire: URI support ##


wildfire-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install wildfire-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your wildfire-qt binary to `/usr/bin`
and the `../../share/pixmaps/wildfire128.png` to `/usr/share/pixmaps`

wildfire-qt.protocol (KDE)

