# Function: cmantix/nginxphp::pear_install
#
# Install pear packages.
#
# Parameters:
#   $name Name of the pear package to install.
#
# Actions:
#    Install pear packages.
#
# Requires:
#    puppetlabs/apt
#
# Sample Usage:
#     nginxphp::pear_install {
#         'phpdoc/phpDocumentor-alpha': require =>
#           [Nginxphp::Pear_addchannel['pear.phpdoc.org'],
#             Nginxphp::Pear_install['phpunit/phpunit']
#           ]
#       }
#
define nginxphp::pear_install(
  $all_dependency = true
){
  if ($all_dependency) {
    $deps = "--alldeps"
  }
  exec{"pear-mod-install-${name}":
    command => "/usr/bin/pear install ${deps} ${name}",
    require => [Exec["pear-upgrade"]],
    unless  => "pear info ${name}"
  }
}

# Function: cmantix/nginxphp::pear_addchannel
#
# Discovver a channel.
#
# Parameters:
#   $name Name of the pear channel to discover.
#
# Actions:
#    pear channel-discover
#
# Requires:
#    nginxphp::php
#
# Sample Usage:
#     nginxphp::pear_addchannel { 'pear.phpdoc.org': }
#
define nginxphp::pear_addchannel{
  exec{"pear-channel ${name}":
    command => "/usr/bin/pear channel-discover ${name}",
    require => [Package["php-pear"], Exec["pear-autodiscover"]],
    unless => "pear channel-info ${name}"
  }
}

# Class: cmantix/nginxphp::pear_upgrade
#
# Upgrade pear.
#
# Parameters:
#   $name Name of the pear channel to discover.
#
# Actions:
#    pear upgrade
#
# Requires:
#    nginxphp::pear_upgrade
#
# Sample Usage:
#     include nginxphp::pear_upgrade
#
class nginxphp::pear_upgrade{
  exec{"pear-upgrade":
    command => "/usr/bin/pear upgrade",
    require => [Package["php-pear"], Exec["pear-autodiscover"]]
  }
}

# Class: cmantix/nginxphp::pear_autodiscover
#
# Set pear to autodiscover.
#
# Parameters:
#   $name Name of the pear channel to discover.
#
# Actions:
#    pear config-set auto_discover 1
#
# Requires:
#    nginxphp::pear
#
# Sample Usage:
#     include nginxphp::pear_autodiscover
#
class nginxphp::pear_autodiscover {
  exec {"pear-autodiscover":
    command => "pear config-set auto_discover 1",
    require => [Package["php-pear"]]
  }
}