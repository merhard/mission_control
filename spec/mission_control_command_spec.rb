require 'rspec'

require_relative '../lib/mission_control_command'

describe MissionControlCommand do
  it 'acknowledges my check in' do
    cmd = MissionControlCommand.new('in')
    expect(cmd.output).to include('You are checked in')
  end
end
