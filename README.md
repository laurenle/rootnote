# Root Note

## Setup

After cloning master, please take the following steps to migrate the database. This will only need to be done once:

```
$ bundle install
$ rake db:setup
$ rake db:migrate
```

You also need to add the following environment variables. On a Mac, this process looks like this:

1. Add the following lines to the file ~/.bashrc:

```
export S3_BUCKET_NAME=your_bucket_name
export AWS_ACCESS_KEY_ID=your_access_key_id
export AWS_SECRET_ACCESS_KEY=your_secret_access_key
export AWS_REGION=us-east-1
```

You should have received an email with the information needed to obtain your access keys. Because this is a public Github repository, **do not accidentally upload any information on your access keys.** If you are unsure about any of this information, contact Lauren.

2. Reload the ~/.bashrc file:

```
$ source ~/.bashrc
```

## Troubleshooting

- If you migrate to Postgres and get an error that the current user does not exist, try clearing your browser cookies and reloading Root Note.