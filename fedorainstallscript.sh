#!/usr/bin/env bash

nocolor=$(tput op)

if [[ "$(id -u)" -ne 0 ]]; then
  printf '%s\n' "$errcolor" "You must run this script as root.$nocolor" \
      "${errcolor}Either use sudo or 'su -c ${0}'$nocolor"
fi

if ! type curl >/dev/null 2>&1; then
  printf '%s\n' "${blue}Curl is not installed! Installing it...$nocolor"
  dnf -y install curl libcurl
fi

hostnamectl set-hostname fedora-vm

echo 'fastestmirror=1' | tee -a /etc/dnf/dnf.conf
echo 'max_parallel_downloads=10' | tee -a /etc/dnf/dnf.conf
echo 'deltarpm=true' | tee -a /etc/dnf/dnf.conf

rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo
curl https://packages.microsoft.com/config/fedora/34/prod.repo | tee /etc/yum.repos.d/microsoft-prod.repo

rpm --import https://www.virtualbox.org/download/oracle_vbox.asc
curl https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo | tee /etc/yum.repos.d/virtualbox.repo

rpm --import "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
curl https://download.mono-project.com/repo/centos8-stable.repo | tee /etc/yum.repos.d/mono-centos8-stable.repo

curl https://cli.github.com/packages/rpm/gh-cli.repo | tee /etc/yum.repos.d/gh-cli.repo

rm -f /etc/yum.repos.d/bintray-rpm.repo
curl https://www.scala-sbt.org/sbt-rpm.repo | tee /etc/yum.repos.d/sbt-rpm.repo

dnf check-update

dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

dnf install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted -y

dnf groupupdate core -y

dnf group install --with-optional "Administration Tools" "Audio Production" "Multimedia" "Authoring and Publishing" "C Development Tools and Libraries" "Container Management" "D Development Tools and Libraries" "Design Suite" "Development Tools" "Fedora Eclipse" "Editors" "Educational Software" "LibreOffice" "Office/Productivity" "Python Classroom" "Python Science" "Text-based Internet" "Window Managers" "GNOME Desktop Environment" "Graphical Internet" "KDE (K Desktop Environment)" "Fonts" "Games and Entertainment" "Sound and Video" "System Tools" "KDE Plasma Workspaces" "Minimal Install" "Development and Creative Workstation" "Basic Desktop" "Fedora Workstation" "Xfce Desktop" "Fedora Custom Operating System" --best --allowerasing --skip-broken -y

dnf install optipng keybinder* glade* gh hub *apache* sbt *7z* xz* gzip* gedit* geany* bzip2* brotli* lzop* zstd* fzf* vtk* maven* ant* *java* code google-*-fonts fira-code-fonts cascadia-* jetbrains-mono-* neofetch htop virtualbox* gparted vlc mpv gimp* haroopad ffmpeg* fftw* gstreamer* timeshift* lame* cmake* mono-complete mono-basic mono-addins gdb* *keyring* dotnet5* dotnet-sdk* gtk* wx* ruby-* SDL-* glfw-* allegro-* llvm* clang* mpfr-* cloog-* isl-* tex* make bison gmp-* libmpc-* flex ccache R-* qt* kf* kde* mingw* node* python2 python3 pip* npm gcc* ldc ghc* tex* gnome* coreutil* binutil* zsh* dnf* qemu* mscore* pipy* --best --allowerasing --skip-broken -y

rpm --import https://repos.codelite.org/CodeLite.asc
rpm -Uvh https://repos.codelite.org/rpms-15.0/fedora/33/codelite-15.0.1-1.fc33.x86_64.rpm

dnf upgrade refresh -y

dnf autoremove -y

dnf remove --duplicates -y

dnf reinstall google-*-fonts -y
