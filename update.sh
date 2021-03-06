#!/bin/sh

# Update to the latest code from git

echo "Update from git"
git checkout db/schema.rb
git pull

echo "Verify and install any new gems required."
bundle install --deployment --without development test

echo "Run database migrations if required."
bundle exec rake db:migrate RAILS_ENV=production

echo "Clear cached files."
bundle exec rake tmp:cache:clear
rm -f public/javascripts/main.js
rm -f public/javascripts/prototype-all.js
rm -f public/stylesheets/all.css

echo "Restart Apache httpd."
apachectl graceful

echo "Restart the background processor."
bundle exec lib/daemons/scheduler.rb restart