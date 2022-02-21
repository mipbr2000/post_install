#!/bin/bash
clear

# todo: fazer share
# ! sudo ufw allow samba
# ! TODO: repositorio linux mint sendo adicionado, cada vez que se usa a função

# todo: zsh e o-my-zsh
# todo: descobrir se está no notebook ou não para instalar o auto-cpufreq
# todo: set amd virtualization settings


#region VARIABLES
    CURR_DIR=''
    start=''

    UBUNTU_CODENAME=$(cat /etc/os-release | grep -i "UBUNTU_CODENAME=" | awk -F=  '{print $2}')
    VERSION_CODENAME=$(cat /etc/os-release | grep -i "VERSION_CODENAME=" | awk -F=  '{print $2}')
    DISTRO_VERSION_NUMBER=$(cat /etc/os-release | grep -i "VERSION_ID=" | awk -F=  '{print $2}')
    DISTRO_NAME=$(lsb_release -is)
    COMPUTER_NAME=$(uname -n)

    USER_NAME=$SUDO_USER

    BUNDLES_FOLDER=./apps/vmware_horizon
    PACKAGES_FOLDER=./apps/packages
    CONFIGS_FOLDER=./apps/configs
    OTHERS_FOLDER=./apps/others
    FONTS_FOLDER=./apps/fonts

    DOCUMENTS=/home/$USER_NAME/Documents
    DOWNLOADS=/home/$USER_NAME/Downloads
    USER_HOME=/home/$USER_NAME

    #region MIRRORS
        MIRROR_USP=sft.if.usp.br
        MIRROR_LOCAWEB=ubuntu-archive.locaweb.com.br
        MIRROR_UFSCAR=mirror.ufscar.br
        MIRROR_POPSC=mirror.pop-sc.rnp.br
        MIRROR_BR=br.archive.ubuntu.com

        APT_SOURCES_LIST=/etc/apt/sources.list
        OFFICIAL_PACKAGE_REPOSITORIES_LIST=/etc/apt/sources.list.d/official-package-repositories.list

        #mint-archive
    #endregion

    HORIZON_CLIENT_NAME=VMware-Horizon-Client-2111-8.4.0-18957622.x64.bundle

#endregion

