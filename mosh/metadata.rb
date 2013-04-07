maintainer       "Joshua Timberman"
maintainer_email "cookbooks@housepub.org"
license          "Apache 2.0"
description      "Installs/Configures mosh"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3.0"

%w{ debian ubuntu mac_os_x mac_os_x_server redhat centos scientific amazon fedora gentoo arch }.each do |os|
  supports os
end

depends "apt"
