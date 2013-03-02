# nginxphp
Puppet Module to install and configure Nginx with PHP-FPM. This module will also allow you to install a proper PHP environment.

dependencies:
  'puppetlabs/apt', '>=1.1.0'
  'puppetlabs/stdlib', '>=3.2.0'

> Will only run on ubuntu 12.04 or 12.10 (feel free to add more platform).

What is installed for PHP development:
 * phpDocumentor-alpha
 * phpcpd
 * phpunit
 * phpdcd-0.9.3
 * PHP_Depend
 * PHP_PMD
 * phing
 * xdebug

## How to use this module:
```
### To install the module:
$ git clone https://hfraser@bitbucket.org/hfraser/puppet-nginx-php.git ./nginxphp

### Install php 5.4 ppa.
class { 'nginxphp::ppa': stage => 'setup' }

### Initiate the module base requirements.
include nginxphp

### Install php-fpm with the modules you desire.
class { 'nginxphp::php':
  php_packages => [
    "php5-intl",
    "php5-curl",
    "php5-gd",
    "php5-xcache",
    "php5-mcrypt",
    "php5-xmlrpc",
    "php5-xsl"
  ],
  withppa      => true
}

### Install Nginx
include nginxphp::nginx

### Install PHP developement tools.
include nginxphp::phpdev

### Configure FPM Pool
nginxphp::fpmconfig { 'bob':
  php_devmode   => true,
  fpm_user      => 'www-data',
  fpm_group     => 'www-data',
  fpm_allowed_clients => ''
}

### Configure Nginx site
nginxphp::nginx_addphpconfig { 'cmantix.dev.local':
  website_root       => "/var/www/",
  default_controller => "index.php",
  require => Nginxphp::Fpmconfig['bob']
}
```

># License
>Copyright (c) 2013 Hans-Frederic Fraser
>
>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.