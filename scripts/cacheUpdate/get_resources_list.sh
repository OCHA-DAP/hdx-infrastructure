# get all cps resources published in ckan
psql -U ckanuser ckandb -tc \
    "select url from resource where url like '%http://manage.hdx.rwlabs.org/hdx/api/exporter/%' and state = 'active';" | \
    grep -vE "^$" | sed -e 's/^ //' > cps_resources
