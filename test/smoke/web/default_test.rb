# # encoding: utf-8

# Inspec test for recipe odoo::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

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

describe command('node -h')do
  its('stdout') { should include 'Usage: node' }
end

describe command('yarn -h') do
  its('stdout') { should include 'Usage: yarn' }
end

describe command('lessc -h') do
  its('stdout') { should include 'usage: lessc' }
end

sql_command = <<-CMD
sudo -H -u some_organization bash -c "psql -U some_organization -h 172.16.1.2 -w -c '\\l'"
CMD

describe command(sql_command) do
  its('stdout') { should include 'some_organization' }
end
