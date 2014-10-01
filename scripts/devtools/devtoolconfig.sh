### needed for ckan

# needed for paster and deployment
ckan_base_dir="/opt/ckan"
ckan_src_dir=$ckan_base_dir"/hdx-ckan"

# for deployment
ckan_branch="prod"

# needed for paster and tests
ckan_ini_file="/etc/ckan/prod.ini"

# needed to go back to where the admin was after running the script.
curr_dir=$(pwd)

# needed to stop/start/restart the supervisor app
ckan_app_name="ckan"

# needed to get the snapshot
ckan_backup_server="backup.ckan.local"
ckan_backup_user="backupuser"
ckan_backup_dir="/backup"
ckan_backup_prefix="prod.ckan.db."
ckan_tmp_dir="/tmp/ckan-db-restore"
ckan_sql_user="ckanuser"
ckan_sql_db="ckandb"

# needed for tests
ckan_TEST_sql_db="ckan_test"
ckan_TEST_sql_db_datastore="datastore_test"

# needed by paster
function activate {
	cd $ckan_base_dir
	. bin/activate
	cd $ckan_src_dir
}

#### needed for cps

# needed to get the snapshot
cps_backup_server="backup.cps.local"
cps_backup_user="backupuser"
cps_backup_dir="/backup"
cps_backup_prefix="prod.cps.db."
cps_tmp_dir="/tmp/cps-db-restore"
cps_sql_user="cpsuser"
cps_sql_db="cpsdb"

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

