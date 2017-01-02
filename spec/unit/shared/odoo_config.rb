shared_examples 'odoo_config' do |server_address|

  it 'creates odoo config file' do
    expect(chef_run).to create_directory('/etc/odoo')
    expect(chef_run).to render_file('/etc/odoo/odoo.conf').with_content { |content|
      expect(content).to include("db_host     = #{server_address}")
      expect(content).to include('db_port     = 5432')
      expect(content).to include('db_user     = some_organization')
      expect(content).to include('db_password = some_organization_password')
      expect(content).to include('addons_path = /usr/lib/python2.7/dist-packages/odoo/addons')
    }
  end
end
