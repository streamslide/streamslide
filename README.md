# STREMSLIDE

*Side project to change the world*

## 1. Setup environment

### How to install this application
1. Install rvm and ruby-1.9.3-p194
2. Install bundler gem
3. cd to directory contains this README.md file
4. bundle install
5. Start hacking this project

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
