# Root Note

## Setup

### Setup Postgres

Install postgres (OSX):
http://postgresapp.com/

Open the Postgres.app file to start the GUI. If the database is not running, click the "Start" button.
Remember your username and password, since you'll need to enter them as environment variables soon.

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


### Setup Twilio (Part 1)
To enable MMS uploading, you'll need to create a free trial account at [Twilio](https://www.twilio.com/try-twilio). With a free trial account, you'll be able to send/receive texts from a personal phone number, but you won't be able to send/receive texts from anyone else.

Once you've created an account, [reserve a phone number](https://www.twilio.com/console/phone-numbers/search), then head over to [Account > Account Settings](https://www.twilio.com/console/account/settings) to get your SID and authtoken. You'll use these in the next step.

### Add the following lines to the file ~/.bashrc:
```
export S3_BUCKET_NAME=your_bucket_name
export AWS_ACCESS_KEY_ID=your_access_key_id
export AWS_SECRET_ACCESS_KEY=your_secret_access_key
export AWS_REGION=us-east-1

export TWILIO_SID=your_twilio_sid
export TWILIO_TOKEN=your_twilio_auth_token
export TWILIO_NUMBER=your_twilio_number

export POSTGRES_USER=your_postgres_username
export POSTGRES_PASSWORD=your_postgres_password
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

### Setup Twilio (Part 2)

You need to create a webhook so that Twilio knows where to send SMS data.
Start your server, then download and run [ngrok](https://ngrok.com/) in a Terminal window. Assuming your server is running on port 3000, run the following command:

```
./ngrok 3000
``` 

On success, the window running ngrok will give you a "Forwarding" address. You'll need to keep this Terminal window open and running as long as you want MMS to work.

1. Navigate to [Twilio > Phone Numbers > Manage Numbers > Active Numbers](https://www.twilio.com/console/phone-numbers/incoming), and click on the phone number you reserved earlier.
2. Scroll down to "Messaging > A Message Comes in."
3. From the dropdown, select the option "Webhook."
4. Paste http://your_ngrok_forwarding_address/messages/reply into the text field.
5. Select "HTTP POST" from the second dropdown.
6. Click the red "Save" button.

Every time you restart ngrok, you'll need to repeat this step.

## Troubleshooting

- If you migrate to Postgres and get an error that the current user does not exist, try clearing your browser cookies and reloading Root Note.
- If you get errors when trying to upload images about SSL certificates, download this certificate bundle: https://curl.haxx.se/ca/cacert.pem, and add the environment variable SSL_CERT_FILE pointing to where you saved it. This should allow your computer to communicate with AWS.