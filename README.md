# `fundament_releven`

Drupal [Fundament](https://github.com/acdh-oeaw/fundament_drupal) child theme for the [Releven WissKI instance(s)](https://github.com/acdh-oeaw/wisski-deployment/tree/releven)

## Installation

```sh
DRUPAL_THEME_DIR=/opt/drupal/web/themes

git clone https://github.com/acdh-oeaw/fundament_drupal.git $DRUPAL_THEME_DIR/fundament
sed -i -e "s|core_version_requirement: ^9|core_version_requirement: ^10|g" $DRUPAL_THEME_DIR/fundament/fundament.info.yml
drush theme-enable -y fundament

git clone -b releven-drupal-fundament https://github.com/acdh-oeaw/wisski-deployment.git $DRUPAL_THEME_DIR/fundament_releven
drush theme-enable -y fundament_releven
drush config-set -y system.theme default fundament_releven
```
