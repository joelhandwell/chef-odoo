shared_examples 'postgres_config' do |client_address, server_address|

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
end
