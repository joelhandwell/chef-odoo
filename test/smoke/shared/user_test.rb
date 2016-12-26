# # encoding: utf-8

# Inspec test for recipe odoo::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('odoo') do
  it { should exist }
  its('group') { should eq 'odoo' }
end
