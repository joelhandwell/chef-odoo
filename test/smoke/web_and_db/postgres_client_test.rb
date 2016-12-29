# # encoding: utf-8

# Inspec test for recipe odoo::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe command('psql --help') do
  its('stdout') { should include 'psql is the PostgreSQL interactive terminal' }
end
