#!/usr/bin/env bash

errcolor=$(tput setaf 1)
nocolor=$(tput op)
blue=$(tput setaf 4)

if [[ "$(id -u)" -ne 0 ]]; then
  printf '%s\n' "$errcolor" "You must run this script as root.$nocolor" \
      "${errcolor}Either use sudo or 'su -c ${0}'$nocolor"
fi

if ! type curl >/dev/null 2>&1; then
  printf '%s\n' "${blue}Curl is not installed! Installing it...$nocolor"
  dnf -y install curl libcurl
fi

if [ ! -z $(grep "repo_gpgcheck=1" "/etc/dnf/dnf.conf") ]; then
  :
else
  echo 'fastestmirror=1' | tee -a /etc/dnf/dnf.conf
  echo 'max_parallel_downloads=10' | tee -a /etc/dnf/dnf.conf
  echo 'deltarpm=true' | tee -a /etc/dnf/dnf.conf
  echo 'repo_gpgcheck=1' | tee -a /etc/dnf/dnf.conf
if

if ! type powertop >/dev/null 2>&1; then
  printf '%s\n' "${blue}Powertop is not installed! Installing it...$ncolor"
  dnf -y powertop
  systemctl enable powertop.service
else
  systemctl enable powertop.service
fi

dnf install \
https://github.com/pnmougel/meow/raw/master/release/meow-0.0.1-1.noarch.rpm -y

rpm --import https://packages.microsoft.com/keys/microsoft.asc
cat << EOF | tee /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc

EOF
curl https://packages.microsoft.com/config/fedora/34/prod.repo | tee \
/etc/yum.repos.d/microsoft-prod.repo

rpm --import \
https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg

cat << EOF | tee -a /etc/yum.repos.d/vscodium.repo
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg

EOF

rpm --import https://www.virtualbox.org/download/oracle_vbox.asc
curl https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo | \
tee /etc/yum.repos.d/virtualbox.repo

curl https://cli.github.com/packages/rpm/gh-cli.repo | \
tee /etc/yum.repos.d/gh-cli.repo

rm -vf /etc/yum.repos.d/bintray-rpm.repo
curl https://www.scala-sbt.org/sbt-rpm.repo | tee /etc/yum.repos.d/sbt-rpm.repo

dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

dnf install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted -y

dnf groupupdate core -y

dnf copr enable kwizart/fedy

dnf copr enable rpmsoftwaremanagement/dnf-nightly

dnf update refresh -y

groups=("Administration Tools" "Audio Production" "Multimedia"
"Authoring and Publishing" "C Development Tools and Libraries"
"Container Management" "D Development Tools and Libraries" "Design Suite"
"Development Tools" "Fedora Eclipse" "Editors" "Educational Software" "Fonts"
"LibreOffice" "Office/Productivity" "Python Classroom" "Python Science"
"Text-based Internet" "Window Managers" "GNOME Desktop Environment"
"Graphical Internet" "KDE (K Desktop Environment)" "Games and Entertainment"
"Sound and Video" "System Tools" "KDE Plasma Workspaces" "Minimal Install"
"Development and Creative Workstation" "Basic Desktop" "Fedora Workstation"
"Xfce Desktop" "Fedora Custom Operating System" "MATE Applications")
for val in "${groups[@]}"; do
  dnf group install --with-optional $val -b --allowerasing --skip-broken -y
done

packages=("qt*" "kf*" "kde*" "gnome*" "optipng*" "keybinder*" "guake*" "glade*"
"gh" "hub" "*apache*" "sbt" "*7z*" "xz*" "gzip*" "gedit*" "geany*" "bzip2*"
"brotli*" "lzop*" "zstd*" "fzf*" "vtk*" "maven*" "ant*" "*java*" "code" "rust*"
"google-*-fonts" "fira-code-fonts" "cascadia-*" "jetbrains-mono-*" "neofetch"
"htop" "virtualbox*" "gparted" "vlc" "mpv" "gimp*" "haroopad" "ffmpeg*" "fftw*"
"gstreamer*" "timeshift*" "lame*" "cmake*" "gdb*" "*keyring*" "dotnet5*" "bat"
"dotnet-sdk*" "gtk*" "wx*" "ruby-*" "SDL*" "glfw-*" "allegro-*" "llvm*" "clang*"
"mpfr-*" "cloog-*" "isl-*" "tex*" "make" "bison*" "gmp-*" "libmpc-*" "flex*"
"ccache*" "R-*" "mingw*" "node*" "pip*" "npm*" "gcc*" "ldc*" "ghc*" "mono*"
"coreutil*" "binutil*" "zsh*" "dnf*" "qemu*" "mscore*" "pypy*" "vscodium"
"*rpm*" "*curl*" "*kleo*" "fedy" "inkscape*" "scribus*" "wine*" "aria*"
"lua*" "*clamav*" "klamav" "*sassc*")
for val in "${packages[@]}"; do
  dnf install $val -b --allowerasing --skip-broken -y
done

addionalpkgs=("*qt*" "*kf*" "*kde*")
for val in "${addionalpkgs[@]}"; do
  dnf install $val -b --allowerasing --skip-broken -x *lib* -y
done

dnf install *VirtualBox* -x VirtualBox-6.1 -y

dnf install *lib* -b --allowerasing --skip-broken -x libcouchbase-tools -x \
xorg-x11-drv-nvidia-390xx-libs -x glibc-headers-s390 -x \
xorg-x11-drv-nvidia-390xx-cuda-libs -x libblocksruntime-devel -x \
xorg-x11-drv-nvidia-340xx-libs -x librcc -y

dnf install git* -b --allowerasing --skip-broken -x git-pull-request -y

dnf install *python* -b --allowerasing --skip-broken -x python3-iso639 -x \
python3-mysqlclient -x python3-glusterfs-api -x python3-py-bcrypt -x \
python3-readability -x python3-ipmi -x edk2-tools-python -x python3-fiona -y

rpm --import https://repos.codelite.org/CodeLite.asc
dnf install https://repos.codelite.org/rpms-15.0/fedora/33/codelite-15.0.1-1.fc33.x86_64.rpm -y

dnf upgrade refresh -y

dnf autoremove -y

dnf remove --duplicates -y

dnf clean packages

