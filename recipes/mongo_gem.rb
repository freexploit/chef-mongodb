# The build-essential cookbook was not running during the compile phase, install gcc explicitly for rhel so native
# extensions can be installed
gcc = package 'gcc' do
  action :nothing
  only_if { platform_family?('rhel') }
end
gcc.run_action(:install)

if platform_family?('rhel')
  sasldev_pkg = 'cyrus-sasl-devel'
else
  sasldev_pkg = 'libsasl2-dev'
end 

package sasldev_pkg do
  action :nothing
end.run_action(:install)

chef_gem 'mongo' do
  compile_time true
  version '1.12.0'
  action :install
end
