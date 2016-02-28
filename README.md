# ForrestCruise
Data service for intelligent running app

## Development

### Prerequisites

* Ruby 2.1.2+
* MySQL
* [Heroku Toolbelt](https://toolbelt.heroku.com) (for deploying to Heroku)

#### Windows users only

In addition to the above, do the following:

* Add bin folders for Ruby and MySQL server to your system path (e.g. `C:\Ruby22\bin`, `C:\Program Files\MySQL\MySQL Server 5.7\bin`)
* Download [Ruby DevKit](http://rubyinstaller.org/downloads/) and follow the [installation instructions](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) (Only apply it to the Ruby you downloaded. Ignore the Ruby which comes with Heroku Toolbelt.)

### Environment setup

Before you begin, set the following environment variables

```
CLEARDB_DATABASE_URL=mysql://root:root@localhost
CLEARDB_DATABASE_NAME=forrest
CACHE_SECRET=some-random-string
```

Next, login to your mysql server and create the database for your app

```
mysql -u root -p
> create database forrest;
> quit
```

### App setup

Open a terminal and switch to the ForrestCruise directory

`cd ForrestCruise`

Install Bundler (dependency manager for RubyGems)

`gem install bundler`

Install the dependencies for the app

`bundle install`

#### Windows users only

Note the post-install message about MySQL. Download the given package and copy `lib\opt\libmysql.dll` to your Ruby bin directory.

### Run the app

`ruby app.rb`

Once the server boots, open `http://localhost:4567` in your browser.

## Deployment

Daniel Sauble <djsauble@gmail.com> owns an instance of the [app](https://forrest-cruise.herokuapp.com) on Heroku. To deploy:

First, login. You only need to do this once.

`heroku login`

Next, create a remote which points to the repository on Heroku. This is a one-time operation as well.

`git remote add heroku https://git.heroku.com/forrest-cruise.git`

Commit your changes and deploy to Heroku. Repeat as needed.

```
git commit 
git push heroku master
```

Open the app you just deployed.

`heroku open`
