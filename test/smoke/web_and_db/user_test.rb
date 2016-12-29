# # encoding: utf-8

# Inspec test for recipe odoo::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

%w(odoo some_organization).each do |user_name|
  describe user(user_name) do
    it { should exist }
    its('group') { should eq user_name }
    its('home') { should eq "/home/#{user_name}" }
  end

  describe file("/home/#{user_name}") do
    it { should exist }
  end
end

server_address = attribute('db_server_address', default: '127.0.0.1')

describe file('/home/some_organization/.pgpass') do
  it { should be_owned_by 'some_organization' }
  it { should be_grouped_into 'some_organization' }
  its('mode') { should cmp '00600' }
  its('content') { should eq "#{server_address}:5432:some_organization:some_organization:some_organization_password" }
end
