# get all cps resources published in ckan
psql -U ckanuser ckandb -tc "select url from resource where url like '%http://manage.hdx.rwlabs.org/hdx/api/exporter/%' and state = 'active';" > cps_resources
# mangle wfp location.
cat cps_resources | grep -v \/wfp\/ > cps_resources_and_wfp
cat cps_resources | grep \/wfp\/ | sed -e 's/\/manage\./\/test-manage\./' >> cps_resources_and_wfp
