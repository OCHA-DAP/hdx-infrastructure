### needed for ckan

# needed for paster and deployment
ckan_base_dir="/opt/ckan"

# needed for paster and tests
ini_file="/etc/ckan/prod.ini"

# needed to go back to where the admin was after running the script.
curr_dir=$(pwd)

# needed to stop/start/restart the supervisor app
ckan_app_name="ckan"

#### needed for cps

# clean db
cps_db="hdx"
cps_user="hdxuser"
tmp_dir="/var/tmp/cps-clean-db"

# deploy
BASEDIR="/opt/deploy/sources"
REPODIR=$BASEDIR"/DAP-System"
SRCDIR=$REPODIR"/HDX-System"
REPOURL="https://github.com/OCHA-DAP/HDX-CKAN_Setup.git"
CURPWD=$(pwd)
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
WEBAPPDIR="/opt/www/tomcat/tomcat/webapps"

# start/restart/stop
cps_location="/opt/www/tomcat";
