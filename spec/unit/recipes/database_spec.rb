#
# Cookbook:: odoo
# Spec:: default
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

require 'spec_helper'
require_relative '../shared/postgres_config'

describe 'odoo::database' do
  context 'When running role[web_and_db] and role[database], on ubuntu 16' do

    let(:chef_run) { ChefSpec::SoloRunner.converge('role[web_and_db]', 'role[database]') }

    let(:connection_info) do
      {
        :host     => '127.0.0.1',
        :port     => 5432,
        :username => 'postgres',
        :password => 'postgresql_admin_test_password'
      }
    end

    before do
      stub_command('ls /var/lib/postgresql/9.5/main/recovery.conf').and_return(false)
    end

    it 'installs postgresql server' do
      expect(chef_run).to include_recipe('postgresql::server')
    end

    client_address = '172.16.1.11'
    server_address = '172.16.1.12'

    include_examples 'postgres_config', client_address, server_address

    it 'loads pg gem to enable database cookbook' do
      expect(chef_run).to include_recipe('postgresql::ruby')
    end

    it 'creates database for odoo' do
      expect(chef_run).to create_postgresql_database('some_organization').with_connection(connection_info)
    end

    it 'creates db user for odoo' do
      expect(chef_run).to create_postgresql_database_user('create user for odoo').with(
        connection: connection_info,
        username: 'some_organization',
        password: 'some_organization_password'
      )
    end

    [:grant, :grant_schema, :grant_table, :grant_sequence, :grant_function].each do |action|
      it "#{action} for odoo user on odoo db" do
        expect(chef_run).to ChefSpec::Matchers::ResourceMatcher.new(:postgresql_database_user, action, 'grant user for odoo').with(
          connection: connection_info,
          username: 'some_organization',
          database_name: 'some_organization',
          schema_name: 'public',
          tables:     [:all],
          sequences:  [:all],
          functions:  [:all],
          privileges: [:all]
        )
      end
    end
  end
end
