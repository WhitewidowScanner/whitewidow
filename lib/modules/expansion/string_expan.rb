#
# String expansion for colored output
#
class String

  def red;            "\e[31m#{self}\e[0m" end  # Red output == bad
  def green;          "\e[32m#{self}\e[0m" end  # Green output == good
  def blue;           "\e[34m#{self}\e[0m" end  # Blue output == not implemented yet
  def purple;         "\e[35m#{self}\e[0m" end  # Purple output == not implemented yet
  def cyan;           "\e[36m#{self}\e[0m" end  # Cyan output == data information
  def yellow;         "\e[33m#{self}\e[0m" end  # Yellow output == warning
  def white;          "\e[37m#{self}\e[0m" end  # White output == status information
  def bold;           "\e[1m#{self}\e[0m"  end  # Bold == make it pretty

end