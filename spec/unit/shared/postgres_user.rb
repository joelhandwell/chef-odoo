shared_examples 'postgres_user' do |server_address|

  it 'creates password file for postgre sql user' do
    expect(chef_run).to create_file('/home/some_organization/.pgpass').with(
      content: "#{server_address}:5432:some_organization:some_organization:some_organization_password",
      owner: 'some_organization',
      group: 'some_organization',
      mode: 00600
    )
  end
end
