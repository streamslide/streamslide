namespace :heroku do
  desc 'create new staging app'
  task :create_staging do
    `heroku apps:create slidestream-staging`
    `git remote add staging git@heroku.com:slidestream-staging.git`
    `heroku config:set BUNDLE_WITHOUT=development:test:staging --remote staging`
    `heroku config:set SLIDESTREAM_FACEBOOK_APP_SECRET=2521307357945b4448b092fe7b2db2a6 --remote staging`
    `heroku config:set SLIDESTREAM_FACEBOOK_APP_ID=435374209865580 --remote staging`
  end
end
