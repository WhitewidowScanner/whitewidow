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
