#Whitewidow SQL Vulnerability Scanner
Whitewidow is an open source automated SQL vulnerability scanner that makes it easy to find SQL errors within web pages.
It accomplishes this task by either running through a list of known sites using the `whitewidow.rb -f <path/to/file>`
flag and checking for incorrectly closed syntax. Alternately Whitewidow can be run in a default mode and will scrape
Google for web pages containing incorrectly closed SQL syntax: `whitewidow.rb -d`. Whitewidow comes with over 1,000
possible search queries, the ability to scrape Google as many times as necessary, a simple quick way to install all
gem dependencies: `bundle install`, and a simple easy to use file formatter.
#Screenshots
![Alt text](http://s27.postimg.org/6eklae1vn/githubpic3.jpg "Credits, legal, TOS")
![Alt text](http://s8.postimg.org/bla4ebk6d/githubpic.jpg "Default Mode")
![Alt text](http://s16.postimg.org/bpfx65cad/githubpic2.jpg "File Mode")
#Download
Preferably clone repository, alternatively you can download zip and tarball [here](https://github.com/Ekultek/whitewidow/releases/tag/1.0.5.1)
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
Being an open source project, feel free to contribute your ideas and open pull request. You can fork it clone it do pretty
much whatever you want to do with it. For more information including copyright info please see the docs.

If you decide
to contribute to this project, your name will go in the docs under the author and credits file. It will remain there to
show that you have successfully contributed to Whitewidow. Thank you ahead of time for all contributions

Just a little note to the contributors, and the future contributors of the whitewidow project without you this project
would not exist, thank you for your help, and I hope you will continue to contribute to this project. I look forward to
seeing your ideas brought to life. I also look forward to learning from you.

How to use the file formatter, move your file containing the sites you want to check into lib/extra run `ruby file_formatter.rb <file>`
new file will appear as `#sites.txt`. Use this file to run against whitewidow.

Current Version 1.0.5
