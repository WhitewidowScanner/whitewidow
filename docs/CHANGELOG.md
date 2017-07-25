# Version 2.0.5.5
- Fixed some specification issues for issue #75 https://github.com/WhitewidowScanner/whitewidow/issues/75
- Fixed issue #70 https://github.com/WhitewidowScanner/whitewidow/issues/70
- Fixes for issue #66 https://github.com/WhitewidowScanner/whitewidow/issues/66
- Removed experimental payloads and added two new payloads
- Bumped version number

# Version 2.0.4.4
 - Fix for issue #73 edited the gemfile to download latest restclient
 - Deleted gemfile to not cause issues
 - Bumped version number

# Version 2.0.3.3
 - Fixed gemfile
 - Bumped version

# Version 2.0.2.2
 - Updated the gemfile, should fix https://github.com/WhitewidowScanner/whitewidow/issues/55
 - Bumped version number

# Version 2.0.1.1
 - Fixed the q= for nil:NilClass issue
 - Created a verification for search queries
 - Added custom payloads to inject.yml
 - Did my best to clean up the search queries, if you find some lemme know
 - Minor tweak to scanner.rb
 - Fixed the ::FixNum warning
 - Bumped version number

# Version 2.0
- Deprecated the old payloads
- Created a new payload file for payload extraction
- Added compatibility for multiple different DB types
- Complete refactor of the searching and how it works
- Bumped version number

# Version 1.9.14.27
- Updated sqlmap
- Bumped version number

# Version 1.9.13.26
- Removed failing queries, if you find more, you need to tell me idk wtf is wrong with these fucking things so just find them and annoy me. Thanks
- https://github.com/WhitewidowScanner/whitewidow/issues/50
- Edited the issue template to have error log information as well
- Bumped version number

# Version 1.9.12.25
- Fixed conversion error https://github.com/WhitewidowScanner/whitewidow/issues/49
- Bumped version number

# Version 1.9.11.24
- Updated sqlpmap
- Patched sqlmap update feature
- Bumped version number

# Version 1.9.10.23
- Moved some files into different directories to make the program much more organized
- Bumped version number

# Version 1.9.10.22
- Patched sqlmap configuration where it wouldn't launch successfully.
- Added a tmp sqlmap configuration that will allow you to now say 'n' to saving as default
- Still playing with country_specs
- Removed deprecated code
- Bumped version number

# Version 1.9.9.21
- Minor edits
- Bumped version number

# Version 1.9.9.20
- Temp fix for issue number 46 https://github.com/WhitewidowScanner/whitewidow/issues/46 just commented out the code and added a work around
- Created "not implemented yet" folder, this way you guys can see what I'm working on
- Some minor edits to other stuff that isn't important right now
- Bumped version number

# Version 1.9.8.19
- Added the database type when a site is found to be vulnerable from an array of commonly used databases, if the DB is not in the array it will resolved ot 'Database is unable to be resolved', meaning that it's not implemented yet
- Added a new constant to catch the site name and the error message
- Created a new method in SiteInfo that will extract the DB name out of the error message
- Edited scanner to create the SQL_ERROR constant
- Minor fix to recursive spider, will need a query parameter (GET) in order to process the URL, and gives and example of acceptable URL. Also will not say "running sites found" if no sites where found
- Minor change to the usage banner
- Bumped version number

# Version 1.9.8.18
- Added a hidden switch that is currently being worked on and commented out the code for it.
- Bumped version number

# Version 1.9.8.17
- Added a python download link constant
- Minor comment fixes and tweaks to SqlmapConfigHelper
- Bumped version number

# Version 1.9.8.16
- Created a sqlmap helper that will extract whether you have python 2.7.x installed or not (I think it works like 75% sure it will do what I want it to do need testers to find the problems with it)
- Created a few new constants
- Edited the launch for sqlmap
- Changed the CheckBeep to CheckOS
- Bumped the version number

# Version 1.9.7.15
- Minor fixes to site_info no longer bold IP addresses
- Bumped version number

# Version 1.9.7.14
- Patched a lot of the failing user agents, still working on them but a lot of them are fixed
- Removed some failing search queries
- Bumped version number

# Version 1.9.6.13
- Added some new user agents
- Edited the banner and message
- Added a link to the functionality page
- Bumped version number

# Version 1.9.6.12
- Patched the random user agent issue where it will display 'true' instead of the path to the agents
- Implemented union based sql injection tests, will be moving to settings eventually. How it works
  it will grab a random common column from the common_columns file, and use it in an attempt for exploitation.
  There will be an update where you will be able to use your own column names or your own file
- Added common columns for union based sql injection tests how it works
- Updated the legal info a little bit
- Added a few new constants to allow more accurate interpretation
- Removed deprecated code
- Added a '--test' flag, mostly used for developmental purposes so you don't really need to worry about it
- Bumped version number

