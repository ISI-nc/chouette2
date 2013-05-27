# Chouette2 [![Build Status](https://travis-ci.org/dryade/chouette2.png)](http://travis-ci.org/dryade/chouette2?branch=master) [![Dependency Status](https://gemnasium.com/dryade/chouette2.png)](https://gemnasium.com/dryade/chouette2) [![Code Climate](https://codeclimate.com/github/dryade/chouette2.png)](https://codeclimate.com/github/dryade/chouette2)

Chouette2 is a web project in Ruby/Rails and can :
* Exchange transport data : Neptune, GTFS, Netex, CSV
* Edit transport data
* Validate transport data
* Offer a Rest API
* Import and Export Data asynchronously                

Requirements
------------
 
This code has been run and tested on [travis](http://travis-ci.org/dryade/chouette2?branch=master) with : 
* Ruby 1.8.7
* JRuby 1.6.8 (oraclejdk7, openjdk7, openjdk6)

External Deps
-------------
On Debian/Ubuntu/Kubuntu OS : 
```sh
sudo apt-get install postgresql 
sudo apt-get install pgadmin3 
sudo apt-get install openjdk-7-jdk 
sudo apt-get install git 
```

Installation
------------
 
Install [Postgres] (https://github.com/dryade/chouette2/install/postgresql.md)
Install [JRuby] (https://github.com/dryade/chouette2/install/jruby.md)

Get git code : 
```sh
cd workspace
git clone -b V2_0_3 git://github.com/dryade/chouette2
```

Install chouette-gui-command
sudo mkdir -p /usr/local/opt/chouette-command/
cd /usr/local/opt/chouette-command/

sudo unzip /home/chouette/workspace/chouette/chouette-gui-command/target/chouette-cmd_2.0.3.zip
sudo mv chouette-cmd_2.0.3 chouette-gui-2.0.3
cd chouette-cmd_2.0.3
sudo chmod a+x chouette
sudo chmod a+w .


**JRuby**

Install dependencies
```sh 
sudo apt-get install tomcat7
sudo apt-get install proj-bin
sudo apt-get install libproj-dev
sudo apt-get install make
```
Build War ( Use RAILS_ENV production mode and parameters )
```sh 
jgem install bundler --version 1.2.4
jgem install jruby-openssl 
bundle install --path vendor/bundle
bundle exec rake war
```

Install war file ( Use RAILS_ENV production mode and parameters )
```sh 
sudo cp chouette2.war /var/lib/tomcat7/webapp/.
sudo mkdir -p /var/lib/chouette/imports
sudo mkdir -p /var/lib/chouette/exports
sudo mkdir -p /var/lib/chouette/validations
sudo chmod a+x /var/lib/chouette/imports /var/lib/chouette/exports /var/lib/chouette/validations
```

**Ruby**
```sh
gem install bundler
bundle exec rake db:create
bundle exec rake jobs:work
bundle exec rails server
```


More Information
----------------
 
More information can be found on the [project website on GitHub](http://github.com/dryade/chouette2). 
There is extensive usage documentation available [on the wiki](https://github.com/dryade/chouette2/wiki).

Example Usage 
------------


License
-------
 
This project is licensed under the CeCILL-B license, a copy of which can be found in the LICENSE file.


Support
-------
 
Users looking for support should file an issue on the GitHub issue tracking page (https://github.com/dryade/chouette2/issues), or file a pull request (https://github.com/dryade/chouette2/pulls) if you have a fix available.
