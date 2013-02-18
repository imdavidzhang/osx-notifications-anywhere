osx-notifications-anywhere
==========================
A script to send notification center notifications remotely

Client
--------------------------
The client runs on a OSX machine. It polls a remote server (hosted on heroku) for updates and displays them as notification center (10.8 and later) notifications.

Each client is associated with a token obtained by

    ona-client -r
    
It then obtains a token from the server and stores it in ~/.ona_pull.conf

Afterwards, run

    ona-client
    
And it'll poll the server and display incoming notifications. Currently there are some issues with special characters.

Pusher
--------------------------
A pusher sends notifications to our client. It queues them on the remote server (which is then polled by the client). After getting the token from the client, associate it with the pusher by

    ona-pusher -u <token>

It'll then store the token in ~/.ona_push.conf

In order to push a notification, one can do

    ona-pusher -t 'Title' -s 'Sub title' -g 'group' -m 'Sample message'
    
Each of those are optional (except for -m <message>). Notifications are collapsed by group (i.e. only the latest notification of any group will be shown on the client side).

Server
---------------------------
The server is a simple sinatra app (which runs on heroku).





