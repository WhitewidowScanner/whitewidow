# Legal info, just to make sure that you know what's going on with this
module Legal

  class Legal

    # Not entirely sure why I have this, this program isn't illegal
    def legal
      puts <<-_END_
         [ LEGAL DISCLAIMER ]

         I was written and created for learning purposes only, I should
         be treated as a tool to further your knowledge of how SQL queries
         work and what to look for so you don't become vulnerable, such as
         the sites you will find while using me. Using me for malicious
         purposes, including but not limited to:

                 - Blackhat database take overs, to exploit, deface, or
                   steal sensitive material.
                 - Black mailing the owners of the web pages
                 - Selling personal information found within the databases
                   of the websites discovered to be vulnerable

         Is illegal and will not be tolerated. If you plan to use me for any
         of the listed purposes, or for any illegal activity, do not go forward
         and exit immediately.

         My owner Ekultek, takes no responsibility for the actions taken
         from the knowledge you have gained from using me.

         It is the end users responsibility to follow all laws, regulations,
         and rules of the state, territory, or country where I am being run.

         _________________________________________________________________

         [ TERMS OF SERVICE ]

         And now a note from my creator, the floor is all yours!

         Thank you by continuing with the processes of this program you
         agree, that all info discovered will be reported immediatly to
         the owners of the web pages.

         Furthermore you agree that the owner and writer of this program,
         is not responsible for the actions taken upon the knowledge gained
         from use of this program.

         Please take the time to read through the Legal Disclaimer and the
         Terms of Service.

         If for any reason you do not agree with the disclaimer, or terms,
         please exit this program immediately.

         Having said that, knowledge is not illegal, and I hope you take
         away as much from this program, as I gained from writing it.

           _END_
               .red.bold
    end

  end

end
