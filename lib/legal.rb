module Legal
  def legal
    puts <<-_END_
         [ LEGAL DISCLAIMER ]

         This program was written as a learning tool only,
         and should be treated as such. The purpose of this
         program is to teach what a SQL vulnerable website
         looks like, and how to prevent yourself from becoming
         vulnerable.

         Please ensure to inform all owners of vulnerable
         websites found while running this program. The owner
         of Whitewidow claims no responsibilities for any
         malicious actions taken with the information
         that is discovered through the use of this program.

         Thank you for reading through this disclaimer and
         remember to provide all information to the owner of the
         site. All information is stored inside of the log files.
         _________________________________________________________________

         [ TERMS OF SERVICE ]

         By continuing with the processes of this program you agree,
         that all info discovered will be reported immediatly to the
         owners of the webpages.

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
    gets.chomp
  end
end