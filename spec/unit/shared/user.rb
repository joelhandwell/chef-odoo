shared_examples 'user' do |server_address|

  it 'creates unix user odoo' do
    expect(chef_run).to create_user('odoo')
    expect(chef_run).to create_group('odoo').with(members: ['odoo'])
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
