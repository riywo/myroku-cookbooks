# Chef cookbooks for Myroku Server

## INSTALL

    $ git clone https://github.com/riywo/myroku-cookbooks.git
    $ cd myroku-cookbooks
    $ bundle install --path vendor/bundle
    $ bundle exec berks install --path vendor/cookbooks

## with Vagrant

    $ bundle exec vagrant up
    (takes a long time because of ruby-build)
    $ bundle exec vagrant ssh
    > sudo dpkg-reconfigure -f readline dash
    Use dash as the default system shell (/bin/sh)? n

Setup myroku-server

    > sudo su - myroku
    > cd myroku-server
    > bundle install --path vendor/bundle
    > cp config/common.yml.sample config/common.yml
    (and modify common.yml)
    > bundle exec foreman run rake db:migrate
    > bundle exec foreman run rake admin:create
    > bundle exec foreman run cap admin deploy:setup deploy
    (takes a long time because of ruby-build in llenv)

Then, access `http://www.example.local` (DNS or hosts are required)

## Add ssh key

    $ curl -X POST -F "email=mail@example.com" -F "pubkey=@YOUR_PUBKEY_FILE" http://www.example.local/user

## Create a new application

    $ curl -X POST -d "name=node_test" http://www.example.local/application

After that, you can push `node_test` repository

    $ git clone https://github.com/riywo/node_test.git
    $ cd node_test
    $ git remote add git@myroku-server:node_test  ### myroku-server points the admin server
    $ git push -u myroku master

Then, access `http://node_test.example.local` (DNS or hosts are required)

