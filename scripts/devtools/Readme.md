Simple scripts to easier mess up the dev server
-----------------------------------------------

The scripts are symlinked in /usr/local/sbin so they are easily invoked from anywhere.

The scripts' names are pretty straightforward. Use \[tab\]\[tab\] or \[tab\] to select them faster.

For example, type **cps** then \[tab\]\[tab\] will show you what scripts start with that name.

Please find below a list of scripts available and what each of it does.

1. **ckan-clean-db.sh**

   empty and reinitialize the ckan database
   
   Note: intentionally, this script is **not** installed on production servers

1. **ckan-reindex.sh**

   performs a solr reindex

1. **ckan-restart.sh**

   restart the ckan web server

1. **ckan-deploy-nose.sh**

   simple deploy, run tests
   
   Note: intentionally, this script is **not** installed on production servers

1. **ckan-deploy-simple.sh**

   stop ckan web server, pull current used branch from repo, start ckan web server

1. **ckan-start.sh**

   start ckan web server

1. **ckan-stop.sh**

   start ckan web server

1. **ckan-tests-nose.sh**

   runs nosetests on ckan
   
   Note: intentionally, this script is **not** installed on production servers

1. **ckan-sysadmin-disable.sh**

   demote a sysadmin to a normal user
   
1. **ckan-sysadmin-enable.sh**

   promote a normal user to sysadmin status

1. **ckan-sysadmin-list.sh**

   lists the sysadmins

1. **ckan-user-add.sh**

   add a new user to ckan

1. **ckan-user-delete.sh**

   remove an existing user to ckan

1. **ckan-user-details.sh**

   displays details of an existing ckan user

1. **ckan-user-list.sh**

   lists the ckan users

1. **cps-clean-db.sh**

   remove all content from cps db
   
   Note: intentionally, this script is **not** installed on production servers|

1. **cps-restart.sh**

   restarts tomcat

1. **cps-simple-deploy.sh**

   pull master branch, compile it, stop tomcat, remove old war file and the corresponding folder, copy over the new war file, start tomcat
   
1. **cps-start.sh**

   starts tomcat

1. **cps-stop.sh**

   stops tomcat

