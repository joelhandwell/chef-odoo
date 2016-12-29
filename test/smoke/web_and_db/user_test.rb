# # encoding: utf-8

# Inspec test for recipe odoo::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('odoo') do
  it { should exist }
  its('group') { should eq 'odoo' }
end

describe user('some_organization') do
  it { should exist }
end

describe file('/home/some_organization/.pgpass') do
  it { should be_owned_by 'some_organization' }
  it { should be_grouped_into 'some_organization' }
  its('mode') { should cmp '00600' }
  its('content') { should eq '172.16.1.2:5432:some_organization:some_organization:SwvXieH6o3RB8wyepr0X' }
end
