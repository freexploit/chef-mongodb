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

node['mongodb']['ruby_gems'].each do |gem, version|
  if(Gem.const_defined?("Version") and Gem::Version.new(Chef::VERSION) < Gem::Version.new('10.12.0'))
    gem_package 'mongo' do
      version '1.12.1'
      action :nothing
    end.run_action(:install)
    Gem.clear_paths
  else
    chef_gem 'mongo' do
      version '1.12.1'
      action :install
    end
  end
end
