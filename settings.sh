# shellcheck shell=bash disable=2034

# Packages to install
# You can add packages that you want and remove packages that you don't need
# Apart from packages from the official Arch repos, you can also specify
# packages from the Chaotic-AUR repo
PACKAGES=(
	# cli_download_tools
	curl wget aria2 rsync	
	# udisks2_tools
	udiskie udisks2 udisks2-btrfs udisks2-lvm2 udisks2-qt5
	# terminal_emulators
	lxterminal rxvt-unicode xterm
	# text_editors
	vim mousepad
	# pdf_utilities
	evince
	# shell_tools
	zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting dash bash bash-completion
	# compression_cli_tools
	gzip bzip2 pbzip2 xz pixz zip unzip minizip zstd arj unarj lrzsz tar atool pax cpio
	# gui_compression_tools
	file-roller ark
  # qt_dependencies
  qt5ct qt5-base qt5-wayland qt5-tools qt5-declarative qt5-multimedia qt5-x11extras qt5-graphicaleffects qt5-imageformats qt5-location qt5-quickcontrols
	qt5-quickcontrols2 qt5-svg kvantum kvantum-qt5 qt6ct qt6-base qt6-wayland qt6-tools qt6-declarative qt6-multimedia qt6-imageformats
	# input_method_frameworks
	fcitx5 fcitx5-anthy fcitx5-bamboo fcitx5-breeze fcitx5-chewing fcitx5-chinese-addons fcitx5-configtool fcitx5-gtk fcitx5-hangul fcitx5-kkc fcitx5-libthai fcitx5-lua
	fcitx5-m17n fcitx5-material-color fcitx5-nord fcitx5-pinyin-zhwiki fcitx5-qt fcitx5-rime fcitx5-sayura fcitx5-skk fcitx5-table-extra fcitx5-table-other fcitx5-unikey libime
	ibus ibus-anthy ibus-chewing ibus-hangul ibus-kkc ibus-libpinyin ibus-rime ibus-skk ibus-sunpinyin ibus-table ibus-table-chinese ibus-table-extraphrase ibus-typing-booster 
	ibus-unikey rime-bopomofo rime-cangjie rime-double-pinyin rime-emoji rime-essay rime-loengfan rime-luna-pinyin rime-pinyin-simp rime-pinyin-zhwiki rime-prelude rime-quick 
	rime-stroke rime-terra-pinyin rime-wubi rime-wugniu
	# fonts_management_tools
	fontconfig gnome-font-viewer freetype2
	# common_fonts
	ttf-dejavu ttf-droid ttf-dejavu-nerd ttf-liberation ttf-roboto-mono ttf-roboto-mono-nerd wqy-bitmapfont wqy-zenhei wqy-microhei noto-fonts noto-fonts-cjk noto-fonts-emoji
	# desktop_themes
	sound-theme-freedesktop gnome-themes-extra hicolor-icon-theme papirus-icon-theme adwaita-icon-theme adwaita-cursors materia-gtk-theme kvantum-theme-materia
	# spellcheck_tools
	enchant aspell hspell hunspell gspell codespell nuspell
	# wayland_packages
	wayland wayland-protocols wayland-utils xdg-desktop-portal xdg-desktop-portal-gtk
	# xorg_packages
	xorg-server xorg-server-common xorg-server-devel xorg-xinit xorg-xinput xorg-xwayland xorg-server-xephyr xorg-xrandr xorg-xset xorg-xprop xorg-font-util xorg-xkbcomp
	# x11_core_libraries
	libx11 libxslt libxext libxau libxdmcp libxkbcommon libxkbcommon-x11 libxcb libxi libxrandr libxinerama libxcomposite libsm libxrender libxfixes libxdamage libxft libxtst libxv
	# multimedia_tools
	mpv ffmpeg audacity qview feh nsxiv imagemagick gpicview v4l-utils gst-plugins-espeak
	gstreamer gstreamer-vaapi gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-bad-libs gst-plugins-ugly gst-libav
	# file_manager_tools
	libfm-qt tumbler ffmpegthumbnailer libgepub libgsf libopenraw poppler poppler-glib nautilus nautilus-image-converter nautilus-python nautilus-share
	# gvfs_packages
	gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb gvfs-wsdd
	# dbus_packages
	dbus dbus-units dbus-glib xdg-dbus-proxy python-dbus
	# python_dev_tools
	python python-pip python-setuptools python-wheel python-virtualenv python-virtualenvwrapper ipython cython
	# bluetooth_management_packages
	bluez bluez-cups bluez-hid2hci bluez-libs bluez-mesh bluez-obex bluez-tools bluez-utils blueman
	# gtk_packages
	gtk3 gtk4 webkit2gtk webkit2gtk-4.1 glib2
	# gnome_environment_tools
	gnome-tweaks gnome-control-center gnome-system-monitor gnome-disk-utility baobab gnome-settings-daemon gnome-characters gnome-logs
	# openbox_environment
	openbox lxappearance libnotify libxft libvoikko at-spi2-core
	# haskell_libraries
	haskell-bzlib haskell-graphscc haskell-pandoc-lua-engine haskell-pandoc-lua-marshal haskell-alsa-core haskell-alsa-mixer
	# graphics_drivers
	mesa xf86-video-intel xf86-video-amdgpu xf86-video-vesa intel-media-driver libdrm libglvnd libepoxy
	# vulkan_tools
	vulkan-radeon vulkan-intel vulkan-icd-loader vulkan-mesa-layers vulkan-tools mangohud libvpl libvpl-tools openpgl
	# utility_software_packages
	dconf dconf-editor hplip meld psensor speedcrunch cheese qalculate-gtk kcolorchooser bleachbit peek flameshot shutter filezilla
	# video_acceleration
	libva libva-intel-driver vdpauinfo libvdpau libvdpau-va-gl
	# debugging_tools
	mesa-utils libva-utils
	# network_manager
	networkmanager network-manager-applet network-manager-sstp networkmanager-l2tp networkmanager-openconnect networkmanager-openvpn 
	nm-cloud-setup networkmanager-qt5 networkmanager-strongswan networkmanager-vpnc nm-connection-editor
	# multimedia_libs
	libpng libjpeg-turbo giflib mpg123 libgphoto2
	# alsa_packages
	alsa-card-profiles alsa-lib alsa-oss alsa-plugins alsa-scarlett-gui alsa-tools alsa-topology-conf alsa-ucm-conf alsa-utils
	# pulseaudio_packages
	pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol pamixer pasystray libpulse easyeffects lsp-plugins
	# audio_drivers_libraries
	libldac sbc libfreeaptx openal libsndfile libsamplerate libcanberra libsoxr libasyncns libvorbis
	# network_management_tools
	net-tools traceroute iperf libnm dhclient wireless_tools wpa_supplicant iw iwd nethogs iftop hostapd bridge-utils ethtool dnsmasq inetutils netctl dhcpcd
	# security_tools
	openssh openssl lxqt-openssh-askpass openvpn iptables squid gnutls libldap qrencode haveged nmap tcpdump
	# file_system_tools
	attr cryptsetup smartmontools parted gparted lvm2 fsarchiver gsmartcontrol ntfs-3g exfatprogs jfsutils util-linux dosfstools e2fsprogs 
	btrfs-progs xfsprogs cifs-utils mdadm
	# network_file_systems
	samba nfs-utils mkinitcpio-nfs-utils avahi sshfs
	# cli_utilities
	tmux screen bat bat-extras ripgrep fzf lsd shellcheck mcfly fd ncdu inxi jq lf tree which cmatrix usbutils pciutils less findutils psmisc procps-ng expect zoxide
	# desktop_utilities
	desktop-file-utils xdotool arandr xclip xsel xbindkeys numlockx zenity xdg-utils xdg-user-dirs dmenu rofi nwg-drawer dunst
	# base_utilities
	polkit expat filesystem coreutils shadow libffi libxml2 gettext ncurses file duktape cairo vorbis-tools libxcrypt-compat
	# remote_utilities
	remmina freerdp spice spice-vdagent spice-protocol spice-gtk libvncserver x11vnc wayvnc gtk-vnc kwallet5 libsecret virt-viewer
	# cli_system_info_tools
	clinfo hwinfo lshw lm_sensors chromium
)

