# # encoding: utf-8

# Inspec test for recipe odoo::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe command('python -V') do
  its('stderr') { should include 'Python 2.7.12' }
end

describe file('/opt/odoo/requirements.txt') do
  it { should exist }
  its('content') { should include 'Jinja' }
end
