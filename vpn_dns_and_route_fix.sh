#/usr/bin/env bash
printf "\n\n"
red=$'\e[1;31m'
grn=$'\e[1;32m'
end=$'\e[0m'


interface_name="utun2"
chck_internet_host="google.ru"
excpt_internet_gateway=$(netstat -rn | ggrep -Pzo '(?<=default)\s*[\d\.]*(?=\s)' | awk '{print $1}')

hostname_rdp="WS1111"
ip_rdp_host=$(nslookup "$hostname_rdp" | ggrep -Pzo '(?si)(?<=answer).*' | ggrep -Pzo '(?<=Address: )[\.\d]*') # || printf "\n\nError resolve $hostname_rdp to ip\n" && exit
gateway_rdp_host=$(route -n get "$ip_rdp_host" | grep gateway | awk '{print $2}')


chck_strs() {
    read -ra rslt_chck_arr <<< "$1" #split str to array
    err_flag=0
    #printf "\n\nDEBUG ${rslt_chck_arr[1]} =~ $2\n\n"
    if [[ ! -z "${rslt_chck_arr[1]}" && "${rslt_chck_arr[1]}" =~ "$2" ]]; then
        rslt_chck_arr[0]="${grn}${rslt_chck_arr[0]}${end}"
    else
        rslt_chck_arr[0]="${red}${rslt_chck_arr[0]}${end}"
        err_flag=1
    fi

    printf "\t\t${rslt_chck_arr[*]}\n"
    # [[ $err_flag != 0 ]] && printf "\nAny key to continue\n" && read
}

chck_route() {
    # chck_route destination gateway [interface]
    printf "\t$1:\n"
    rslt=$(route -n get "$1" | grep "gateway.*$" | awk '{$1=$1;print}') # awk remove traling and leading space
    chck_strs "$rslt" "$2"
    if [[ ! -z $3 ]]; then
        rslt=$(route -n get "$1" | grep "interface.*$" | awk '{$1=$1;print}') # awk remove traling and leading space
        chck_strs "$rslt" "$3"
    fi
}

chck_dns() {
    # chck_dns destination dns_server
    printf "\t$1:\n"
    rslt=$(nslookup "$1" | grep "Server.*$" | awk '{$1=$1;print}')
    chck_strs "$rslt" "$2"
}

chck_resolvconf(){
    # chck_resolvconf dns_server
    printf "\t/etc/resolv.conf:\n"
    rslt_chck=$(cat /etc/resolv.conf | grep "nameserver.*$" | awk '{$1=$1;print}')
    chck_strs "$rslt" "$1"
}

chck_all() {
    printf "\n"
    printf "\nCheck route: \n"
    chck_route "$chck_internet_host" "$excpt_internet_gateway"
    chck_route "$ip_rdp_host" "$gateway_rdp_host" "$interface_name"

    printf "\nCheck dns:\n"
    chck_dns "$chck_internet_host" "$excpt_internet_gateway"
    chck_resolvconf "$excpt_internet_gateway"
}


# ================================
# ============= MAIN =============
# ================================
chck_all
printf "\nCheck var:\n\tRDP_gateway:\n"
chck_strs "RDP_gateway: $gateway_rdp_host" ".*"

printf "\nCheckpoint has been launched. Press any key to fix routes and dns.\n"
read

printf "\n\nFix routes:\n"
netstat -rn | grep $interface_name | awk '{print $1" "$2"\n"}' | xargs -n2 sudo route -n delete -net
netstat -rn | grep $interface_name | awk '{print $1" "$2"\n"}' | xargs -n2 sudo route -n delete
sudo route -n add -host "$ip_rdp_host" -interface "$interface_name"

printf "\n\nFix dns:\n"
networksetup -setdnsservers Wi-Fi "$excpt_internet_gateway"
networksetup -setsearchdomains Wi-Fi ""

chck_all

printf "\n\nThat's all\n"