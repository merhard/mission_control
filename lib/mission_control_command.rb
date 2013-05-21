class MissionControlCommand
  def initialize(cmd)
    @cmd = cmd
  end

  def self.check_in_path
    ENV['HOME'] + '/.check_in'
  end

  def output
    if @cmd == 'in'
      File.open(self.class.check_in_path, 'w') do |f|
        f.puts 'checkedin'
      end
      'You are checked in'
    else
      'You are checked out'
    end
  end
end
