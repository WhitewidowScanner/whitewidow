#Whitewidow SQL Vulnerability Scanner
Whitewidow is an open source automated SQL vulnerability scanner that makes it easy to find SQL errors within web pages.
It accomplishes this task by either running through a list of known sites using the `whitewidow.rb -f <path/to/file>`
flag and checking for incorrectly closed syntax. Alternately Whitewidow can be run in a default mode and will scrape
Google for web pages containing incorrectly closed SQL syntax: `whitewidow.rb -d`. Whitewidow comes with over 1,000
possible search queries, the ability to scrape Google as many times as necessary, and a simple quick way to install all
gem dependencies: `bundle install`.
#Screenshots
![Alt text](http://s27.postimg.org/6eklae1vn/githubpic3.jpg "Credits, legal, TOS")
![Alt text](http://s8.postimg.org/bla4ebk6d/githubpic.jpg "Defualt Mode")
![Alt text](http://s16.postimg.org/bpfx65cad/githubpic2.jpg "File Mode")
#Download
As of right now you can only clone the repository, or download the zip file. When Whitewidow reaches version 1.0.5 it will have a tarball and a zip file to download.
#Usage
`ruby whitewidow.rb -h` Will print the help page

`ruby whitewidow.rb -hh` Will print the examples page

`ruby whitewidow.rb -f <path/to/file>` Will run Whitewidow through a file

`ruby whitewidow.rb -d` Will run Whitewidow in default mode and scrape Google
#Dependencies
`gem 'mechanize'`

`gem 'nokogiri', '~> 1.6.7.2'`

`gem 'rest-client'`

`gem 'colored'`

To install all gem dependencies, follow the following template:

`cd whitewidow`

`bundle install`

This should install all gems needed, and will allow you to run the program without trouble.
#Misc
Being an open source project, feel free to contribute your ideas and open pull request. You can fork it clone it do pretty much whatever you want to do with it.
Current Version 1.0.4
