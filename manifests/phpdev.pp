# Class: cmantix/nginxphp::pear_autodiscover
#
# Install all necessary base php development tools...
# at least what i consider to be crucial for good development.
#
# Parameters:
#
# Actions:
#    Install a whole lot of pear package. and proper xdebug configuration for a developement environement.
#       phpdoc/phpDocumentor-alpha
#       phpunit/phpcpd
#       phpunit/phpunit
#       phpunit/phpdcd-0.9.3
#       pdepend/PHP_Depend
#       phpmd/PHP_PMD
#       VersionControl_SVN-0.5.1
#       VersionControl_Git-0.4.4
#       PEAR_PackageFileManager2
#       PHP_CompatInfo
#       Console_ProgressBar-0.5.2beta
#       XML_Serializer-0.20.2
#       Console_Color2-0.1.2
#       XML_Parser2-0.1.0
#       HTML_Common2
#       PEAR_PackageFileManager_Plugins
#       phing/phing
#       pecl/xdebug
#
# Requires:
#    nginxphp::*
#
# Sample Usage:
#     include nginxphp::phpdev
#
class nginxphp::phpdev {
  include nginxphp::pear_upgrade
  include nginxphp::pear_autodiscover

  nginxphp::pear_addchannel { 'pear.phpdoc.org': }
  nginxphp::pear_install {
    'phpdoc/phpDocumentor-alpha': require =>
      [Nginxphp::Pear_addchannel['pear.phpdoc.org'],
        Nginxphp::Pear_install['phpunit/phpunit']
      ]
  }
  
  nginxphp::pear_addchannel { 'pear.phpunit.de': }
  nginxphp::pear_install { 'phpunit/phpcpd': require => Nginxphp::Pear_addchannel['pear.phpunit.de'] }
  nginxphp::pear_install { 'phpunit/phpunit': require => Nginxphp::Pear_addchannel['pear.phpunit.de'] }
  nginxphp::pear_install { 'phpunit/phpdcd-0.9.3': require => Nginxphp::Pear_addchannel['pear.phpunit.de'] }
  nginxphp::pear_addchannel { 'pear.pdepend.org': }
  nginxphp::pear_install { 'pdepend/PHP_Depend': 
    require => [
      Nginxphp::Pear_addchannel['pear.pdepend.org'],
      Nginxphp::Pear_install['phpunit/phpunit']
      ]
  }
  
  nginxphp::pear_addchannel { 'pear.phpmd.org': }
  nginxphp::pear_install { 'phpmd/PHP_PMD': require => Nginxphp::Pear_addchannel['pear.phpmd.org']}
  nginxphp::pear_addchannel { 'pear.phing.info': }
  nginxphp::pear_install {'VersionControl_SVN-0.5.1':}
  nginxphp::pear_install {'VersionControl_Git-0.4.4':}
  nginxphp::pear_install {'PEAR_PackageFileManager2':}
  nginxphp::pear_install {'channel://bartlett.laurent-laville.org/PHP_CompatInfo':}
  nginxphp::pear_install {'Console_ProgressBar-0.5.2beta':}
  nginxphp::pear_install {'XML_Serializer-0.20.2':}
  nginxphp::pear_install {'channel://pear.php.net/Console_Color2-0.1.2':}
  nginxphp::pear_install {'channel://pear.php.net/XML_Parser2-0.1.0':}
  nginxphp::pear_install {'HTML_Common2':}
  nginxphp::pear_install {'PEAR_PackageFileManager_Plugins':}
  nginxphp::pear_install { 'phing/phing':
    require => [
      Nginxphp::Pear_addchannel['pear.phing.info'],
      Nginxphp::Pear_install['phpunit/phpunit'],
      Nginxphp::Pear_install['phpmd/PHP_PMD'],
      Nginxphp::Pear_install['phpunit/phpcpd'],
      Nginxphp::Pear_install['phpunit/phpcpd'],
      Nginxphp::Pear_install['phpdoc/phpDocumentor-alpha'],
      Nginxphp::Pear_install['VersionControl_SVN-0.5.1'],
      Nginxphp::Pear_install['VersionControl_Git-0.4.4'],
      Nginxphp::Pear_install['PEAR_PackageFileManager2'],
      Nginxphp::Pear_install['channel://bartlett.laurent-laville.org/PHP_CompatInfo'],
      Nginxphp::Pear_install['Console_ProgressBar-0.5.2beta'],
      Nginxphp::Pear_install['XML_Serializer-0.20.2'],
      Nginxphp::Pear_install['channel://pear.php.net/Console_Color2-0.1.2'],
      Nginxphp::Pear_install['channel://pear.php.net/XML_Parser2-0.1.0'],
      Nginxphp::Pear_install['HTML_Common2'],
      Nginxphp::Pear_install['PEAR_PackageFileManager_Plugins'],
      Nginxphp::Pear_install['pecl/xdebug']
    ]
  }
  
  # #### Add XDEBUG AND CONF
  nginxphp::pear_install { 'pecl/xdebug': }
  file { 'xdebug-conf':
    path   => '/etc/php5/conf.d/xdebug.conf.ini',
    ensure  => file,
    notify  => Service['php5-fpm'],
    require => Package['php5-fpm']
  }
}
  