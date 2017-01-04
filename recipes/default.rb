#
# Cookbook:: odoo
# Recipe:: default
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

node.default['odoo']['postgresql']['database'] = 'some_organization' if node['odoo']['postgresql']['database'] == nil
node.default['odoo']['postgresql']['user_name'] = 'some_organization' if node['odoo']['postgresql']['user_name'] == nil
node.default['odoo']['postgresql']['user_password'] = 'some_organization_password' if node['odoo']['postgresql']['user_password'] == nil
node.default['odoo']['postgresql']['client_address'] = '127.0.0.1/32' if node['odoo']['postgresql']['client_address'] == nil
node.default['odoo']['postgresql']['server_address'] = '127.0.0.1' if node['odoo']['postgresql']['server_address'] == nil
node.default['postgresql']['password']['postgres'] = 'postgresql_admin_default_password' if node['postgresql']['password']['postgres'] == nil

include_recipe 'odoo::user'
include_recipe 'odoo::database'
include_recipe 'odoo::web'
