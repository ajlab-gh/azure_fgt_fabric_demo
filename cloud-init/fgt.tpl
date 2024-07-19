Content-Type: multipart/mixed; boundary="==FGTCONF=="
MIME-Version: 1.0

--==FGTCONF==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="license"

%{ if length(var_license_file) > 0 }
${file(var_license_file)}
%{ endif }

--==FGTCONF==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="config"

config system sdn-connector
    edit AzureSDN
        set type azure
    next
end

config system global
    set admintimeout 120
    set hostname ${var_host_name}
end

config vpn ssl settings
    set port 7443
end

config router static
    edit 1
        set device port1
        set gateway ${var_external_subnet_gateway}
    next
    edit 2
        set device port2
        set dst ${var_vnet_address_prefix}
        set gateway ${var_internal_subnet_gateway}
    next
end

    config system settings
        set default-voip-alg-mode kernel-helper-based
    next
end

config system interface
    edit port1
        set alias external
        set description external
        set mode static
        set ip ${var_ipconfig1} ${var_port1_netmask}
        set allowaccess probe-response ping https ssh
    next
    edit port2
        set alias internal
        set description internal
        set mode static
        set ip ${var_port2_ip} ${var_port2_netmask}
        set allowaccess probe-response ping https ssh
    next
end

config system interface
    edit port1
        append allowaccess fgfm
    next
end

config system interface
    edit port2
        append allowaccess fgfm
    next
end

config vpn ipsec phase1-interface
    edit "Branch-to-Azure"
        set interface "port1"
        set ike-version 2
        set peertype any
        set net-device disable
        set proposal aes256-sha256
        set remote-gw ${var_remote_gw}
        set psksecret ${var_psksecret}
    next
end

config vpn ipsec phase2-interface
    edit "Branch-to-Azure"
        set phase1name "branch-to-Azure"
        set proposal aes128-sha1 aes256-sha1 aes128-sha256 aes256-sha256 aes128gcm aes256gcm chacha20poly1305
    next
end

config system interface
    edit "branch-to-Azure"
        set vdom "root"
        set ip 169.254.252.1 255.255.255.255
        set allowaccess ping
        set type tunnel
        set remote-ip 169.254.252.2 255.255.255.252
        set snmp-index 7
        set interface "port1"
    next
end

config router bgp
set as 65503
set router-id ${var_ipconfig1}
set network-import-check disable
    config neighbor
        edit "169.254.252.2"
               set bfd enable
               set remote-as 65502
         next
     end
    config network
        edit 1
            set prefix ${var_server_mappedip} 255.255.255.255
        next
    end
end

config firewall vip
    edit "server-SSH-VIP"
        set extip ${var_ipconfig1}
        set mappedip "${var_server_mappedip}"
        set extintf "any"
        set portforward enable
        set extport 2222
        set mappedport 22
    next
    edit "server-HTTP-DVWA-VIP"
        set extip ${var_ipconfig1}
        set mappedip "${var_server_mappedip}"
        set extintf "any"
        set portforward enable
        set extport 8001
        set mappedport 1000
    next
    edit "server-HTTP-JS-VIP"
        set extip ${var_ipconfig1}
        set mappedip "${var_server_mappedip}"
        set extintf "any"
        set portforward enable
        set extport 8002
        set mappedport 3000
    next
    edit "server-HTTP-PS-VIP"
        set extip ${var_ipconfig1}
        set mappedip "${var_server_mappedip}"
        set extintf "any"
        set portforward enable
        set extport 8003
        set mappedport 4000
    next
    edit "server-HTTP-BANK-VIP"
        set extip ${var_ipconfig1}
        set mappedip "${var_server_mappedip}"
        set extintf "any"
        set portforward enable
        set extport 8004
        set mappedport 2000
    next
end

config firewall policy
    edit 1
        set name "server-SSH-Inbound_Access"
        set srcintf "port1"
        set dstintf "port2"
        set action accept
        set srcaddr "all"
        set dstaddr "server-SSH-VIP"
        set schedule "always"
        set service "SSH"
        set utm-status enable
        set inspection-mode proxy
        set ssl-ssh-profile "certificate-inspection"
        set av-profile "default"
        set webfilter-profile "default"
        set dnsfilter-profile "default"
        set ips-sensor "default"
        set application-list "default"
        set waf-profile "default"
    next
        edit 2
        set name "server-HTTP-DVWA-Inbound_Access"
        set srcintf "port1"
        set dstintf "port2"
        set action accept
        set srcaddr "all"
        set dstaddr "server-HTTP-DVWA-VIP"
        set schedule "always"
        set service "ALL"
        set utm-status enable
        set inspection-mode proxy
        set ssl-ssh-profile "certificate-inspection"
        set av-profile "default"
        set webfilter-profile "default"
        set dnsfilter-profile "default"
        set ips-sensor "default"
        set application-list "default"
        set waf-profile "default"
    next
    edit 3
        set name "server-HTTP-JS-Inbound_Access"
        set srcintf "port1"
        set dstintf "port2"
        set action accept
        set srcaddr "all"
        set dstaddr "server-HTTP-JS-VIP"
        set schedule "always"
        set service "ALL"
        set utm-status enable
        set inspection-mode proxy
        set ssl-ssh-profile "certificate-inspection"
        set av-profile "default"
        set webfilter-profile "default"
        set dnsfilter-profile "default"
        set ips-sensor "default"
        set application-list "default"
        set waf-profile "default"
    next
    edit 4
        set name "server-HTTP-PS-Inbound_Access"
        set srcintf "port1"
        set dstintf "port2"
        set action accept
        set srcaddr "all"
        set dstaddr "server-HTTP-PS-VIP"
        set schedule "always"
        set service "ALL"
        set utm-status enable
        set inspection-mode proxy
        set ssl-ssh-profile "certificate-inspection"
        set av-profile "default"
        set webfilter-profile "default"
        set dnsfilter-profile "default"
        set ips-sensor "default"
        set application-list "default"
        set waf-profile "default"
    next
    edit 5
        set name "server-HTTP-BANK-Inbound_Access"
        set srcintf "port1"
        set dstintf "port2"
        set action accept
        set srcaddr "all"
        set dstaddr "server-HTTP-BANK-VIP"
        set schedule "always"
        set service "ALL"
        set utm-status enable
        set inspection-mode proxy
        set ssl-ssh-profile "certificate-inspection"
        set av-profile "default"
        set webfilter-profile "default"
        set dnsfilter-profile "default"
        set ips-sensor "default"
        set application-list "default"
        set waf-profile "default"
    next
    edit 6
        set name "Outbound_Access"
        set srcintf "port2"
        set dstintf "port1"
        set action accept
        set srcaddr "all"
        set dstaddr "all"
        set schedule "always"
        set service "ALL"
        set nat enable
    next
    edit 7
        set name "Branch-to-Azure"
        set srcintf "Branch-to-Azure"
        set dstintf "port2"
        set action accept
        set srcaddr "all"
        set dstaddr "all"
        set schedule "always"
        set service "ALL"
        set utm-status enable
        set inspection-mode proxy
        set av-profile "default"
        set ips-sensor "default"
        set application-list "default"
        set nat enable
    next
end

--==FGTCONF==--
