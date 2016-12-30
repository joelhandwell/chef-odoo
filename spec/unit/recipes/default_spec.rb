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
Dir[File.expand_path('../shared/*.rb', File.dirname(__FILE__))].each {|file| require file }

describe 'odoo::default' do
  context 'When all attributes are default intend to install web and db in the same machine, on ubuntu 16' do
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

    before do
      stub_command('ls /var/lib/postgresql/9.5/main/recovery.conf').and_return(false)
    end

    %w(user web database).each do |recipe_name|
      it "includes #{recipe_name} recipe" do
        expect(chef_run).to include_recipe("odoo::#{recipe_name}")
      end
    end

    client_address = '127.0.0.1'
    server_address = '127.0.0.1'

    include_examples 'postgres_user', server_address
    include_examples 'odoo_config', server_address
    include_examples 'postgres_config', client_address, server_address
  end
end
