# # encoding: utf-8

# Inspec test for recipe odoo::database

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('postgresql') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

admin_password = attribute('db_admin_password', default: 'postgresql_admin_default_password')

admin = postgres_session('postgres', admin_password)

describe admin.query('\l') do
  its('output') { should include 'some_organization' }
end

odoo = postgres_session('some_organization', 'some_organization_password')

describe odoo.query('\conninfo') do
  its('output') { should include 'You are connected to database "some_organization" as user "some_organization"' }
end

describe odoo.query('\l') do
  its('output') { should include 'some_organization' }
end

server_address = attribute('db_server_address', default: '127.0.0.1')

describe file('/etc/postgresql/9.5/main/postgresql.conf') do
  its('content') { should match /listen_addresses\s*=\s*'localhost,\s#{server_address}'/ }
end

client_address = attribute('db_client_address', default: '127.0.0.1')

describe file('/etc/postgresql/9.5/main/pg_hba.conf') do
  its('content') { should match /host\s*some_organization\s*some_organization\s*#{Regexp.escape(client_address)}\/32\s*md5/ }
end
