# Root Note

## Setup

After cloning master, please take the following steps to migrate the database. This will only need to be done once:

```
$ bundle install
$ rake db:setup
$ rake db:migrate
```

## Troubleshooting

- If you migrate to Postgres and get an error that the current user does not exist, try clearing your browser cookies and reloading Root Note.