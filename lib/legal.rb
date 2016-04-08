module Legal
  def legal
    puts <<-_END_
         [ LEGAL DISCLAIMER ]

         I was written as a learning tool only, also
         I should be treated as such. My purpose is
         to teach you what a SQL vulnerable website looks
         like, and to teach you how to prevent yourself
         from becoming vulnerable.

         Please ensure to inform all owners of vulnerable
         websites found while running me. My owner claims
         no responsibilities for any malicious actions
         taken with the information that is discovered
         while running me.

         Thank you for reading through my disclaimer and remember
         to provide all information to the owners of the sites
         All the information that I consider important will be
         stored in my log files.
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
         please exit this program immediatly.


         Press enter to continue...
        _END_
          .red.bold
    STDIN.gets.chomp
  end
end