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
require_relative '../shared/odoo_config'

describe 'odoo::web' do
  context 'When running role[web_and_db] and role[web], on ubuntu 16' do

    let(:chef_run) { ChefSpec::SoloRunner.converge('role[web_and_db]', 'role[web]') }

    before do
      stub_command('ls /var/lib/postgresql/9.5/main/recovery.conf').and_return(false)
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

    it 'do not downloads odoo via git' do
      expect(chef_run).to_not sync_git('odoo').with(
        destination: '/opt/odoo',
        revision: '10.0',
        depth: 1
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

    it 'creates odoo addon directory' do
      expect(chef_run).to create_directory('/usr/lib/python2.7/dist-packages/odoo/addons').with_recursive(true)
    end

    it 'installs odoo' do
      expect(chef_run).to run_execute('python setup.py install').with(cwd: '/opt/odoo')
    end

    server_address = '172.16.1.12'
    include_examples 'odoo_config', server_address

    it 'creates odoo log directory' do
      expect(chef_run).to create_directory('/var/log/odoo').with(owner: 'odoo', group: 'odoo')
    end

    it 'creates odoo service config file' do
      expect(chef_run).to create_directory('/etc/systemd/system')
      expect(chef_run).to render_file('/etc/systemd/system/odoo.service').with_content('ExecStart=/usr/local/bin/odoo --config /etc/odoo/odoo.conf --logfile /var/log/odoo/odoo-server.log')
    end

    it 'enable and start servcie odoo' do
      expect(chef_run).to enable_service('odoo')
      expect(chef_run).to start_service('odoo')
    end
  end

  context 'When running role[web_and_db] and role[web] with install method git, on ubuntu 16' do

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['odoo']['install_method'] = 'git'
      end.converge('role[web_and_db]', 'role[web]')
    end

    before do
      stub_command("stat -c \"%U %G\" /opt/odoo/requirements.txt | grep 'odoo odoo'").and_return(false)
    end

    it 'do not run ark resource' do
      expect(chef_run).to_not put_ark('odoo').with(
        path: '/opt',
        url: 'https://nightly.odoo.com/10.0/nightly/src/odoo_10.0.latest.tar.gz',
        owner: 'odoo',
        group: 'odoo'
      )
    end

    it 'downloads odoo via git' do
      expect(chef_run).to sync_git('odoo').with(
        destination: '/opt/odoo',
        repository: 'https://github.com/odoo/odoo.git',
        revision: '10.0',
        depth: 1
      )
      expect(chef_run).to run_execute('chown -R odoo:odoo /opt/odoo')
    end
  end
end
