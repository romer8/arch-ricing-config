#!/bin/bash
# Toggle the aquaveo OpenVPN connection (connect if down, disconnect if up).
VPN="gromero20240624-nm"

if nmcli -t -f NAME connection show --active | grep -qx "$VPN"; then
    nmcli connection down "$VPN" \
        && notify-send -i network-vpn "VPN" "Disconnected — ${VPN}"
else
    if nmcli connection up "$VPN"; then
        notify-send -i network-vpn "VPN" "Connected — ${VPN}"
    else
        notify-send -u critical -i network-error "VPN" "Failed to connect — ${VPN}"
    fi
fi