# If you want to install AUR packages, specify them in this variable
AUR_PACKAGES=()

# ALHP is a repository containing packages from the official Arch Linux
# repos recompiled with -O3, LTO and optimizations for modern CPUs for
# better performance
#
# When this repository is enabled, most of the packages from the official
# Arch Linux repos will be replaced with their optimized versions from ALHP
#
# Set this variable to any value if you want to enable this repository
ENABLE_ALHP_REPO=

# Feature levels for ALHP. Available feature levels are 2 and 3
# For level 2 you need a CPU with SSE4.2 instructions
# For level 3 you need a CPU with AVX2 instructions
ALHP_FEATURE_LEVEL=2

# Locales to configure in the image
LOCALES=(
	'ar_EG.UTF-8 UTF-8'
	'en_US.UTF-8 UTF-8'
	'en_GB.UTF-8 UTF-8'
	'en_CA.UTF-8 UTF-8'
	'en_SG.UTF-8 UTF-8'
	'es_MX.UTF-8 UTF-8'
	'zh_CN.UTF-8 UTF-8'
	'fr_FR.UTF-8 UTF-8'
	'ru_RU.UTF-8 UTF-8'
	'ru_UA.UTF-8 UTF-8'
	'es_ES.UTF-8 UTF-8'
	'de_DE.UTF-8 UTF-8'
	'pt_BR.UTF-8 UTF-8'
	'it_IT.UTF-8 UTF-8'
	'id_ID.UTF-8 UTF-8'
	'ja_JP.UTF-8 UTF-8'
	'bg_BG.UTF-8 UTF-8'
	'pl_PL.UTF-8 UTF-8'
	'da_DK.UTF-8 UTF-8'
	'ko_KR.UTF-8 UTF-8'
	'tr_TR.UTF-8 UTF-8'
	'hu_HU.UTF-8 UTF-8'
	'cs_CZ.UTF-8 UTF-8'
	'bn_IN UTF-8'
	'hi_IN UTF-8'
)