# Version 1.9.5.11
- Minor refractors and tweaks
- Deleted some failing queries
- Bumped version number

# Version 1.9.5.10
- Minor tweak to issue template
- Bumped version number

# Version 1.9.5.9
- Merged pull request that updated the file formatting.
- Bumped version number

# Version 1.9.5.8
- Merged pull request from the badass Tyler, whitewidow will no longer crash if the file does not exist, instead it will create it without problems
- Bumped version number

# Version 1.9.4.7
- Removed some search queries that where failing
- Minor fixes for error catching while dry runs and file runs are being processed
- Bumped version number

# Version 1.9.3.6
- Patch `no implict version of string into array` error
- Bumped version number

# Version 1.9.3.5
- Created an automatic issue templating system, it will create a template of an issue for you when you get an error so you can just CNTRL-C CNTRL-V it
- Continued working on multiple SQL injection techniques, there's an issue where it's saving one URL multiple times so currently working on that
- Bumped version number

# Version 1.9.2.4
- Updated sqlmap to the newest version
- Updated the update flag so it will now include a sqlmap update
- Fixed the update flag so it will not display the actual command
- Bumped version number

# Version 1.9.2.3
- Fixed some of the search queries, I messed up on them sorry guys
- Fixed a regex in settings
- Removed deprecated code
- Updated the IPv6 regex
- Edited the success format
- Added site to the skip constant
- Bumped version number

# Version 1.9.2.2
- Minor patch for download links
- Minor comment and string fixes
- Bumped version number

# Version 1.9.1.1
- Fixed most of the user agents, still working on some of them but it shouldn't fail as much, so --rand-agent is a go
- Moved the usage_page method to the main whitewidow file, because it makes no sense for it to be in the scanner file
- Added a rescue for a keyboard interrupt, will say user aborted
- Removed failing search query
- Fixed some styling issues
- Bumped version number

# Version 1.9.0
- Merged new pull request to create testing environment for the program
- Fixed an issue where the test would fail
- Edited readme to reflect new release
- Bumped version number

# Version 1.8.6.9
- Patched the no such file or directory error
- Bumped version number

# Version 1.8.5.8
- Patched the warning
- Patched the black_widow_log error
- Bumped version number

# Version 1.8.4.7
- Patched ruby download link
- Added a method to figure out what link you need or command to run
- Bumped version number

# Version 1.8.3.6
- Added a temp blind based
- Started working on all injection techniques
- Minor text fixes
- Bumped version number

# Version 1.8.3.5
- Fixed formats, looks a little better than it did before
- New contrib, thank you for fixing the encoding errors
  - Fixed encoding errors with spider and with pretty much everything else
  - Removed some data that was not in the .gitignore
  - Be an all around badass
  - More info see here: https://github.com/WhitewidowScanner/whitewidow/pull/34
- Added a catch for the syntax error to specify that you will need a higher Ruby version number
- Added Ruby download link constant
- Edited issue template, because people are confused I guess
- Bumped vesion number

# Version 1.8.1.3
- Added an update flag, will update the program to the latest version
- Created a temp fix that will try to run with a different user agent when one fails
- Bumped version number

# Version 1.8.1.2
- Added a regex to catch IPv6, it will now attempt to decode them
- Edited whitewidow.rb to reflect that there is nothing in the LOG file
- Edited log file
- bumped version number

# Version 1.8.1.1
- Temp fix for failing user agents
- Edited the basic legal banner
- Minor fixes for random files

# Version 1.8.0
- Added 46 new user agents
- Fixed user agent flag to include the new agents
- Added a -D/--dork flag
- Changed SEARCH_QUERY constant to DEFAULT_SEARCH_QUERY
- Moved the query and random agent search to settings
- Edited issue template a little bit
- Removed deprecated code
- Random search engines is going to have to wait
- Updated the bundle issues self help file
- Updated the syntax error issues
- Shazgul you are awesome for finding the IO errors with the spider, welcome to the contrib list
- Added a version flag, show version number and exit
- Added constants to the file paths instead of hard coding them
- Added a new regex to the SQL_VULN_REGEX
- Patched the spider, if it encounters an error that is fatal, it will run the sites already in the log file
- Bumped version number

# Version 1.7.2.9
- Updated readme
- Added self help file with some troubleshooting steps
- Updated the issue template
- Moved the copyright and the license to a new folder labeled "legal"
- Moved the author and credits, community notes and notes to third party programs to a new folder labeled "misc"
- Renamed QUICK_NOTE.txt to third_part_recognition.txt
- Bumped version number

# Version 1.7.2.8
- Added a basic legal disclaimer
- Added a SQLMAP_PATH constant
- Edited some comments in the constants_and_requires file
- Made use of the squiggly heredoc (<<~)
- Changed the repo link to the clone link
- Edited the download link constant
- Edited some comments in settings
- Began working on a new flag for random search engines, commented out code
- Fixed the version string
- Edited the help menu
- Bumped the version number

