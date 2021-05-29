#!/usr/bin/env bash

# This part is from rocky linux conversion script
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
  printf "DNF is optimized: skipping..."
else
  printf "DNF is not optimized: setting fastest mirror..."
  echo 'fastestmirror=1' | tee -a /etc/dnf/dnf.conf
  echo 'max_parallel_downloads=10' | tee -a /etc/dnf/dnf.conf
  echo 'deltarpm=true' | tee -a /etc/dnf/dnf.conf
  echo 'repo_gpgcheck=1' | tee -a /etc/dnf/dnf.conf
fi

if ! type powertop >/dev/null 2>&1; then
  printf '%s\n' "${blue}Powertop is not installed! Installing it...$ncolor"
  dnf install powertop -y
  systemctl enable powertop.service
else
  systemctl enable powertop.service
fi

if ! type meow >/dev/null 2>&1; then
  printf '%s\n' "${blue}Meow is not installed! Installing it...$ncolor"
  dnf install \
  https://github.com/pnmougel/meow/raw/master/release/meow-0.0.1-1.noarch.rpm -y
else
  printf "Meow is installed: skipping..."
fi

if [[ -f "/etc/yum.repos.d/microsoft-prod.repo" ]]; then
  printf "The microsoft repo is enabled: skipping..."
else
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
fi

if [[ -f "/etc/yum.repos.d/vscodium.repo" ]]; then
  printf "The VSCodium repo is enabled: skipping..."
else
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
fi

if [[ -f "/etc/yum.repos.d/virtualbox.repo" ]]; then
  printf "The VirtualBox repo is enabled: skipping..."
else
  rpm --import https://www.virtualbox.org/download/oracle_vbox.asc
  curl https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo \
  | tee /etc/yum.repos.d/virtualbox.repo
fi

if ! type gh >/dev/null 2>&1; then
  printf '%s\n' "${blue}gh is not installed! Installing it...$ncolor"
  curl https://cli.github.com/packages/rpm/gh-cli.repo | \
  tee /etc/yum.repos.d/gh-cli.repo
  dnf insall "gh" -y
else
  printf "gh is installed: skipping..."
fi

if ! type sbt >/dev/null 2>&1; then
  rm -vf /etc/yum.repos.d/bintray-rpm.repo
  curl https://www.scala-sbt.org/sbt-rpm.repo | \
  tee /etc/yum.repos.d/sbt-rpm.repo
  dnf install "*sbt*" -y
else
  printf "gh is installed: skipping..."
fi

if ! type fedy >/dev/null 2>&1; then
  printf '%s\n' "${blue}Enabling fedy...$ncolor"
  dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
  dnf install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted -y
  dnf groupupdate core -y
  dnf copr enable kwizart/fedy -y
  dnf install *fedy* --refresh -y
else
  printf "Fedy is installed"
fi

# dnf copr enable rpmsoftwaremanagement/dnf-nightly

declare -a groups=("gnome*" "workstation-product*" "base-x" "basic*" "firefox"
"custom-environment" "i3*" "kde*" "xfce*" "anaconda-tools" "*office*"
"x86-baremetal-tools multimedia" "core" "*fonts*" "hardware-support" "games"
"admin-tools" "audio" "authoring-and-publishing" "buildsys-build" "cinnamon*"
"developer-workstation-environment" "*development*" "system-tools" "standard"
"sound-and-video" "*internet" "window-managers" "virtualization" "tomcat"
"ruby" "rubyonrails" "php" "python*" "ocaml" "mongodb" "mysql" "mingw32"
"mate*" "perl*" "java*" "graphics" "haskell" "eclipse" "fedora-packager"
"design-suite" "lxqt*" "lxde*" "input-methods" "deepin*" "critical*"
"xmonad*" "sugar*" "pantheon-desktop")
for val in "${groups[@]}"; do
  dnf group install --with-optional $val -b --allowerasing --skip-broken -y
done

declare -a packages=("*qt*" "*kf*" "*kde*" "*gnome*" "optipng*" "keybinder*"
"guake*" "*gimp*" "hub" "*apache*" "*7z*" "*xz*" "gzip*" "gedit*" "*zsh*"
"geany*" "bzip2*" "*brotli*" "lzop*" "zstd*" "fzf*" "maven*" "ant*" "tex*"
"*java*" "code" "rust*" "google-*-fonts" "fira-code-fonts" "cascadia-*" "isl-*"
"jetbrains-mono-*" "neofetch" "htop" "virtualbox*" "gparted" "vlc" "mpv"
"*perl*" "gimp*" "haroopad" "ffmpeg*" "fftw*" "gstreamer*" "timeshift*" "lame*"
"cmake*" "*gdb*" "*keyring*" "dotnet5*" "bat" "dotnet-sdk*" "*gtk*" "*atk*"
"*vtk*" "*wx*" "ruby-*" "*sdl*" "*SDL*" "glfw*" "mpfr*" "cloog*" "*zlib*"
"make" "gmp-*" "bison*" "libmpc*" "flex*" "ccache*" "R-*" "*mingw*" "node*"
"pip*" "npm*" "*dnf*" "*gcc*" "*ldc*" "*ghc*" "mono*" "*coreutil*" "*binutil*"
"*qemu*" "*mscore*" "*php*" "*pypy*" "vscodium" "*rpm*" "*curl*" "*kleo*"
"inkscape*" "scribus*" "wine*" "*aria*" "aspell*" "*lua*" "*clamav*" "*yum*"
"klamav" "*sassc*" "*clang*" "*allegro*" "*llvm*" "*boost*" "*golang*" "*gawk*"
"*expat*" "*fftw*" "*erlang*" "*Gtk*" "ncurses*" "*ocaml*" "PackageKit*"
"*codeblocks*" "*mysql*" "*dbus*" "*glib*" "*fluidsynth*" "*flac*" "*glade*"
 "*lame*" "*nautilus*" "*compiler*" "libomp*")
for val in "${packages[@]}"; do
  dnf install $val -b --allowerasing --skip-broken -y
done

dnf install *VirtualBox* -x VirtualBox-6.1 -y

dnf install git* -b --allowerasing --skip-broken -x git-pull-request -y

dnf install *python* -b --allowerasing --skip-broken -x python3-iso639 -x \
python3-mysqlclient -x python3-glusterfs-api -x python3-py-bcrypt -x \
python3-readability -x python3-ipmi -x edk2-tools-python -x python3-fiona -y

if ! type codelite >/dev/null 2>&1; then
  printf '%s\n' "${blue}Codelite is not installed! Installing it...$ncolor"
  rpm --import https://repos.codelite.org/CodeLite.asc
  dnf install https://repos.codelite.org/rpms-15.0/fedora/33/codelite-15.0.1-1.fc33.x86_64.rpm -y
else
  printf "Codelite is installed: skipping..."
fi

dnf upgrade refresh -y

dnf autoremove -y

dnf remove --duplicates -y

dnf clean packages
