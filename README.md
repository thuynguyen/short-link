# README
  - For fast responses, I have used Redis to save short link and original link as key and value. And I have used mongod DB to save statistic data included: the number of requests, call from which flatform, which browsers of each link. Redis server is separately with rails server, so it can be scaled up easily. Mongod DB is available for big data without relationship, response query data fastly.

## Detailed Instructions on How to run:
  - Fetch code from git URL: https://github.com/thuynguyen/short-link
  - Install ruby 3.0.1
  - Run `bundle install`
  - Install redis-server, Mongodb
  - Modify some config files: database.yml, mongoid.yml. The database.yml is required default database in rails, so I have to set up it, although I have not used it in developing the ShortLink project.
  - Run `rails s`
  - Get Postman collection to call API: https://www.getpostman.com/collections/206bf10c5b27f1a48e32
  - Run Rspec testing by command: rspec spec/requests/shortener_controller_spec.rb

## Some main steps to deploy my project to Heroku:
  - Create cloud mongodb and following with docs: https://www.mongodb.com/developer/products/atlas/use-atlas-on-heroku/
  - Set Up Redis server on Heroku by following with steps: https://devcenter.heroku.com/articles/heroku-redis
  - Create app on Heroku, and add the remote origin to heroku app
  - The last step is run deployment command: Ex: `git push heroku master:main`. Then some rake tasks if have any.


## Security:
  - To avoid as much as the collisions between links, I use sequence to modify the original link before encoding by SHA2 to short link. So users who will not face the issue redirect to wrong expectation link, will not access link of other users. I selected to SHA2 to encode because when I manually test it, if between these links are different by 1 character, it will be returned different encode.
  - Some potential attack vectors on the application: when attacker has the short link, they can use it to redirect to phishing domains. Because these links are often used in email, SMS so users easily to click on it.
  - Currently, the project is missing the security related to: authentication, captcha, ... to project user's info.

## Scalability
  - Because I have used Redis, and Rails server:
  Base on the concurrency requests, we need to scale up redis server or Rails server to adapt the number of concurrent requests.

  - We will use load balancer server to scale up rails server.




