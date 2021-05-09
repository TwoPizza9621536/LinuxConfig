#!/bin/sh

sudo hostnamectl set-hostname fedora-vm

echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo
sudo wget -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/config/fedora/34/prod.repo

sudo rpm --import https://www.virtualbox.org/download/oracle_vbox.asc
sudo curl https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo -o /etc/yum.repos.d/virtualbox.repo

sudo rpm --import "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
sudo curl https://download.mono-project.com/repo/centos8-stable.repo | tee /etc/yum.repos.d/mono-centos8-stable.repo

sudo dnf check-update -y

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

sudo dnf install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted -y

sudo dnf groupupdate core -y

sudo dnf group install --with-optional "Administration Tools" "Audio Production" "Multimedia" "Authoring and Publishing" "C Development Tools and Libraries" "Container Management" "D Development Tools and Libraries" "Design Suite" "Development Tools" "Fedora Eclipse" "Editors" "Educational Software" "LibreOffice" "Office/Productivity" "Python Classroom" "Python Science" "Text-based Internet" "Window Managers" "GNOME Desktop Environment" "Graphical Internet" "KDE (K Desktop Environment)" "Fonts" "Games and Entertainment" "Sound and Video" "System Tools" "KDE Plasma Workspaces" "Minimal Install" "Development and Creative Workstation" "Basic Desktop" "Fedora Workstation" "Xfce Desktop" "Fedora Custom Operating System" --best --allowerasing --skip-broken -y

sudo dnf install vscode google-*-fonts fira-code-fonts cascadia-* jetbrains-mono-* neofetch htop virtualbox* gparted vlc mpv gimp* haroopad ffmpeg* fftw* gstreamer* timeshift* lame* cmake* mono-complete mono-basic mono-addins gdb* *keyring* dotnet5* dotnet-sdk* gtk* wx* ruby-* SDL-* glfw-* allegro-* llvm* clang* mpfr-* cloog-* isl-* tex* make bison gmp-* libmpc-* flex ccache R-* qt* kf* kde* mingw* node* python2 python3 pip* npm gcc* ldc ghc* tex* gnome* coreutil* binutil* zsh* dnf* qemu* mscore* --best --allowerasing --skip-broken -y

sudo rpm --import https://repos.codelite.org/CodeLite.asc
sudo rpm -Uvh https://repos.codelite.org/rpms-15.0/fedora/33/codelite-15.0.1-1.fc33.x86_64.rpm

sudo dnf groupupdate --with-optional "Administration Tools" "Audio Production" "Multimedia" "Authoring and Publishing" "C Development Tools and Libraries" "Container Management" "D Development Tools and Libraries" "Design Suite" "Development Tools" "Fedora Eclipse" "Editors" "Educational Software" "LibreOffice" "Office/Productivity" "Python Classroom" "Python Science" "Text-based Internet" "Window Managers" "GNOME Desktop Environment" "Graphical Internet" "KDE (K Desktop Environment)" "Fonts" "Games and Entertainment" "Sound and Video" "System Tools" "KDE Plasma Workspaces" "Minimal Install" "Development and Creative Workstation" "Basic Desktop" "Fedora Workstation" "Xfce Desktop" "Fedora Custom Operating System" --best --allowerasing --skip-broken -y

sudo dnf upgrade -y

sudo dnf autoremove -y

sudo dnf remove --duplicates -y

sudo dnf reinstall google-*-fonts -y
