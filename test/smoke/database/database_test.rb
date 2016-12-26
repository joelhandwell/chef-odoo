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

sql = postgres_session('postgres', 'rID0aUG05hE8cKDKSVU7')

describe sql.query('\l') do
  its('output') { should include 'odoo' }
end