# Content of pacman mirrorrlist file before reflector is installed and used to fetch new one
# shellcheck disable=2016
MIRRORLIST='
Server = https://mirror.osbeck.com/archlinux/$repo/os/$arch
Server = https://london.mirror.pkgbuild.com/$repo/os/$arch
Server = https://mirror.trap.moe/archlinux/$repo/os/$arch
Server = https://archlinux.thaller.ws/$repo/os/$arch
Server = https://de.arch.mirror.kescher.at/$repo/os/$arch
Server = https://mirror.cyberbits.eu/archlinux/$repo/os/$arch
Server = https://arch.jensgutermuth.de/$repo/os/$arch
Server = https://fastly.mirror.pkgbuild.com/$repo/os/$arch
Server = https://mirror.lcarilla.de/archlinux/$repo/os/$arch
Server = https://mirror.moson.org/arch/$repo/os/$arch
Server = https://arch.phinau.de/$repo/os/$arch
Server = https://mirrors.atviras.lt/archlinux/$repo/os/$arch
Server = https://ro.arch.niranjan.co/$repo/os/$arch
Server = https://ams.nl.mirrors.bjg.at/arch/$repo/os/$arch
Server = https://mirror.ubrco.de/archlinux/$repo/os/$arch
Server = https://archlinux.uk.mirror.allworldit.com/archlinux/$repo/os/$arch
'

# Enable this variable to use the system-wide mksquashfs/mkdwarfs instead
# of those provided by the Conty project
USE_SYS_UTILS=0

# Supported compression algorithms: lz4, zstd, gzip, xz, lzo
# These are the algorithms supported by the integrated squashfuse
# However, your squashfs-tools (mksquashfs) may not support some of them
SQUASHFS_COMPRESSOR="zstd"
SQUASHFS_COMPRESSOR_ARGUMENTS=(-b 1M -comp "${SQUASHFS_COMPRESSOR}" -Xcompression-level 19)

# Uncomment these variables if your mksquashfs does not support zstd or
# if you want faster compression/decompression (at the cost of compression ratio)
#SQUASHFS_COMPRESSOR="lz4"
#SQUASHFS_COMPRESSOR_ARGUMENTS=(-b 256K -comp "${SQUASHFS_COMPRESSOR}" -Xhc)

# Set to any value to Use DwarFS instead of SquashFS
USE_DWARFS=1
DWARFS_COMPRESSOR_ARGUMENTS=(
	-l7 -C zstd:level=19 --metadata-compression null
	-S 22 -B 1 --order nilsimsa
	-W 12 -w 4 --no-history-timestamps --no-create-timestamp
)

# Specify the proxy server that you want to use to download files and packages
# This can be specified like protocol://address (for example, socks5://127.0.0.1)
DOWNLOAD_PROXY=

# List of links to arch bootstrap archive
# Conty will try to download each one of them sequentially
BOOTSTRAP_DOWNLOAD_URLS=(
	'https://umea.mirror.pkgbuild.com/iso/latest/archlinux-bootstrap-x86_64.tar.zst'
	'https://de.arch.mirror.kescher.at/iso/latest/archlinux-bootstrap-x86_64.tar.zst'
	'https://de.arch.niranjan.co/iso/latest/archlinux-bootstrap-x86_64.tar.zst'
	'https://mirror.moson.org/arch/iso/latest/archlinux-bootstrap-x86_64.tar.zst'
	'https://fastly.mirror.pkgbuild.com/iso/latest/archlinux-bootstrap-x86_64.tar.zst'
)

# sha256sums.txt file to verify downloaded bootstrap archive with
BOOTSTRAP_SHA256SUM_FILE_URL='https://umea.mirror.pkgbuild.com/iso/latest/sha256sums.txt'

# Set to any value to use an existing image if it exists
# Otherwise the script will always create a new image
USE_EXISTING_IMAGE=
