#Version 2.0.0.0
- Removed colored gem and added string expansion
- Moved all errors to their own constants
- Fixed the google webcache issue
- Added country specific search queries
- 

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
