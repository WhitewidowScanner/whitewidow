# The opening, this will output every time the program is run.
# That seems kind of annoying so I'll probably change this
module Whitewidow

  # Spider, big fancy spider thingy
  def spider
    puts <<-_END_


           ;               ,
         ,;                 '.
        ;:                   :;
       ::                     ::
       ::       White         ::
       ':       Widow         :
        :.                    :
     ;' ::                   ::  '
    .'  ';                   ;'  '.
   ::    :;                 ;:    ::
   ;      :;.             ,;:     ::
   :;      :;:           ,;"      ::
   ::.      ':;  ..,.;  ;:'     ,.;:
    "'"...   '::,::::: ;:   .;.;""'
        '"""....;:::::;,;.;"""
    .:::.....'"':::::::'",...;::::;.
   ;:' '""'"";.,;:::::;.'""""""  ':;
  ::'         ;::;:::;::..         :;
 ::         ,;:::::::::::;:..       ::
 ;'     ,;;:;::::::::::::::;";..    ':.
::     ;:"  ::::::"""'::::::  ":     ::
 :.    ::   ::::::;  :::::::   :     ;
  ;    ::   :::::::  :::::::   :    ;
   '   ::   ::::::....:::::'  ,:   '
    '  ::    :::::::::::::"   ::
       ::     ':::::::::"'    ::
       ':       """""""'      ::
        ::                   ;:
        ':;                 ;:"
          ';              ,;'
            "'           '"
              '



    _END_ # Cool ass fuckin' spider thingy
  end

  # The version the program is currently in
  def version
    '1.0.6.2' # Version number
  end

end