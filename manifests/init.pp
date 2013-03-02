import '*.pp'

# Class: cmantix/nginxphp
#
# This module is made to install Nginx and php-fpm together.
#
# Parameters:
#   Install base pacakages, validate operating system.
# Actions:
#
# Requires:
# 
# Sample Usage:
#     include nginxphp
#
class nginxphp () {
  # validate that the script is to run on the proper server
  case $::operatingsystem {
    "ubuntu" : {
      case $::operatingsystemrelease {
        '12.04' : {}
        '12.10' : {}
        default : {fail("Module ${module_name} is not supported on ${::operatingsystem} release ${::operatingsystemrelease}")}
      }
    }
    default  : {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
  
  # install base packages
  $sysPackages = ["build-essential", "curl", "language-pack-fr", "language-pack-en"]
  package { $sysPackages: ensure => "latest", }
}
