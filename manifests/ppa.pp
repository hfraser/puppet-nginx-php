# Class: cmantix/nginxphp::php
#
# This module is made to install Nginx and php-fpm together.
#
# Parameters:
#
# Actions:
#    install "ppa:ondrej/php5" ppa repo and key to get decent php on ubuntu 12.04
#
# Requires:
#    puppetlabs/apt
#
# Sample Usage:
#     include nginxphp::ppa
#
class nginxphp::ppa (){
  exec { "cmapt_update":
    command => "/usr/bin/apt-get update"
  }
  Exec["cmapt_update"] -> Package <| |>
  
  class { 'apt': always_apt_update => true}
  include apt
  apt::ppa { "ppa:ondrej/php5": }
  apt::key { "ondrej": key => "E5267A6C" }
}