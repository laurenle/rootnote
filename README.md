# Root Note

## Setup

### Setup Postgres

Install postgres (OSX):
http://postgresapp.com/

Open the Postgres.app file to start the GUI. If the database is not running, click the "Start" button.

Install postgres (Windows):
https://www.postgresql.org/download/windows/

Use the graphical installer. Choose a username and password during installation and remember them.

### Migrate the database

After cloning master, please take the following steps to migrate the database. This will only need to be done once:

```
$ bundle install
$ rake db:setup
$ rake db:migrate
```

You also need to add the following environment variables. On a Mac, this process looks like this:

### Add the following lines to the file ~/.bashrc:
```
export S3_BUCKET_NAME=your_bucket_name
export AWS_ACCESS_KEY_ID=your_access_key_id
export AWS_SECRET_ACCESS_KEY=your_secret_access_key
export AWS_REGION=us-east-1
```
You should have received an email with the information needed to obtain your access keys. Because this is a public Github repository, **do not accidentally upload any information on your access keys.** If you are unsure about any of this information, contact Lauren.

### Reload the ~/.bashrc file:
```
$ source ~/.bashrc
```

### Install Imagemagick

First, check whether imagemagick already exists on your machine:
```
$ identify -version
Version: ImageMagick 7.0.4-4 Q16 x86_64 2017-01-14 http://www.imagemagick.org
Copyright: © 1999-2017 ImageMagick Studio LLC
License: http://www.imagemagick.org/script/license.php
Features: Cipher DPC HDRI Modules 
Delegates (built-in): bzlib freetype jng jpeg ltdl lzma png tiff xml zlib
```

If you do not get the above message, you can install Imagemagick using Homebrew (OSX):
```
$ brew install imagemagick
```

To install Imagemagick on Windows, you can use the Windows binary installer on imagemagick.org. You must check the option "Install legacy utilities" to make available the commands used by Paperclip, and ensure that the Imagemagick directory is added to your system path (the installer should do this for you).

### Install DevKit (Windows only)

On Windows, you must install the Ruby DevKit to make available some system commands used by Paperclip:
http://rubyinstaller.org/downloads/

After downloading, add the bin directory to your system path.

## Troubleshooting

- If you migrate to Postgres and get an error that the current user does not exist, try clearing your browser cookies and reloading Root Note.
- If you get errors when trying to upload images about SSL certificates, download this certificate bundle: https://curl.haxx.se/ca/cacert.pem, and add the environment variable SSL_CERT_FILE pointing to where you saved it. This should allow your computer to communicate with AWS.