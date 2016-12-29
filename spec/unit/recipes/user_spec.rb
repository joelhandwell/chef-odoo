#
# Cookbook:: odoo
# Spec:: default
#
# Copyright:: 2016, Joel Handwell
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'
require_relative '../shared/user'

describe 'odoo::user' do
  context 'When all attributes are default, on an unspecified platform' do

    let(:chef_run) { ChefSpec::SoloRunner.converge('role[web_and_db]') }

    server_address = '172.16.1.12'

    include_examples 'user', server_address

  end
end
