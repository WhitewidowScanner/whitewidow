# THIS PROJECT IS NOT AS WELL MAINTAINED ANYMORE. TO RUN THIS PROJECT PLEASE DOWNLOAD THE LAST [RELEASE](https://github.com/Ekultek/whitewidow/releases/tag/1.0.6.1). I WILL BE PUSHING UPDATES JUST NOT AS FREQUENTLY

#Whitewidow

Whitewidow is an open source automated SQL vulnerability scanner, that is capable of running through a file list, or can
scrape Google for potential vulnerable websites. It allows automatic file formatting, random user agents, IP addresses,
server information, multiple SQL injection syntax, and a fun environment. This program was created for learning purposes,
and is intended to teach users what vulnerability looks like.

#Screenshots

![Alt text](http://s30.postimg.org/7ik6ycicx/githubpic.jpg "Credits, legal, TOS")
![Alt text](http://s30.postimg.org/lstr9typd/githubpic2.jpg "Default Mode")
![Alt text](http://s30.postimg.org/5tb3qa2nl/githubpic3.jpg "File Mode")

#Download

Preferably clone repository, alternatively you can download zip and tarball [here](https://github.com/Ekultek/whitewidow/releases/tag/1.0.6.1)

For now download the zip or tar file, cloning the repository will now allow you to run the program.

#Usage

`ruby whitewidow.rb -h` Will print the help page

`ruby whitewidow.rb -e=<either default or file>` You will need to tell whitewidow which type of example you are looking
for, either default or file.

`ruby whitewidow.rb -f=<path/to/file>` Will run Whitewidow through a file, you will not need to provide whitewidow the
full path to the file, just provide it the paths within the whitewidow directory itself. Also you will not need a beginning
slash, example:

    - whitewidow.rb -f=tmp/sites.txt #<= CORRECT
    - whitewidow.rb -f=/home/users/me/whitewidow-1.0.6/tmp/sites.txt #<= INCORRECT

`ruby whitewidow.rb -d` Will run whitewidow in default mode and scrape Google using the search queries in the lib directory

`ruby whitewidow.rb -d --proxy=127.0.0.1:8080` Will run whitewidow in default mode using a proxy

`ruby whitewidow.rb -d --thread=5` Will run whitewidow in default mode using 5 different threads, meaning that it will
use 5 search queries on 5 search engines

`ruby whitewidow.rb -d --tor` Will run whitewidow in default mode through Tor on your localhost.

#Dependencies

`gem 'mechanize'`

`gem 'nokogiri', '~> 1.6.7.2'`

`gem 'rest-client'`

`gem 'colored'`

To install all gem dependencies, follow the following template:

`cd whitewidow`

`bundle install`

This should install all gems needed, and will allow you to run the program without trouble.

#Contribute

Being an open source project, feel free to contribute your ideas and open pull request. You can fork it clone it do pretty
much whatever you want to do with it. For more information including copyright info please see the docs.

If you decide
to contribute to this project, your name will go in the docs under the author and credits file. It will remain there to
show that you have successfully contributed to Whitewidow. Thank you ahead of time for all contributions, this project 
wouldn't exist without your help!

#Misc

Current Version 1.0.6.1
