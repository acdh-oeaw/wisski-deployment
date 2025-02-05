#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Entrypoint to install Drupal in container

# Check if installation already exists
if ! [ -d /opt/drupal/web ]
	then

		# Installed Drupal modules, please check and update versions if necessary
		# List Requirements
		REQUIREMENTS="drupal/colorbox:^2.1 \
			drupal/devel:^5.3 \
			drush/drush \
			drupal/facets:^2.0 \
			drupal/field_permissions:^1.4 \
			drupal/geofield:^1.62 \
			drupal/geofield_map:^11.0 \
			drupal/image_effects:^4.0@RC \
			drupal/imagemagick:^4.0 \
			drupal/imce:^3.1 \
			drupal/inline_entity_form:^3.0@RC \
			kint-php/kint \
			drupal/leaflet:^10.2 \
			drupal/search_api:^1.35 \
			drupal/search_api_solr:^4.3 \
			drupal/viewfield:^3.0@beta \
			drupal/wisski:3.x-dev@dev \
			ewcomposer/unpack:dev-master"

		# Install Drupal, WissKI and dependencies
		set -eux
		composer create-project --no-interaction "drupal/recommended-project:${DRUPAL_VERSION}" .

		# Lets get dirty with composer
		composer config minimum-stability dev

		  # Add Drupal Recipe Composer plugin
    composer config repositories.ewdev vcs https://gitlab.ewdev.ca/yonas.legesse/drupal-recipe-unpack.git
    composer config allow-plugins.ewcomposer/unpack true

		yes | composer require ${REQUIREMENTS}

		# install libraries
		set -eux
		mkdir -p web/libraries
		wget https://github.com/jackmoore/colorbox/archive/refs/heads/master.zip -P web/libraries/
		unzip web/libraries/master.zip -d web/libraries/
		rm -r web/libraries/master.zip
		mv web/libraries/colorbox-master web/libraries/colorbox

		# IIPMooViewer
		wget https://github.com/ruven/iipmooviewer/archive/refs/heads/master.zip -P web/libraries/
		unzip web/libraries/master.zip -d web/libraries/
		rm -r web/libraries/master.zip
		mv web/libraries/iipmooviewer-master web/libraries/iipmooviewer

		# Mirador
		wget https://github.com/rnsrk/wisski-mirador-integration/archive/refs/heads/main.zip -P web/libraries/
		unzip web/libraries/main.zip -d web/libraries/
		mv web/libraries/wisski-mirador-integration-main web/libraries/wisski-mirador-integration

                # Fundament
                git clone https://github.com/acdh-oeaw/fundament_drupal.git fundament
                mv fundament /opt/drupal/web/themes/
                sed -i -e "s|core_version_requirement: ^9|core_version_requirement: ^10|g" /opt/drupal/web/themes/fundament/fundament.info.yml

                echo -e "${GREEN}create and save credentials in settings.php. ${NC}"

                sed -i -e "s/'hash_salt'] =.*/'hash_salt'] => '${HASH_SALT}';/" /settings.php
                sed -i -e "s/'host' =>.*/'host' => '${MARIADB_HOST}',/" /settings.php
                sed -i -e "s/'database' =>.*/'database' => '${MARIADB_DATABASE}',/" /settings.php
                sed -i -e "s/'username' =>.*/'username' => '${MARIADB_USER}',/" /settings.php
                sed -i -e "s/'password' =>.*/'password' => '${MARIADB_PASSWORD}',/" /settings.php
                sed -i -e "s/'port' =>.*/'port' => '${MARIADB_PORT}',/"    /settings.php

                # Move settings-file to the right place
                mv /settings.php web/sites/default/settings.php

		# Make drush available in the whole container
		ln -s /opt/drupal/vendor/bin/drush /usr/local/bin

		# Install the site
		drush si --db-url="${MARIADB_DRIVER}://${MARIADB_USER}:${MARIADB_PASSWORD}@${MARIADB_HOST}:3306/${MARIADB_DATABASE}" --site-name="${SITE_NAME}" --account-name="${DRUPAL_USER}" --account-pass="${DRUPAL_USER_PASSWORD}"

		# Enable WissKI by default
		drush en wisski

		# Set permissions
                chmod -R 644 web/sites/default/settings.php
                chown -R www-data:www-data /opt/drupal

	else
		echo "/opt/drupal/web already exists. So nothing was installed."
fi

# Adjust permissions and links
rm -r /var/www/html
ln -sf /opt/drupal/web /var/www/html

# Show apache log and keep server running
/usr/sbin/apache2ctl -D FOREGROUND
