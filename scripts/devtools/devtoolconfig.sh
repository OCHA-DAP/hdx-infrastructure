### needed for ckan

# needed for paster and deployment
ckan_base_dir="/opt/ckan"
ckan_src_dir=$ckan_base_dir"/src/ckan"

# for deployment
ckan_branch="prod"

# needed for paster and tests
ckan_ini_file="/etc/ckan/prod.ini"

# needed to go back to where the admin was after running the script.
curr_dir=$(pwd)

# needed to stop/start/restart the supervisor app
ckan_app_name="ckan"

# needed by paster
function activate {
	cd $ckan_base_dir
	. bin/activate
	cd $ckan_src_dir
}

#### needed for cps

# clean db
cps_db="hdx"
cps_user="hdxuser"
tmp_dir="/var/tmp/cps-clean-db"

# start/restart/stop
cps_dir="/opt/www/tomcat";
webapp_dir=$cps_dir"/tomcat/webapps";

# deploy
BASEDIR="/opt/deploy/sources"
REPODIR=$BASEDIR"/DAP-System"
SRCDIR=$REPODIR"/HDX-System"
REPOURL="https://github.com/OCHA-DAP/HDX-CKAN_Setup.git"
CURPWD=$(pwd)
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

