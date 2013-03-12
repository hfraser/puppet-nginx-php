name 'cmantix-nginxphp'
version '1.0.0'

author 'Hans-Frederic Fraser'
license 'gpl v3.0'
project_page 'https://bitbucket.org/hfraser/puppet-nginx-php'
source 'https://bitbucket.org/hfraser/puppet-nginx-php'
summary 'Install Nginx, php-fpm also php debug and build environment'
description 'This module was created in order to simplify the instalation of nginx and php-fpm for developpers in vagrant and production environments.'

# Set up our git directory, and figure out where the module is, so that
# we can run a successful build outside the working directory; this happens
# when puppet-librarian tries to build from git, at least.
moduledir = File.dirname(__FILE__)
ENV['GIT_DIR'] = moduledir + '/.git'

# Grab the version number from git, and bump up the tiny version number if we
# have a postfix string, since Puppet only supports SemVer 1.0.0, which
# doesn't have anything but "version" and "pre-release of version".
#
# Technically this isn't accurately reflecting the real next release number,
# but whatever - it will do for now.
git_version = %x{git describe --dirty --tags}.chomp.sub(/\.([0-9]+)-/) {|v| ".#{v[1..-2].to_i(10) + 1}-" }
unless $?.success? and git_version =~ /^\d+\.\d+\.\d+/
  raise "Unable to determine version using git: #{$?}
 => #{git_version.inspect}"
end
version    git_version

dependency 'puppetlabs/apt', '>=1.1.0'
dependency 'puppetlabs/stdlib', '>=3.2.0'
