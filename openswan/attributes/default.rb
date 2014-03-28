default['openswan']['ppp_link_network'] = "10.55.55.0"
default['openswan']['preshared_key'] = "letmein"
default['openswan']['private_virtual_interface_ip'] = "10.55.55.4"
default['openswan']['private_ip'] = `ifconfig eth0 | grep "inet addr" | awk 'BEGIN{FS=":"}{print $2}' | awk '{print $1}'`.strip
default['openswan']['private_ip_range'] = "10.55.55.5-10.55.55.100"
default['openswan']['xl2tpd_path'] = "/etc/xl2tpd"
default['openswan']['ppp_path'] = "/etc/ppp"