#region ARRAYs

    #region PACKAGEs ARRAYs
        declare -a PG_UTILS=(
            software-properties-common
            snapd
            barrier
            deluge
            gnome-disk-utility
            gnutls-bin
            gparted
            plank
            gedit
            tree
            neofetch
            p7zip-full
            p7zip-rar
            bzip2-doc
            cli-common
            clinfo
            openssh-client
            font-manager
        )
        declare -a PG_UTILS2=(
            build-essential
            git
            subversion
            cmake
            libx11-dev
            libxxf86vm-dev
            libxcursor-dev
            libxi-dev
            libxrandr-dev
            libxinerama-dev
            libglew-dev
            dkms
        )
        declare -a PG_PYTHON=(
            python3
            python3-venv
            python3-apt-dbg
            python3-dbg
            python3-dev
            python3-doc
            python3-examples
            python3-pip
            python3-tk
            python3-full
            python3-apt
            virtualenv
            virtualenvwrapper
            idle3
            idle-python3
            libpython3
            libpython3-dbg
            libpython3-dev
            scrot
            software-properties-common
        )
        declare -a PG_SYSTEM_NETWORK=(
            apt-transport-https
            aptitude
            autofs
            cifs-utils
            curl
            dnsmasq-base
            ebtables
            ethstatus
            net-tools
            network-manager
            nfs-common
            ntfs-3g
            samba
            smbfs
            smbnetfs
            synaptic
            wget
            xdotool
        )
        declare -a PG_SHELLS=(
            fish
            zsh
            zsh-theme-powerlevel9k
            tilix
        )
        declare -a PG_EDITORS=(
            featherpad
            geany
            bluefish
        )
        declare -a PG_BACKUP=(
            backintime
            deja-dup
            timeshift
            luckybackup
        )
        declare -a PG_FILE_MANAGERS=(
            nemo
            thunar
        )
        declare -a PG_JRES=(
            openjdk-11-jre
            openjdk-8-jre
        )
        declare -a PG_SPICE_CLIENT=(
            spice-client-glib-usb-acl-helper
            spice-client-gtk
            spice-html5
            spice-vdagent
            spice-webdavd
            xserver-xspice
        )
        declare -a PG_VIRT_MANAGER=(
            bridge-utils
            libguestfs-tools
            libvirt-clients
            libvirt-daemon-system
            libvirt-dev
            libvirt0
            qemu
            qemu-kvm
            ruby-dev
            ruby-libvirt
            virt-manager
            virtinst
            zlib1g-dev
        )
        declare -a PG_VIRTUALBOX=(
            virtualbox
            virtualbox-ext-pack
        )
        declare -a PG_THEMES=(
            breeze
            breeze-cursor-theme
            breeze-gtk-theme
            breeze-icon-theme
            papirus-icon-theme
        )
        declare -a PG_PCSC=(
            gnutls-bin
            libcrypto++-utils
            libcrypto++8
            libp11-3
            libp11-kit0
            libpam-p11
            libpam-pkcs11
            libusb-1.0-0-dev
            opensc-pkcs11
            p11-kit
            p11-kit-modules
            pcsc-tools
            pcscd
        )
        declare -a PG_OTHERS1=(
            dconf-cli
            dconf-editor
            osinfo-db
            partitionmanager
            preload
            smartmontools
        )
        declare -a PG_LIBS=(
            libappindicator1
            libindicator7
            libxss1
        )
        declare -a PG_OTHERS2=(
            gnutls-bin
            kde-cli-tools
            ubuntu-advantage-tools
            ttf-mscorefonts-installer
        )
    #endregion

    #region DIRECTORIES ARRAYs
        declare -a MNT_DIRS=(
            snas
            nas
            ssd
        )
        declare -a DOWNLOADS_SUBDIRS=(
            apps_linux
            apps_windows
            fonts
        )
        declare -a DOCUMENTS_SUBDIRS=(
            scripts/bash
            scripts/python
            scripts/powershell
            docs
            howtos
            imgs
        )
    #endregion

    #region VSCODE EXTENSIONS ARRAYs
        declare -a VS_BASIC=(
            aaron-bond.better-comments
            EmilijanMB.sublime-text-4-theme
            FinnTenzor.change-case
            PKief.material-icon-theme
            SantaCodes.santacodes-region-viewer
            xshrim.txt-syntax
        )

        declare -a VS_BASH=(
            DeepInThought.vscode-shell-snippets
            jeff-hykin.better-shellscript-syntax
            L13RARY.l13-sh-snippets
            mads-hartmann.bash-ide-vscode
            Remisa.shellman
            rogalmic.bash-debug
            tetradresearch.vscode-h2o
        )
    #endregion

#endregion

#region COLORS
function pr_black() {
    echo -e "\e[1;30m$1\e[0m"
}
function pr_red() {
    echo -e "\e[1;31m$1\e[0m"
}
function pr_green() {
    echo -e "\e[1;32m$1\e[0m"
}
function pr_yellow() {
    echo -e "\e[1;33m$1\e[0m"
}
function pr_blue() {
    echo -e "\e[1;34m$1\e[0m"
}
function pr_magenta() {
    echo -e "\e[1;35m$1\e[0m"
}
function pr_cyan() {
    echo -e "\e[1;36m$1\e[0m"
}
function pr_white() {
    echo -e "\e[1;37m$1\e[0m"
}
#endregion

