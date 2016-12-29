#
# Cookbook:: odoo
# Recipe:: database
#
# Copyright:: 2016, Joel Handwell
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

database       = node['odoo']['postgresql']['database']
user_name      = node['odoo']['postgresql']['user_name']
user_password  = node['odoo']['postgresql']['user_password']
client_address = node['odoo']['postgresql']['client_address']
server_address = node['odoo']['postgresql']['server_address']

node.default['postgresql']['pg_hba'].concat(
  [
    {:type => 'host', :db => database, :user => user_name, :addr => client_address, :method => 'md5'}
  ]
)

node.default['postgresql']['config']['listen_addresses'] = "localhost, #{server_address}"

include_recipe 'postgresql::server'
include_recipe 'postgresql::ruby'

connection_info = {
  :host     => '127.0.0.1',
  :port     => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

postgresql_database database do
  connection connection_info
  action     :create
end

postgresql_database_user 'create user for odoo' do
  connection connection_info
  username   user_name
  password   user_password
  action     :create
end

postgresql_database_user 'grant user for odoo' do
  connection    connection_info
  username      user_name
  database_name database
  schema_name   'public'
  tables        [:all]
  sequences     [:all]
  functions     [:all]
  privileges    [:all]
  action        [:grant, :grant_schema, :grant_table, :grant_sequence, :grant_function]
end
