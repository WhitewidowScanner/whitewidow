[![Build status](https://ci.appveyor.com/api/projects/status/o1tucilwqrvxoy80/branch/master?svg=true)](https://ci.appveyor.com/project/Ekultek/whitewidow/branch/master)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/Ekultek/whitewidow/blob/master/docs/LICENSE.md)
[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/whitewidowsqli)

# Whitewidow
Whitewidow is an open source automated SQL vulnerability scanner, that is capable of running through a file list, or can
scrape Google for potential vulnerable websites. It allows automatic file formatting, random user agents, IP addresses, server information, multiple SQL injection syntax, ability to launch sqlmap from the program, and a fun environment. This program was created for learning purposes, and is intended to teach users what vulnerability looks like.

# Screenshots
Launching whitewidow displays the custom designed banner and begins searching for possible sites that could be vulnerable

![banner credits legal new.png](https://s24.postimg.org/3njorm3ut/whitewidow_banner.png)

Whitewidow is capable of finding vulnerabilities in websites by scraping Google using over 1,000 different queries that are carefully researched before added. It also uses multiple different SQL injection approaches

![error](https://s24.postimg.org/yryg8oo3p/sql_test_error_injection.png)
![blind](https://s24.postimg.org/97w6292px/sql_test_blind_injection.png)
![union](https://s24.postimg.org/lp2tpexvp/sql_test_union_injection.png)

Whitewidow is also capable of spidering a single webpage for all available links, it will then search for vulnerabilities in all the links using the programs built in file feature

![spider.jpg](https://s24.postimg.org/s5bsfi6f9/whitewidow_spider.png)

And when all is said and done, and you're sure that you've found some vulnerable sites, you can launch sqlmap from the program without the need of downloading another clone.

![sqlmap](https://s17.postimg.org/is53u576n/11_20_sqlmap.png)

# Download
Preferably clone repository, alternatively you can download zip and tarball [here](https://github.com/Ekultek/whitewidow/releases/tag/1.9.0)

# Basic Usage
`ruby whitewidow.rb -d` This will run whitewidow in default mode and scrape Google for possible sites using a random search query.

`ruby whitewidow.rb -f path/to/file` This will run whitewidow through a given file and add the SQL syntax to the URL.

`ruby whitewidow.rb -h` Will run the help flag along with show the help menu.

For more information about usage and more flags you can checkout the wiki functionality page [here](https://github.com/Ekultek/whitewidow/wiki/Functionality).

# Dependencies
 - `gem 'mechanize'`
 - `gem 'nokogiri'`
 - `gem 'rest-client'`
 - `gem 'webmock'`
 - `gem 'rspec'`
 - `gem 'vcr'`

To install all gem dependencies, follow the following template:

`cd whitewidow`

`bundle install`

This should install all gems needed, and will allow you to run the program without trouble.

# Contribute
Being an open source project, feel free to contribute your ideas and open pull request. You can fork it clone it do pretty
much whatever you want to do with it. For more information including copyright info please see the docs.

If you decide
to contribute to this project, your name will go in the docs under the author and credits file. It will remain there to
show that you have successfully contributed to Whitewidow. Thank you ahead of time for all contributions, this project
wouldn't exist without your help!

# Contact the developer
If for any reason you need to contact me, please create an issue and check the email request box. I will typically reply to your request within 48 hours of receiving the request.

<a href="https://zenhub.com"><img src="https://raw.githubusercontent.com/ZenHubIO/support/master/zenhub-badge.png"></a>
