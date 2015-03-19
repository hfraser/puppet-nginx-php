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
class nginxphp::php (
  $php_packages,
){
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
      restart => "/etc/init.d/php5-fpm restart"
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
  $php_devmode              = false,
  $fpm_user                 = 'www-data',
  $fpm_group                = 'www-data',
  $fpm_listen               = '127.0.0.1:9002',
  $fpm_allowed_clients      = '127.0.0.1',
  $fpm_max_children         = '10',
  $fpm_start_servers        = '4',
  $fpm_min_spare_servers    = '2',
  $fpm_max_spare_servers    = '6',
  $fpm_catch_workers_output = false,
  $fpm_error_log            = false,
  $fpm_access_log           = false,
  $fpm_slow_log             = false,
  $fpm_log_level            = undef,
  $fpm_rlimit_files         = undef,
  $fpm_rlimit_core          = undef,
  $pool_cfg_append          = undef
){
  # set config file for the pool
  file {"fpm-pool-${name}":
    path            => "/etc/php5/fpm/pool.d/${name}.conf",
    owner           => 'root',
    group           => 'root',
    mode            => 644,
    notify          => Service['php5-fpm'],
    require         => Package['php5-fpm'],
    content         => template('nginxphp/pool.conf.erb'),
  }

  # set config file for the pool
  if ! defined(File["/etc/php5/fpm/php-fpm.conf"]) {
    file {'/etc/php5/fpm/php-fpm.conf':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service['php5-fpm'],
      require => Package['php5-fpm'],
      content => template('nginxphp/php-fpm.conf.erb')
    }
}
}
