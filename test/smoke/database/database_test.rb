# # encoding: utf-8

# Inspec test for recipe odoo::database

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe command('psql --help') do
  its('stdout') { should include 'psql is the PostgreSQL interactive terminal' }
end

describe service('postgresql') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

admin = postgres_session('postgres', 'rID0aUG05hE8cKDKSVU7')

describe admin.query('\l') do
  its('output') { should include 'some_organization' }
end

odoo = postgres_session('some_organization', 'SwvXieH6o3RB8wyepr0X')

describe odoo.query('\conninfo') do
  its('output') { should include 'You are connected to database "some_organization" as user "some_organization"' }
end
