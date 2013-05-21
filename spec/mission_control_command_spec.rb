require 'rspec'

require_relative '../lib/mission_control_command'

describe MissionControlCommand do
  it 'acknowledges my check in' do
    cmd = MissionControlCommand.new('in')
    expect(cmd.output).to include('You are checked in')
  end

  it 'acknowledges my check out' do
    cmd = MissionControlCommand.new('out')
    expect(cmd.output).to include('You are checked out')
  end


end
