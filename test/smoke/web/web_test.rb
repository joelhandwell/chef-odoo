# # encoding: utf-8

# Inspec test for recipe odoo::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe command('node -h')do
  its('stdout') { should include 'Usage: node' }
end

describe command('yarn -h') do
  its('stdout') { should include 'Usage: yarn' }
end

describe command('lessc -h') do
  its('stdout') { should include 'usage: lessc' }
end

describe file('/opt/odoo') do
  it { should be_directory }
  it { should be_owned_by 'odoo' }
  it { should be_grouped_into 'odoo' }
end

describe file('/opt/odoo/requirements.txt') do
  it { should exist }
  its('content') { should include 'Jinja' }
end

%w[postgresql-server-dev-all libxml2-dev libxslt1-dev libevent-dev libsasl2-dev libldap2-dev].each do |name|
  describe package(name) do
    it { should be_installed }
  end
end

describe command('python -V') do
  its('stderr') { should include 'Python 2.7.12' }
end

describe command('pip list') do
  its('stdout') { should include 'Jinja' }
end

server_address = attribute('db_server_address', default: '127.0.0.1')

sql_command = <<-CMD
sudo -H -u some_organization bash -c "psql -U some_organization -h #{server_address} -w -c '\\l'"
CMD

describe command(sql_command) do
  its('stdout') { should include 'some_organization' }
end

describe file('/usr/local/bin/odoo') do
  it { should exist }
  it { should be_executable }
end

describe file('/etc/odoo/odoo.conf') do
  it { should exist }
  its('content') { should include "db_host = #{server_address}" }
  its('content') { should include 'db_port = 5432' }
  its('content') { should include 'db_user = some_organization' }
  its('content') { should include 'db_password = some_organization_password' }
  its('content') { should include 'addons_path = /usr/lib/python2.7/dist-packages/odoo/addons' }
end

describe file('/var/log/odoo') do
  it { should be_directory }
  it { should be_owned_by 'odoo' }
  it { should be_grouped_into 'odoo' }
end

describe file('/etc/systemd/system/odoo.service') do
  it { should exist }
  its('mode') { should cmp '00644' }
  its('content') { should include 'ExecStart=/usr/local/bin/odoo --config /etc/odoo/odoo.conf --logfile /var/log/odoo/odoo-server.log' }
end

describe service('odoo') do
  it { should be_enabled }
  it { should be_running }
end
