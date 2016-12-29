#
# Cookbook:: odoo
# Recipe:: user
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

user 'odoo'

group 'odoo' do
  members ['odoo']
end

user_name = node['odoo']['postgresql']['user_name']

user user_name do
  home "/home/#{user_name}"
  manage_home true
end

# cretes .pgpass with format hostname:port:database:username:password
# see https://www.postgresql.org/docs/current/static/libpq-pgpass.html

pgpass = node['odoo']['postgresql']['server_address']
pgpass += ':'
pgpass += node['postgresql']['config']['port'].to_s
pgpass += ':'
pgpass += user_name
pgpass += ':'
pgpass += user_name
pgpass += ':'
pgpass += node['odoo']['postgresql']['user_password']

file "/home/#{user_name}/.pgpass" do
  content pgpass
  owner user_name
  group user_name
  mode 00600
end
