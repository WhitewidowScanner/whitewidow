#Whitewidow SQL Vulnerability Scanner
Whitewidow is an open source automated SQL vulnerability scanner that makes it easy to find SQL errors within web pages.
It accomplishes this task by either running through a list of known sites using the `whitewidow.rb -f <path/to/file>`
flag and checking for incorrectly closed syntax. Alternately Whitewidow can be run in a default mode and will scrape
Google for web pages containing incorrectly closed SQL syntax: `whitewidow.rb -d`.
#Screenshots
![Alt text](http://s27.postimg.org/6eklae1vn/githubpic3.jpg "Credits, legal, TOS")
![Alt text](http://s8.postimg.org/bla4ebk6d/githubpic.jpg "Defualt Mode")
![Alt text](http://s16.postimg.org/bpfx65cad/githubpic2.jpg "File Mode")
#Download
Preferably clone the repository. However you can download the Zipfile and Tarball [here](https://github.com/Ekultek/whitewidow/releases/tag/1.0.3).
#Usage
`ruby whitewidow.rb -h` Will print the help page

`ruby whitewidow.rb -hh` Will print the examples page

`ruby whitewidow.rb -f <path/to/file>` Will run Whitewidow through a file

`ruby whitewidow.rb -d` Will run Whitewidow in default mode and scrape Google
#Misc
Being an open source project, feel free to contribute your ideas and open pull request. You can fork it clone it do pretty much whatever you want to do with it. 

Current Version: 1.0.3
