# STREAMSLIDE

*Side project to change the world*

## 1. Setup environment

### How to install this application
1. Install rvm and ruby-1.9.3-p194
2. Install bundler gem
3. cd to directory contains this README.md file
4. bundle install
5. Start hacking this project

## Start sidekiq
``sidekiq`` is job processing based on Redis.
You should install Redis on your machine to run it

## Setup enviroment variables
Our application need to run on 3 environments: local environment, staging, and
production. That why, we use environment variable to config our app.

Here is some variables we need setup in local environment.
You can put these at the end of your `~/.bash_profile` file (if you Mac OSX), or
`~/.bashrc` file (if you use Linux)

```bash
export STREAMSLIDE_FACEBOOK_APP_ID=<value>
export STREAMSLIDE_FACEBOOK_APP_SECRET=<value>
export STREAMSLIDE_SIDEKIQ_ROOT_PASSWORD=<value>
export AWS_ACCESS_KEY_ID=<value>
export AWS_SECRET_ACCESS_KEY=<value>
export AWS_S3_BUCKET_NAME=<value>
export REDIS_URL=<value>
export FAYE_TOKEN=<value>
```

## 2. Deployment

### Add heroku remote to our git
We use 2 heroku apps: one for staging and one for production

```bash
$> git remote add staging git@heroku.com:slidestream-staging.git
$> git remote add production git@heroku.com:slidestream.git
```

Now, if we want to deploy our app to heroku, we use this command

```bash
$> git push staging master # deploy to staging
$> git push production master # deploy to production
```

Please remember run and pass all test cases before deploy to heroku

```bash
$> rake test:units
```

### Invalidated cached
Currently, we server static files and cached them for 1 year on clientside.
So, if we change any assets files, we need to invalidate our cache by changing
`assets.version` variable in `config/application.rb` files

```ruby
# Assets configuration
config.assets.enabled = true
config.assets.initialize_on_precompile = false
config.serve_static_assets = true
config.static_cache_control = "public, max-age=31536000" # cache for 1 year
config.assets.version = '0.0.1' # change this line to invalidate asset cached
```

### Migrate database
When your code change database, please migrate database in heroku after deploying

```bash
$> heroku run rake db:migrate --remote staging
$> heroku run rake db:migrate --remote production
```

### Adding githook

``githook`` is folder contains hook for git. Currently, we have

* ``pre-commit``  hook which will be called right after we commit our code.
This hook will run our test to check does new code break old code or not.
``pre-commit`` assume you use ``rvm`` and your ``rvm`` folder was located at
``$HOME/.rvm/``. If you dont use ``rvm`` please remove line 2 in
``githook/pre-commit``

Set up ``pre-commit`` hook:

```bash
$> cd <streamslide> folder
$> cd .git/hook
$> ln -s ../../githook/pre-commit pre-commit
```

### Event server setting
set event server url in config/settings.yml
```ruby
defaults: &defaults
  event_server: <url>
```
source code for event server is in https://github.com/streamslide/streamslide-eventserver

To check your setup is correct or not, please add some change to your local
codebase and run ``git add . && git commit`` to check. If you see test was run,
 it means good
