name 'odoo'
maintainer 'Joel Handwell'
maintainer_email 'joelhandwell@gmail.com'
license 'apachev2'
description 'Installs/Configures odoo'
long_description 'Installs/Configures odoo'
version '0.1.2'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/gospelandit/chef-odoo/issues' if respond_to?(:issues_url)

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/gospelandit/chef-odoo' if respond_to?(:source_url)

depends 'poise-python'
depends 'ark'
depends 'nodejs'
depends 'postgresql'
depends 'database'
