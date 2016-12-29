shared_examples 'user' do |server_address|

  %w(odoo some_organization).each do |user_name|
    it "creates unix user #{user_name}" do
      expect(chef_run).to create_user(user_name).with(home: "/home/#{user_name}", manage_home: true)
    end
  end

  it 'creates unix user same as postgre sql user' do
    expect(chef_run).to create_user('some_organization').with(home: '/home/some_organization', manage_home: true)
  end

  it 'creates password file for postgre sql user' do
    expect(chef_run).to create_file('/home/some_organization/.pgpass').with(
      content: "#{server_address}:5432:some_organization:some_organization:some_organization_password",
      owner: 'some_organization',
      group: 'some_organization',
      mode: 00600
    )
  end
end
