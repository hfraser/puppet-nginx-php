# Class: cmantix/nginxphp::php
#
# This module is made to install Nginx and php-fpm together.
#
# Parameters:
#   $php_packages list of extra php packages
#   $withppa set to true if you are using php 5.4 from ppa
#
# Actions:
#    install php-fpm as well as base packages
#
# Requires:
#    nginxphp
#
# Sample Usage:
#     include nginxphp::nginxphp
#
class nginxphp::php($php_packages, $withppa=false){
  if ($withppa) {
    $fpm_init_name = 'php5-fpm'
  } else {
    $fpm_init_name = 'php-fpm'
  }
  
  # install FPM
  package {
    'php5-fpm' :
      ensure => latest,
  }
  
  service {
    'php5-fpm':
      ensure => running,
      enable => true,
      hasrestart => true,
      hasstatus   => true,
      require => Package['php5-fpm'],
      restart => "/etc/init.d/${fpm_init_name} restart"
  }
  
  # remove fpm default pool
  file {
    'fpm-disable-default' :
      path => '/etc/php5/fpm/pool.d/www.conf',
      ensure => absent,
      notify => Service['php5-fpm'],
      require => Package['php5-fpm']
  }
  
  # install base PHP
  $basePHP = [
    'php5-cli',
    'php-pear',
    "php5-common",
    "php5-dev"
  ]
  package {
    $basePHP:
      ensure => latest,
  }
  
  # install all required packages
  package {
    $php_packages:
      ensure => latest,
      notify => Service["php5-fpm"],
  }
}

# Function: cmantix/nginxphp::fpmconfig
#
# Set FPM pool configuration
#
# Parameters:
#   $php_devmode [default:false]  Enable debug logging and .
#   $fpm_user    [default:www-data] User that runs the pool.
#   $fpm_group   [default:www-data] Group that runs the pool.
#   $fpm_listen  [default:127.0.0.1:9002] IP and port that the pool runs on.
#   $fpm_allowed_clients [default:127.0.0.1] Client ips that can connect to the pool.
#
# Actions:
#    install php-fpm pool configuration
#
# Requires:
#    nginxphp::php
#
# Sample Usage:
#     nginxphp::fpmconfig { 'bob':
#       php_devmode   => true,
#       fpm_user      => 'vagrant',
#       fpm_group     => 'vagrant',
#       fpm_allowed_clients => ''
#     }
#
define nginxphp::fpmconfig (
    $php_devmode         = false,
	  $fpm_user            = 'www-data',
	  $fpm_group            = 'www-data',
	  $fpm_listen          = '127.0.0.1:9002',
	  $fpm_allowed_clients = '127.0.0.1'
  ){
  # set config file for the pool  
  file {"fpm-pool-${name}":
    path => "/etc/php5/fpm/pool.d/${name}.conf",
    owner   => 'root',
    group   => 'root',
    mode    => 644,
    notify  => Service['php5-fpm'],
    require => Package['php5-fpm'],
    content => template("nginxphp/pool.conf.erb")
  }
}