#region GENERAL FUNCTIONS

    function change_to_script_dir() {

        pr_blue "Mudando para o diretório do script."
        RELDIR=$(dirname $0)
        cd $RELDIR
        CURR_DIR=$(pwd)

        pr_green "Diretório é agora: $CURR_DIR"

    }

    function mkdir_if() {

        FOLDER=$1

        if [[ ! -d $FOLDER ]]; then
            pr_yellow "$FOLDER nao existe.Será criado."
            mkdir -p "$FOLDER"
            chown -R "$SUDO_USER:$SUDO_USER $FOLDER"
            chmod -R 775 "$FOLDER"
            pr_green "$FOLDER foi criado."
        else
            pr_yellow "$FOLDER ja existe!"
            pr_red "Não é necessário criar o diretorio: $FOLDER!"
        fi
    }

    function mod_permissions() {
        FILE=$1
        chown -R "$SUDO_USER:$SUDO_USER $FILE"
        chmod -R 775 "$FILE"
    }

    function install_pkg() {
        PKG=$1
        OK=$(dpkg-query -W --showformat='${Status}\n' "$PKG" | grep "install ok installed")

        pr_green "--------------------------------------------"
        pr_blue "---> VERIFICANDO ---> $PKG: $OK"
        pr_green "--------------------------------------------"

        if [ "" = "$OK" ]; then

            set_start_time

            pr_yellow "--------------------------------------------"
            pr_red "-> $PKG não está instalado."
            pr_yellow "--------------------------------------------"

            pr_yellow "--------------------------------------------"
            pr_blue "---> INSTALANDO ---> $PKG: $OK"
            pr_yellow "--------------------------------------------"

            apt install -y "$PKG"

            get_total_spent_time
        fi
    }

    function process_array() {
        ARG1=$1
        shift
        ARRAY=("$@")
        for ARG2 in "${ARRAY[@]}"; do
            eval "$ARG1$ARG2"
        done
    }

    function set_amd_virt_env() {
        mkdir_if /etc/modprobe.d
        mkdir_if /sys/module/kvm/parameters
        KVM_FILE=/etc/modprobe.d/kvm_amd.conf
        QEMU_FILE=/etc/modprobe.d/qemu-system-x86.conf
        KVM_CONF=/etc/modprobe.d/kvm.conf

        rm -f $KVM_FILE
        touch $KVM_FILE

        rm -f $QEMU_FILE
        touch $QEMU_FILE

        rm -f $KVM_CONF
        touch $KVM_CONF

        echo options kvm_amd nested=1 >>$KVM_FILE
        echo options kvm_amd nested=1 >>$KVM_CONF
        echo options kvm ignore_msrs=1 report_ignored_msrs=0 >>$QEMU_FILE
        echo options kvm_amd nested=1 enable_apicv=0 ept=1 >>$QEMU_FILE
        echo 1 | sudo tee /sys/module/kvm/parameters/ignore_msrs
    }
#endregion

#region TIME METER
    function set_start_time() {
        start=$(date +%s.%N)
        pr_green "------------------------------"
        pr_blue "TEMPO: INICIO: $start"
        pr_green "------------------------------"

    }

    function get_total_spent_time() {
        end=$(date +%s.%N)
        runtime=$(echo "$end - $start" | bc -l)
        pr_red "------------------------------"
        pr_green "TEMPO GASTO: $runtime"
        pr_red "------------------------------"
    }

    function start_metered_function() {
        INSTALL_FUNCTION=$1
        set_start_time
        $INSTALL_FUNCTION
        get_total_spent_time
    }
#endregion

#region SET SETTINGS
    function set_samba_firewall(){
        ufw allow samba
    }
    function set_snapd_intall_for_mint (){
        mv /etc/apt/preferences.d/nosnap.pref $DOCUMENTS/nosnap.backup
    }
#endregion

