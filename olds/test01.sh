UBUNTU_CODENAME=$(cat /etc/os-release | grep -i "UBUNTU_CODENAME=" | awk -F=  '{print $2}')
VERSION_CODENAME=$(cat /etc/os-release | grep -i "VERSION_CODENAME=" | awk -F=  '{print $2}')
DISTRO_VERSION_NUMBER=$(cat /etc/os-release | grep -i "VERSION_ID=" | awk -F=  '{print $2}')
DISTRO_NAME=$(lsb_release -is)
COMPUTER_NAME=$(uname -n)

if [[ "${DISTRO_NAME^^}" == "LINUXMINT" ]]; then
            echo "sao iguais"
fi