#Whitewidow

Whitewidow is an open source automated SQL vulnerability scanner, that is capable of running through a file list, or can
scrape Google for potential vulnerable websites. It allows automatic file formatting, random user agents, IP addresses, server information, multiple SQL injection syntax, and a fun environment. This program was created for learning purposes, and is intended to teach users what vulnerability looks like.

Although whitewidow is a completely open source project, and is completely free. Every once in awhile I need some coffee. If you like this program, and like this idea, you can help me with my [coffee fund.](https://www.paypal.me/Perkins892)

#Screenshots

![Alt text](http://s30.postimg.org/7ik6ycicx/githubpic.jpg "Credits, legal, TOS")
![Alt text](http://s30.postimg.org/lstr9typd/githubpic2.jpg "Default Mode")
![Alt text](http://s30.postimg.org/5tb3qa2nl/githubpic3.jpg "File Mode")

#Download

Preferably clone repository, alternatively you can download zip and tarball [here](https://github.com/Ekultek/whitewidow/releases/tag/1.0.6.1)

NOTE: For now just download the tar or zip file, I am currently working on the release of 1.0.7 and will be storing the files in the repository, cloning it will probably not work because the files aren't prepared yet. Thank you and sorry for the inconvenience.

#Usage

`ruby whitewidow.rb -h` Will print the help page

`ruby whitewidow.rb -e` Will print the examples page

`ruby whitewidow.rb -f <path/to/file>` Will run Whitewidow through a file, you will not need to provide whitewidow the
full path to the file, just provide it the paths within the whitewidow directory itself. Also you will not need a beginning
slash, example:

    - whitewidow.rb -f tmp/sites.txt #<= CORRECT
    - whitewidow.rb -f /home/users/me/whitewidow-1.0.6/tmp/sites.txt #<= INCORRECT

`ruby whitewidow.rb -d` Will run whitewidow in default mode and scrape Google using the search queries in the lib directory

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

Future updates:

- Custom user agent
- Webcrawler to search specified site for vulnerabilities
- Will be moving all .rb extension files into lib/core directory
- Advanced searching, meaning multiple pages of Google, along with multiple parameter checking.
- Ability to detect database type.
- Using multiple search engines, such as DuckDuckGo, Google, Bing, Yahoo. This will prevent one search engine from taking the multiple searches as a threat and will give further anomity to the program. I will also be adding IP anomity with a built in proxy anomity that will be run through Tor, there will be a flag (--switch-proxy) where you will be able to use your own custom proxy, the Tor feature will ALWAYS be on.