#region CUSTOM INSTALLs
    function install_chrome() {
        wget -nc https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        dpkg -i google-chrome-stable_current_amd64.deb
    }
    #region SNAP Installs
        function install_brave() {
            snap install brave
        }
        function install_vscode() {
            snap install --classic code
        }
        function install_auto_cpufreq() {
            snap install auto-cpufreq
        }
    #endregion

    function install_fonts(){
        fonts_dir="$USER_HOME/.fonts"
        su $USER_NAME -c "mkdir -p $fonts_dir"
        su $USER_NAME -c "cp -rnv ${FONTS_FOLDER}/ ${fonts_dir}"
    }
    function install_vmware_horizon() {
        env TERM=dumb VMWARE_EULAS_AGREED=yes \
            $BUNDLES_FOLDER/$HORIZON_CLIENT_NAME --console \
            --set-setting vmware-horizon-html5mmr html5mmrEnable yes \
            --set-setting vmware-horizon-integrated-printing vmipEnable yes \
            --set-setting vmware-horizon-media-provider mediaproviderEnable yes \
            --set-setting vmware-horizon-teams-optimization teamsOptimizationEnable yes \
            --set-setting vmware-horizon-mmr mmrEnable yes \
            --set-setting vmware-horizon-rtav rtavEnable yes \
            --set-setting vmware-horizon-scannerclient scannerEnable yes \
            --set-setting vmware-horizon-serialportclient serialportEnable yes \
            --set-setting vmware-horizon-smartcard smartcardEnable yes \
            --set-setting vmware-horizon-tsdr tsdrEnable yes \
            --set-setting vmware-horizon-usb usbEnable yes \
            --stop-services
    }
    function install_docker() {

        apt remove -y docker docker-engine docker.io containerd runc

        apt update -y
        apt install -y ca-certificates curl gnupg lsb-release

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
            $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

        apt update -y
        apt install -y docker-ce docker-ce-cli containerd.io

        groupadd docker

        usermod -aG docker $SUDO_USER

        newgrp docker
    }
    function install_vagrant() {
        curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
        apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
        apt-get update && apt-get install -y vagrant
    }
    function install_packages_from_folder() {
        dpkg -i $PACKAGES_FOLDER/*.deb
        apt-get -f install -y
    }
    function install_kavantum(){
        add-apt-repository ppa:papirus/papirus -y
        apt update -y
        apt install qt5-style-kvantum qt5-style-kvantum-themes -y

    }
    #region ZSH - O-MY-ZSH
        function install_omyzsh(){
            apt install zsh-theme-powerlevel9k
            apt install zsh-syntax-highlighting
            sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
            su $USER_NAME -c "echo "source /usr/share/powerlevel9k/powerlevel9k.zsh-theme" >> ~/.zshrc"
            su $USER_NAME -c "echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc"
        }
    #endregion
#endregion

#region MIRROR MANAGEMENT
    function start_metered_add_repositories() {

        MIRROR=$1

        set_start_time
            add_apt_repository $MIRROR
            start_apt_update
        get_total_spent_time

    }

    function reset_sources_list() {
        pr_magenta "REMOVENDO SOURCE LIST E CRIANDO OUTRO VAZIO."

        rm -rf $APT_SOURCES_LIST
        touch $APT_SOURCES_LIST

        rm -rf $OFFICIAL_PACKAGE_REPOSITORIES_LIST
        touch $OFFICIAL_PACKAGE_REPOSITORIES_LIST
    }

    function add_apt_repository() {

        MIRROR=$1

        pr_yellow "-------------- DEFAULTS MIRROR OPERATION --------------------"
        pr_yellow "REALIZANDO add-apt-repository: $MIRROR"
        pr_yellow "UBUNTU_CODENAME: $UBUNTU_CODENAME"
        pr_yellow "VERSION_CODENAME: $VERSION_CODENAME"

        # TODO: aqui tem que ter um if mint:

       if [[ "${DISTRO_NAME^^}" == "LINUXMINT" ]]; then
            add-apt-repository -y "deb http://$MIRROR/mint-archive $VERSION_CODENAME main upstream import backport"
       fi
       
        add-apt-repository -y "deb http://$MIRROR/ubuntu $UBUNTU_CODENAME main restricted universe multiverse"
        add-apt-repository -y "deb http://$MIRROR/ubuntu $UBUNTU_CODENAME-updates main restricted universe multiverse"
        add-apt-repository -y "deb http://$MIRROR/ubuntu $UBUNTU_CODENAME-backports main restricted universe multiverse"

        add-apt-repository -y "deb http://security.ubuntu.com/ubuntu/ $UBUNTU_CODENAME-security main restricted universe multiverse"
        add-apt-repository -y "deb http://archive.canonical.com/ubuntu/ $UBUNTU_CODENAME partner"

    }

    function add_git_ppa() {
        pr_cyan "ADICIONANDO PPA GIT."

        add-apt-repository -y ppa:git-core/ppa
    }

    function start_apt_update() {
        pr_yellow "REALIZANDO APT UPDATE!!!"
        apt update -y
    }
#endregion

#region PROCESSES DIR ARRAYS
    function make_dirs() {

        process_array "mkdir_if $DOCUMENTS/" "${DOCUMENTS_SUBDIRS[@]}"
        process_array "mkdir_if $DOWNLOADS/" "${DOWNLOADS_SUBDIRS[@]}"
        process_array "mkdir_if mnt/" "${MNT_DIRS[@]}"

    }
#endregion

#region Install VS Code Extensions
    function install_vscode_extensions() {
        ARRAY=("$@")
        for EXTENSION_NAME in "${ARRAY[@]}"; do
            su $USER_NAME -c "code --install-extension $EXTENSION_NAME --force"
        done
    }
    function install_vs_extensions_groups() {
        declare -a VSCODE_EXTENSIONS_GROUPS=(
            VS_BASIC
            VS_BASH
        )
        for extension_group in "${VSCODE_EXTENSIONS_GROUPS[@]}"; do
            pr_magenta "Processando grupo:"
            pr_cyan "--- >>> $extension_group"
            pr_yellow "--------------------------------------------"

            typeset -n group=$extension_group
            install_vscode_extensions "${group[@]}"
        done
    }
    function set_vscode_settings(){
        HOT_VSCODE_SETTINGS=$USER_HOME/.config/Code/User/settings.json
        VSCODE_SETTINGS_TXT=$CURR_DIR/apps/configs/vscode_settings.txt
        rm -rf $HOT_VSCODE_SETTINGS
        su $USER_NAME -c "touch $HOT_VSCODE_SETTINGS"
        su $USER_NAME -c "cat $VSCODE_SETTINGS_TXT > $HOT_VSCODE_SETTINGS"
    }    
#endregion

#region INSTALL ARRAY GROUPS
    #region Packages groups names:
        # PG_UTILS
        # PG_UTILS2
        # PG_PYTHON
        # PG_SYSTEM_NETWORK
        # PG_SHELLS
        # PG_EDITORS
        # PG_BACKUP
        # PG_FILE_MANAGERS
        # PG_JRES
        # PG_SPICE_CLIENT
        # PG_VIRT_MANAGER
        # PG_VIRTUALBOX
        # PG_THEMES
        # PG_PCSC
        # PG_OTHERS1
        # PG_OTHERS2
        # PG_LIBS
    #endregion
        function install_packages_groups() {
            declare -a PACKAGE_GROUPS=(
                PG_UTILS
                PG_SHELLS
                PG_EDITORS
                PG_BACKUP
                PG_FILE_MANAGERS
                PG_SPICE_CLIENT
                PG_THEMES
            )
            for group_to_install in "${PACKAGE_GROUPS[@]}"; do
                pr_magenta "Processando grupo:"
                pr_cyan "--- >>> $group_to_install"
                pr_yellow "--------------------------------------------"

                typeset -n group=$group_to_install
                process_array "install_pkg " "${group[@]}"
            done
        }

#endregion

#region Teste de Cores
function start_color_test() {
    pr_black "Testando impressao em cores:"
    pr_red "VERMELHO"
    pr_green "VERDE"
    pr_yellow "AMARELO"
    pr_blue "AZUL"
    pr_magenta "MAGENTA"
    pr_cyan "CIANO"
    pr_white "BRANCO"
    pr_black "PRETO"
}
#endregion

reset_sources_list
set_snapd_intall_for_mint
#
start_metered_add_repositories $MIRROR_USP
start_metered_add_repositories $MIRROR_UFSCAR
#
start_metered_function add_git_ppa
start_metered_function start_apt_update

change_to_script_dir

install_packages_groups

install_fonts
# start_metered_function install_auto_cpufreq
start_metered_function install_brave

install_chrome
# install_vagrant
install_kavantum
# install_vmware_horizon
# install_docker

install_vscode
install_vs_extensions_groups
set_vscode_settings

install_omyzsh
start_metered_function install_packages_from_folder
apt-get -f install -y