# Version 1.7.2.7
- Created some short options for some flags
- Edited the options banner, shows mandatory, enumeration, anomity, processing, and misc options
- Edited settings for the banner and legal
- Bumped version number

# Version 1.7.2.6
- Patched the multiple parameter check so that it will test the URL with one parameter before it starts adding
- Added sqlmap to the .gitignore I'll keep up to date with the clones but I won't be playing with it
- Edited comments in blackwidow.rb
- Believe it or not, my version of copying a file is faster than IO.copy_stream, tested it and put results in comments
- Edited the README again for instructions on how to contact me
- License has been edited
- ISSUE_TEMPLATE has been edited as well
- Minor text and grammatical fixes
- Bumped the version number

# Version 1.7.1.5
- More fixes for the recursive spider, found another error for it
- Removed two old search queries that were failing
- Edited when the spider fails.
- Bumped version number

# Version 1.7.1.4
- First of all, I had no idea that the spider wasn't working. I apologize! It's working now, it'll pull all the links from the sites, make sure you get a good site
- Edited speed of spider, depending on the site, the spider can take for fucking ever, so I made it so that it'll be a bit faster
- Moved the spider bot to lib/modules/core/tools
- Fixed the constants and requires to reflect the fix
- Edited the README it looks pretty badass now and gives some further information pertaining to the program and how it works.
- Bumped version number, because that's what I do.

# Version 1.7.0.3
- New contrib, thanks for the video
- Read the to_the_community text file, thanks everyone. It means a lot to me.
- Bumped version number

# Version 1.7.0.2
- Fixed issue with sqlmap flag where the file wasn't opened
- Bumped version number
- Drafted re-release

# Version 1.7.0
- Added sqlmap to the mix, you can now run sqlmap through your SQL_VULN file and it will work successfully
- Added new flag for sqlmap
- Bumped version number

# Version 1.6.1.4
- Edited the banner because I didn't like it, has repo and download link now
- Bumped version number

# Version 1.6.1.3
- Fix #26 https://github.com/Ekultek/whitewidow/issues/26
- Bumped version number

# Version 1.6.1.2
- Removed deprecated code
- Converted legal heredoc to squiggly heredoc
- Added new comments all around
- Bumped version number

# Version 1.6.1.1
- Removed deprecated code
- Bumped version number

# Version 1.6.1
- Moved all files in the modules directory into new folders specified by type of file it is, such as core files, spider, etc.
- Edited the constants_and_requires to match changes
- Created a VERSION_STRING constant
- Put the version number and version type in the banner itself, this deprecated the use for the credits file. It'll be saved incase something bad happens and I need it, just commented out with a deprecation notice
- Edited README
- Deprecated --credits flag
- Deprecated page and parse() methods (moved to settings file)
- Removed search query that was failing and was in the file multiple times
- Bumped version number

# Version 1.5.1.4
- Changed the version type, it's now in the banner.rb file, it pulls the version from github itself and compares what version you have to it
- Bumped version number

# Version 1.5.1.3
- Realized that I lied to you guys and never fixed the version constant. It's fixed now. How it works is it will check
  the changelog for the last release which is specified by `(last release)`, then it will extract the version number from
  that and compare it to the current version. If the version == the last release (will probably not happen going to pull
  the version number from github itself for this one) then it will output "upgrade available" otherwise if it doesn't then
  it will check if the version length has 4 or more integers in it, if that is the case it outputs "dev". Otherwise it 
  means you cloned it probably and it will output "stable"
- Instead of hardcoding the version number in the default user agent, it pulls it from the VERSION constant
- Made the default user agent a constant
- Bumped version number

# Version 1.5.1.2
- Added more random agents
- Added a random agent flag, check the readme for more information
- Edited constants to reflect new additions
- Minor text fixes
- Edited readme to reflect new flag
- Bumped version number

# Version 1.5.0.1
- Edited the version type constant, didn't like how it worked so I did something a little different
- Edited the credits, didn't look the way I wanted it to look.
- Fixed a bunch of comments
- Bumped version number

# Version 1.5.0
- Created the spider flag and edited it to run through whitewidows file flag, how to will work is it will extract
all links from a websites source (given url) so make sure that the links direct to somewhere good.
- Changed a file name to banner
- Added a version type, stable, pre-release, or update available (will be changing with releases)
- Edited some constants
- Fixed the beep module will run from regexs now
- Changed some comments in the log files and temp files
- Removed tm from gitignore for this release
- Changed readme to reflect new information
- Changed the credits check them out
- Minor text fixes
- Bumped version number

# Prerelease 1.5.0
- Added a spider flag, recursively search a url
- Edited some comments
- Created the search under lib/modules/blackwidow.rb
- Edited readme
- Bumped version number to prerelease

