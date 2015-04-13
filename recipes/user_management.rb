chef_gem 'bson_ext' do
  version '1.12.1'
  action :install
end
chef_gem 'mongo' do
  version '1.12.0'
  action :install
end

users = []
admin = node['mongodb']['admin']

# If authentication is required,
# add the admin to the users array for adding/updating
users << admin if node['mongodb']['config']['auth'] == true

users.concat(node['mongodb']['users'])

# Add each user specified in attributes
users.each do |user|
  mongodb_user user['username'] do
    Chef::Log.warn(user['username'])
    password user['password']
    Chef::Log.warn(user['password'])
    roles user['roles']
    database user['database']
    connection node['mongodb']
    action :add
  end
end
