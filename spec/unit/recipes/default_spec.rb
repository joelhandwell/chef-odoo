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
require_relative '../shared/database'
require_relative '../shared/user'

describe 'odoo::default' do
  context 'When all attributes are default, on ubuntu 16' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    let(:connection_info) do
      {
        :host     => '127.0.0.1',
        :port     => 5432,
        :username => 'postgres',
        :password => 'postgresql_admin_default_password'
      }
    end

    client_address = '127.0.0.1'
    server_address = '127.0.0.1'

    before do
      stub_command('ls /var/lib/postgresql/9.5/main/recovery.conf').and_return(false)
    end

    describe 'user recipe' do

      it 'includes user recipe' do
        expect(chef_run).to include_recipe('odoo::user')
      end

      include_examples 'user', server_address

    end

    describe 'web recipe' do

      it 'includes web recipe' do
        expect(chef_run).to include_recipe('odoo::web')
      end
    end

    describe 'database recipe' do

      it 'includes database recipe' do
        expect(chef_run).to include_recipe('odoo::database')
      end

      include_examples 'database', client_address, server_address

    end
  end
end
