#!/bin/bash
clear

#region VARIABLES
    CURR_DIR=''
    start=''

    CODENAME=$(lsb_release -cs)

    USER_NAME=$SUDO_USER

    BUNDLES=./apps/vm
    DEBS=./apps/packages
    PATCHES=./apps/configs
    TGZ=./apps/others

    DOCUMENTS=/home/$USER_NAME/Documents
    DOWNLOADS=/home/$USER_NAME/Downloads

    MIRROR_POPSC=mirror.pop-sc.rnp.br
    MIRROR_UFPR=ubuntu.c3sl.ufpr.br
    MIRROR_BR=br.archive.ubuntu.com

    HORIZON_CLIENT_NAME=VMware-Horizon-Client-2111-8.4.0-18957622.x64.bundle

#endregion

#region PACKAGEs ARRAYs
    declare -a PG_UTILS=(
        software-properties-common
        snapd
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
        gedit
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
        tree
        neofetch
        p7zip-full
        p7zip-rar
        bzip2-doc
        cli-common
        clinfo
        dconf-cli
        dconf-editor
        font-manager
        openssh-client
        osinfo-db
        partitionmanager
        plank
        preload
        smartmontools
    )
    declare -a PG_LIBS=(
        libappindicator1
        libindicator7
        libxss1
    )
    declare -a PG_OTHERS2=(
        barrier
        deluge
        gnome-disk-utility
        gnutls-bin
        gparted
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

    function change_to_script_dir(){

        pr_blue "Mudando para o diretório do script."
        RELDIR=`dirname $0`
        cd $RELDIR
        CURR_DIR=`pwd`

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
        ARG1=$1; shift
        ARRAY=("$@")
        for ARG2 in "${ARRAY[@]}"; do
            eval "$ARG1$ARG2"
        done
    }

    function set_amd_virt_env(){
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
         
        echo options kvm_amd nested=1 >> $KVM_FILE
        echo options kvm_amd nested=1 >> $KVM_CONF
        echo options kvm ignore_msrs=1 report_ignored_msrs=0 >> $QEMU_FILE
        echo options kvm_amd nested=1 enable_apicv=0 ept=1 >> $QEMU_FILE
        echo 1 | sudo tee /sys/module/kvm/parameters/ignore_msrs
    }
#endregion

#region TIME METER
    function set_start_time(){
        start=`date +%s.%N`
        pr_green "------------------------------"
        pr_blue "TEMPO: INICIO: $start"
        pr_green "------------------------------"

    }

    function get_total_spent_time(){
        end=`date +%s.%N`
        runtime=$( echo "$end - $start" | bc -l )
        pr_red "------------------------------"
        pr_green "TEMPO GASTO: $runtime"
        pr_red "------------------------------"
    }

    function start_metered_function(){
        INSTALL_FUNCTION=$1
        set_start_time
            $INSTALL_FUNCTION
        get_total_spent_time
    }
#endregion

#region CUSTOM INSTALLs 
    function install_chrome() {
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        dpkg -i google-chrome-stable_current_amd64.deb
    }
    #region SNAP Installs
        function install_brave(){
            snap install brave
        }
        function install_vscode(){
            snap install --classic code
        }
        function install_auto_cpufreq(){
            snap install auto-cpufreq
        }
    #endregion
    #region Install VS Code Extensions
        function install_vscode_extensions(){
            declare -a VSCODE_EXTENSIONS=(
                    EmilijanMB.sublime-text-4-theme
                    FinnTenzor.change-case
                    LuisGalicia.mariana-nord
                    ms-python.python
                    ms-python.vscode-pylance
                    ms-toolsai.jupyter
                    ms-toolsai.jupyter-keymap
                    ms-toolsai.jupyter-renderers
                    PKief.material-icon-theme
                    rogalmic.bash-debug
                )
            for EXTENSION_NAME in "${VSCODE_EXTENSIONS[@]}"; do
                code --install-extension EXTENSION_NAME
            done

        }    
    #endregion
    function install_vmware_horizon(){
        env TERM=dumb VMWARE_EULAS_AGREED=yes \
        $BUNDLES/$HORIZON_CLIENT_NAME --console \
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
    function install_docker(){

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
    function install_vagrant(){
        curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
        apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
        apt-get update && apt-get install -y vagrant
    }
    function install_packages_from_folder(){
        dpkg -i ./apps/debs/*.deb
        apt-get -f install -y
    }
#endregion

#region MIRRORS
    function start_metered_add_mirror(){
        MIRROR=$1
        set_start_time
        add_mirrors_to_source_list $MIRROR
        start_apt_update
        get_total_spent_time
    }

    function reset_sources_list(){
        pr_magenta "REMOVENDO SOURCE LIST E CRIANDO OUTRO VAZIO."
        rm -rf /etc/apt/sources.list
        touch /etc/apt/sources.list
    }

    function add_apt_repository(){

        MIRROR=$1

        pr_blue "REALIZANDO add-apt-repository: $MIRROR"
        
        add-apt-repository -y "deb http://$MIRROR/ubuntu/ impish universe"
        add-apt-repository -y "deb http://$MIRROR/ubuntu/ impish main restricted"
        add-apt-repository -y "deb http://$MIRROR/ubuntu/ impish-updates main restricted"
        add-apt-repository -y "deb http://$MIRROR/ubuntu/ impish-updates universe"
        add-apt-repository -y "deb http://$MIRROR/ubuntu/ impish multiverse"
        add-apt-repository -y "deb http://$MIRROR/ubuntu/ impish-updates multiverse"
        add-apt-repository -y "deb http://$MIRROR/ubuntu/ impish-backports main restricted universe multiverse"

    }

    function add_apt_security(){

        pr_blue "REALIZANDO add-apt-repository: SECURITY MIRRORS"
        
        add-apt-repository -y "deb http://security.ubuntu.com/ubuntu impish-security main restricted"
        add-apt-repository -y "deb http://security.ubuntu.com/ubuntu impish-security universe"
        add-apt-repository -y "deb http://security.ubuntu.com/ubuntu impish-security multiverse"
    }
    
    function add_git_ppa(){
        pr_cyan "ADICIONANDO PPA GIT."

        add-apt-repository -y ppa:git-core/ppa
    }

    function add_mirrors_to_source_list(){

        MIRROR=$1
        pr_magenta "ADICIONANDO AO sources.list: $MIRROR"
        echo deb http://$MIRROR/ubuntu/ impish main restricted >> /etc/apt/sources.list
        echo deb http://$MIRROR/ubuntu/ impish-updates main restricted >> /etc/apt/sources.list
        echo deb http://$MIRROR/ubuntu/ impish universe >> /etc/apt/sources.list
        echo deb http://$MIRROR/ubuntu/ impish-updates universe >> /etc/apt/sources.list
        echo deb http://$MIRROR/ubuntu/ impish multiverse >> /etc/apt/sources.list
        echo deb http://$MIRROR/ubuntu/ impish-updates multiverse >> /etc/apt/sources.list
        echo deb http://$MIRROR/ubuntu/ impish-backports main restricted universe multiverse >> /etc/apt/sources.list

    }

    function add_security_to_source_list(){
        pr_magenta "ADICIONANDO AO sources.list: SECURITY MIRRORS"
        echo deb http://security.ubuntu.com/ubuntu impish-security main restricted >> /etc/apt/sources.list
        echo deb http://security.ubuntu.com/ubuntu impish-security universe >> /etc/apt/sources.list
        echo deb http://security.ubuntu.com/ubuntu impish-security multiverse >> /etc/apt/sources.list
    }

    function start_apt_update(){
        pr_yellow "REALIZANDO APT UPDATE!!!"
        apt update -y
    }
#endregion

#region PROCESSES ARRAYS
    function make_dirs(){

        process_array "mkdir_if $DOCUMENTS/" "${DOCUMENTS_SUBDIRS[@]}"
        process_array "mkdir_if $DOWNLOADS/" "${DOWNLOADS_SUBDIRS[@]}"
        process_array "mkdir_if mnt/" "${MNT_DIRS[@]}"

    }
    #region INSTALL PACKAGEs GROUPS
        # Packages groups:  
            # PG_UTILS
            # PG_PYTHON
            # PG_SYSTEM_NETWORK
            # PG_SHELLS
            # PG_EDITORS
            # PG_BACKUP
            # PG_FILE_MANAGERS
            # PG_JRES
            # PG_VIRT_MANAGER
            # PG_VIRTUALBOX
            # PG_THEMES
            # PG_PCSC
            # PG_OTHERS1
            # PG_OTHERS2
            # PG_LIBS
    function install_packages_groups(){
        declare -a PACKAGE_GROUPS=(
            PG_UTILS
            PG_PYTHON
            PG_SYSTEM_NETWORK
            PG_SHELLS
            PG_EDITORS
            PG_BACKUP
            PG_FILE_MANAGERS
            PG_JRES
            PG_VIRT_MANAGER
            PG_VIRTUALBOX
            PG_THEMES
            PG_PCSC
            PG_OTHERS1
            PG_OTHERS2
            PG_LIBS
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
#endregion

#region Teste de Cores
    function start_color_test(){
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


# reset_sources_list

# start_metered_add_mirror $MIRROR_POPSC
# start_metered_add_mirror $MIRROR_UFPR
# start_metered_add_mirror $MIRROR_BR

# start_metered_function add_security_to_source_list

# start_metered_function add_git_ppa
# start_metered_function start_apt_update

# change_to_script_dir

install_packages_groups

# install_vmware_horizon
# install_chrome
# start_metered_function install_auto_cpufreq
# start_metered_function install_brave
# install_vscode
# install_vscode_extensions
# install_docker
# install_vagrant

# start_metered_function install_packages_from_folder
# apt-get -f install -y