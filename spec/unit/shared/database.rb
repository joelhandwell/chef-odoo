shared_examples 'database' do |client_address, server_address|

 it 'installs postgresql server' do
    expect(chef_run).to include_recipe('postgresql::server')
  end

  it 'configures postgresql' do
    expect(chef_run).to render_file('/etc/postgresql/9.5/main/postgresql.conf').with_content{ |content|
      expect(content).to match /listen_addresses\s*=\s*'localhost,\s#{server_address}'/
    }
  end

  escaped = Regexp.escape(client_address)

  it 'configures postgresql authentication file for odoo db user' do
    expect(chef_run).to render_file('/etc/postgresql/9.5/main/pg_hba.conf').with_content { |content|
      expect(content).to match /host\s*some_organization\s*some_organization\s*#{escaped}\/32\s*md5/
    }
  end

  it 'loads pg gem to enable database cookbook' do
    expect(chef_run).to include_recipe('postgresql::ruby')
  end

  it 'creates database for odoo' do
    expect(chef_run).to create_postgresql_database('some_organization').with_connection(connection_info)
  end

  it 'creates db user for odoo' do
    expect(chef_run).to create_postgresql_database_user('create user for odoo').with(
      connection: connection_info,
      username: 'some_organization',
      password: 'some_organization_password'
    )
  end

  [:grant, :grant_schema, :grant_table, :grant_sequence, :grant_function].each do |action|
    it "#{action} for odoo user on odoo db" do
      expect(chef_run).to ChefSpec::Matchers::ResourceMatcher.new(:postgresql_database_user, action, 'grant user for odoo').with(
        connection: connection_info,
        username: 'some_organization',
        database_name: 'some_organization',
        schema_name: 'public',
        tables:     [:all],
        sequences:  [:all],
        functions:  [:all],
        privileges: [:all]
      )
    end
  end
end