######Looking for testers for this pre-release. Check the new issue that was created for this

---

# Patch release v1.4.03
- Fixed issue where the agents always showed up as nil
- Made the flags look pretty
- Edited the constants
- Edited readme
- Edited some xml data
- Bumped version number

# Version 1.4.0
- Added a --run-x flag, specify how many runs to make before exiting, will run dry runs and will not search for vulns
- Updated some info in readme
- Added some sites to the SKIP constant
- Minor comment fixes
- Minor grammar fixes
- Minor style fixes
- Minor issue fixes
- Minor text fixes
- Bumped version numebr
- Added some new search queries

# Version 1.3.0
- Added a beep flag that will make a beep when a vulnerability is found
- Added a platform check to figure out which beep to use
- Refactored the formatting module to include the beep
- Did some testing on proxies, it works feel free to use it
- Added comments
- Fixed some issues
- Made it so that it will not inject unless there's multiple parameters
- Minor text fixes
- Created a regex for the sql vuln errors
- Added more random agents
- Added 300 new search queries
- Edited license, credits, TOS, and legal info. Please familiarize yourself with the new information
- Removed information from the string expansion that is not used in the program
- Bumped version number

# Version 1.2.0
- Removed dependency from readme that is no longer used
- Fixed some spacing issues
- Added a query blacklist
- Removed commented out code that is now deprecated
- Made the program a little quicker
- Added proxy support, use the --proxy flag
- Added a dry run and batch flag
- Edited the readme to reflect changes
- Bumped version number

#Version 1.1.1
- Minor text and grammatical fixes
- Moved the misc (banner, etc) and the legal into a class
- Removed blacklist.txt
- Added license
- Added badges to readme
- Added multiple parameter testing (still working on it it works though)
- Added flags, you now choose to see the credits or the legal information
- Removed examples page because it was pointless
- Added a flag so that you can hide the banner
- Edited readme
- Bumped version number

#Version 1.1.0
- Removed colored gem and added string expansion
- Moved all errors to their own constants
- Fixed the google webcache issue
- Added all th skipped websites to a single constant
- Edited the format.rb file
- Edited some search queries
- Edited the welcome banner
- Edited readme
- Grammar fixes and minor text fixes
- Bumped version number

#Version 1.0.6.3
- Fixed user agents issues
- Reverted complete program to run
- bumped version number
- Added all new user agents

#Version 1.0.6 Patches (1.0.6.1)
- Added around 5,000 more possible search queries
- Forced encoding to UTF-8, this should take care of the invalid bytes error
- Replaced banner
- Added new contributor
- Updated Readme a little bit
- Added error log, where if a search query pulls zero sites, the search is logged for further analysis

#Version 1.0.6
- Finished optparser, read the readme your options have changed!
- Edited version numbers
- Added new contributor
- Edited file formatter
- Updated legal disclaimer and term of service.
- Added three new sql vuln syntax parameters. ( ` ; -- ) all found vuln sites using the default setting will be saved
with all of the sql syntax params and tested.
- File is automatically formatted now and will be run as `#sites.txt`
- Automatic file formatting added
- Added more information when site is found including, server info and IP address
- Complete refractor of when site is found, see screenshots for examples

#Version 1.0.5 Patches (1.0.5.1/1.0.5.2)
- Fixed copy module parameters
- Patched RestClient error

#Version 1.0.5
 - Added docs dir, this has the copyright info, changelog, and credits to contributors in it.
 - Edited credits removed contributors and put them in the docs directory.
 - Edited whitewidow comments, will be keeping this changelog updated instead of putting updates inside of the programs
 comments. Figured this would be a little more practical.
 - Edited copy module to take parameters instead of calling the files directly.
 - Edited spider module with new version
 - Removed having to push enter to continue, whitewidow will now display the legal disclaimer but will not require you
to push enter to continue.
 - Added simple file formatter in lib/extra for when you have blank line in your file. For this to work move the file
into the extra directory and run the file as an ARGV against file_formatter.rb. The file wil be saved as `#sites.txt`
Example: `ruby file_formatter.rb sites.txt`

#Version 1.0.4
 - Started working on optparser for parsing ARGV arguments instead of using ARGV. Optparser will not only be more efficient
 but will make whitewidow more readable and will be more user friendly. The new options will be released upon release of
 version 1.0.5
 - Added some country specific search queries (40 to be specific) for testing purposes. I got a bug report pertaining
 to country specific search queries, so I've added 20 `.co.uk` and 20 `.ng` search queries as a test run, depending on how
 well these test runs go, I may initiate more country based search queries into whitewidow.
 - Added gemfile, able to fully install all gems with bundle install. This will provide users a simple and easy way to
 install all the necessary gems that are needed to run whitewidow.
