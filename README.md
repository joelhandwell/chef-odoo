# Odoo Cookbook

[![Build Status](https://travis-ci.org/gospelandit/chef-odoo.svg?branch=master)](https://travis-ci.org/gospelandit/chef-odoo)
[![Coverage Status](https://coveralls.io/repos/github/gospelandit/chef-odoo/badge.svg)](https://coveralls.io/github/gospelandit/chef-odoo)

Installs and configures Odoo 10.0 from nightly source as a systemd service

## Supports:

* Odoo and PostgreSQL installed in the same instance
* Odoo instance installed separately from PostgreSQL instance
* Creates systemd service configration file `/etc/systemd/system/odoo.service`, enables and starts Odoo service

## Requirements:

This cookbook depends on these external cookbooks

- poise-python
- ark
- nodejs
- postgresql
- database

### Platform:

Currently we test using test-kitchen on Ubuntu 16.04

## Attributes:

### PostgreSQL Configuration

* `default['postgresql']['config']['listen_addresses']` - database recipe will override this to `"localhost, #{node['odoo']['postgresql']['server_address']}"`
* `default['postgresql']['config']['port']` - Defaults to `5432` inheriting postgresql cookbook.
* `default['postgresql']['password']['postgres']` - Defaults to nil, default recipe will set 'postgresql_admin_default_password' if not specified
* `default['postgresql']['pg_hba']` - Inherits postgresql cookbook default, database recipe will append user info of `default['odoo']['postgresql']`

### Cookbook specific attributes

* `default['odoo']['postgresql']['database']` - Name of PostgreSQL database for Odoo. Defaults to nil, default recipe will set 'some_organization' if not specified
* `default['odoo']['postgresql']['user_name']` - Name of PostgreSQL user for Odoo. Defaults to nil, default recipe will set 'some_organization' if not specified
* `default['odoo']['postgresql']['user_password']` - Password of PostgreSQL user for Odoo. Defaults to nil, default recipe will set 'some_organization_password' if not specified
* `default['odoo']['postgresql']['client_address']` - IPv4 Address of Odoo Web instance to configure PostgreSQL user's allowed host. Defaults to nil, default recipe will set '127.0.0.1' if not specified
* `default['odoo']['postgresql']['server_address']` - IPv4 Address of Odoo DB instance to configure Odoo about PostgresSQL server host. Defaults to nil, default recipe will set '127.0.0.1' if not specified

## Usage

### Odoo and PostgreSQL in one instance
Include default recipe in runlist to install Odoo and PostgreSQL in the same instance. Change `default['odoo']['postgresql']` attributes if needed.

### Odoo and PostgreSQL in different instance
3 roles are expected to perform to this instaration.

* `role[web_and_db]` - Includes `default['odoo']['postgresql']` attributes to configure both web and db. Runlist in the role is `recipe[odoo::user]`
* `role[web]` - Includes `recipe[odoo::web]` and `recipe[postgresql::client]` in runlist
* `role[database]` - Includes `recipe[odoo::database]` in runlist

Chef node for Odoo web instance is expected to include `role[web_and_db]` and `role[web]`. Node for Odoo database instance is expected to include `role[web_and_db]` and `role[database]`. Example configrations can be found in `.kitchen.yml` file and `test/fixtures/roles` directory.

## Other works

* [mburns/chef-openerp-cookbook](https://github.com/mburns/chef-openerp-cookbook) - Installs OpenERP v6 on Ubuntu 10.04
* [osiloke/chef-odoo](https://github.com/osiloke/chef-odoo) - Installs Odoo v9 on Ubuntu 14
* [akretion/ak-odoo-chef-base](https://github.com/akretion/ak-odoo-chef-base) - Provisions server environment for OpenERP

## License and Author
- Author:: Joel Handwell <joelhandwell@gmail.com>

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
