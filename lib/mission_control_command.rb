class MissionControlCommand
  def initialize(cmd)
    @cmd = cmd
  end

  def output
    if @cmd == 'in'
      'You are checked in'
    else
      'You are checked out'
    end
  end
end
