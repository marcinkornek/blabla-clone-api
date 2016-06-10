## API for Blablacar clone application using [*React + Redux*](github.com/marcinkornek/blabla-clone-react) + Rails API

#### Description
Application which uses [*React + Redux*](github.com/marcinkornek/blabla-clone-react) + Rails API

## Setup
Follow these steps to setup the application:

#### Step 1: Install gems
```
$ bundle install
```

#### Step 2: figaro
Create a renamed copy of the application.yml.sample file in config folder.
```
$ cp config/application.yml.sample config/application.yml
```

#### Step 3: Add your Amazon S3 environment variables
It is necessary to add Amazon S3 variables to `config/application.yml`. You have to setup your own Amazon S3 bucket on [Amazon S3](https://aws.amazon.com/s3/).
```
# config/application.yml

development:
  S3_ACCESS_KEY_ID: "your_s3_access_key_id"
  S3_SECRET_ACCESS_KEY: "your_s3_secret_access_key"
  S3_REGION: "your_s3_region"
  S3_BUCKET: "your_s3_bucket_name"
```

#### Step 4: Create database and run migrations
```
$ rake db:setup
```

## Usage
Run server:
```
$ rails s
```

## Test
To test Rails controllers and models:
```
$ rspec
```
