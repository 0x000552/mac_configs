#/usr/bin/env bash
# set -x
# TODO add check for scutil --dns and multiline resolv.conf

resolve_dns() {
  resolved_ip="$(dig +short +time=3 +tries=1 "$1" | ggrep -Pm 1 "(?<=^\d).*")"
  echo "$resolved_ip"
}

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
    # chck_route destination gateway interface
    if [[ -n $1 ]]; then
        printf "\t$1:\n"
    else
        printf "\t${ylw}[WARN]${end} destination is not defined\n"
        return 1
    fi
    if [[ -n $2 ]]; then
        rslt=$(route -n get "$1" | grep "gateway.*$" | awk '{$1=$1;print}') # awk remove traling and leading space
        chck_strs "$rslt" "$2"
    fi
    if [[ -n $3 ]]; then
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

chck_resolvconf() {
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


printf "\n\n"
red=$'\e[1;31m'
grn=$'\e[1;32m'
ylw=$'\e[1;33m'
end=$'\e[0m'

chck_internet_host="google.ru"
excpt_internet_gateway=$(netstat -rn | ggrep -Pzo '(?<=default)\s*[\d\.]*(?=\s)' | awk '{print $1}')

hostname_rdp="WS1111.nspk.ru"
ip_rdp_host=$(resolve_dns "$hostname_rdp")
hostname_rdp_2="WS1252.nspk.ru"
ip_rdp_host_2=$(resolve_dns "$hostname_rdp_2")
hostname_rdp_3="WS1718.nspk.ru"
ip_rdp_host_3=$(resolve_dns "$hostname_rdp_3")
hostname_hrzn="horizon.nspk.ru"
ip_hrzn_host=$(resolve_dns "$hostname_hrzn")
hostname_hrzn_pc="VDI04003.nspk.ru"
ip_hrzn_pc_host=$(resolve_dns "$hostname_hrzn_pc")

gateway_rdp_host=$(route -n get "$ip_rdp_host" | grep gateway | awk '{print $2}')
interface_name=$(route -n get "$ip_rdp_host" | grep interface | awk '{print $2}')


# ================================
# ============= MAIN =============
# ================================
chck_all
printf "\nCheck var:\n\tRDP_gateway:\n"
chck_strs "RDP_gateway: $gateway_rdp_host" ".*"

endpoint_status=$(pgrep 'Endpoint_Security_VPN' > /dev/null && printf "${grn}ON${end}" || printf "${red}OFF${end}")
printf "\nEndpoint status: ${endpoint_status}.\n\nPress any key to fix routes and dns.\n"
read

printf "\n\nFix routes:\n"
if [[ ! -z $interface_name ]]; then
  netstat -rn | grep $interface_name | awk '{print $1" "$2"\n"}' | xargs -n2 sudo route -n delete -net
  netstat -rn | grep $interface_name | awk '{print $1" "$2"\n"}' | xargs -n2 sudo route -n delete
  sudo route -n add -host "$ip_rdp_host" -interface "$interface_name"
  sudo route -n add -host "$ip_rdp_host_2" -interface "$interface_name"
  sudo route -n add -host "$ip_rdp_host_3" -interface "$interface_name"
  sudo route -n add -host "$ip_hrzn_host" -interface "$interface_name"
  sudo route -n add -host "$ip_hrzn_pc_host" -interface "$interface_name"
  if [[ -n $ip_hrzn_host ]]; then
    printf "\tFix etc hosts for $hostname_hrzn $ip_hrzn_host"
    sudo perl -pe "s/([0-9\.]+)(?=\s+$hostname_hrzn)/$ip_hrzn_host/g" -i /etc/hosts
  fi
else
 printf "\tinterface_name is empty"
fi

printf "\n\nFix dns:\n"
networksetup -setdnsservers Wi-Fi empty # "$excpt_internet_gateway"
networksetup -setsearchdomains Wi-Fi empty

chck_all

printf "\n\nThat's all\n"
