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

describe 'odoo::web' do
  context 'When running role[web_and_db] and role[web], on ubuntu 16' do

    let(:chef_run) { ChefSpec::SoloRunner.converge('role[web_and_db]', 'role[web]') }

    before do
      stub_command('ls /var/lib/postgresql/9.5/main/recovery.conf').and_return(false)
    end

    it 'install python' do
      expect(chef_run).to install_python_runtime '2.7.12'
    end

    it 'downloads odoo' do
      expect(chef_run).to put_ark('odoo').with(
        path: '/opt',
        url: 'https://nightly.odoo.com/10.0/nightly/src/odoo_10.0.latest.tar.gz',
        owner: 'odoo',
        group: 'odoo'
      )
    end

    %w[postgresql-server-dev-all libxml2-dev libxslt1-dev libevent-dev libsasl2-dev libldap2-dev].each do |name|
      it "installs odoo dependency package #{name}" do
        expect(chef_run).to install_package(name)
      end
    end

    it 'installs pip reqirement' do
      expect(chef_run).to install_pip_requirements('/opt/odoo/requirements.txt')
    end

    it 'install nodejs' do
      expect(chef_run).to include_recipe('nodejs::nodejs_from_binary')
    end

    it 'installs yarn' do
      expect(chef_run).to add_apt_repository('yarn').with(uri: 'https://dl.yarnpkg.com/debian/', distribution: 'stable', components: ['main'], key: 'https://dl.yarnpkg.com/debian/pubkey.gpg')
      expect(chef_run).to install_package('yarn')
    end

    it 'installs less' do
      expect(chef_run).to run_execute('yarn global add less --prefix /usr/local')
    end
  end
end
