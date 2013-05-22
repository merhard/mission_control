require 'time'
require 'fileutils'

class MissionControlCommand
  
  def initialize(cmd)
    @cmd = cmd
  end

  def self.check_in_path
    ENV['HOME'] + '/.check_in'
  end

  def output
    if @cmd == 'in'
      check_in
    elsif @cmd == 'out'
      check_out
    else
      'Please call a valid command!'
    end
  end


  def check_in
    if FileTest.exists?(self.class.check_in_path)
      'You have already checked in!'
    else
      File.open(self.class.check_in_path, 'w') do |f|
        f << Time.now.to_s
      end
     "You are checked in as of: #{Time.now.hour}:#{Time.now.strftime('%m')}"
   end
 end

  def check_out
    if FileTest.exists?(self.class.check_in_path)
      string = ''
      File.open(self.class.check_in_path).each_line do |line|
          string = line
      end
      difference = Time.now - Time.parse(string)
      minutes = (difference / 60).round(0)
      FileUtils.rm(self.class.check_in_path)
      "You are checked out. Total time spent is: #{minutes} minutes"
    else
      'You have not checked in yet!'
    end
  end
end
