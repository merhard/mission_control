require 'rspec'
require 'time'

require_relative '../lib/mission_control_command'

describe MissionControlCommand do
 

  context 'checking in' do
    let(:cmd) {cmd = MissionControlCommand.new('in')}
    let(:check_in_path) {cmd.class.check_in_path}

    it 'acknowledges my check in' do
      if FileTest.exists?(check_in_path)
        FileUtils.rm(check_in_path)
      end
      expect(cmd.output).to include('You are checked in')
    end

    it 'creates a check in file' do
      if FileTest.exists?(check_in_path)
        FileUtils.rm(check_in_path)
      end

      cmd.output
      expect(FileTest.exists?(check_in_path)).to be_true
    end

    it 'checks if file exists before creating' do
      File.open(check_in_path, 'w') do |f|
          f << ' '
      end
      expect(cmd.output).to eq('You have already checked in!')
    end

    it 'puts the time into the file' do
      if FileTest.exists?(check_in_path)
        FileUtils.rm(check_in_path)
      end
      cmd.output
      string = ''
      File.open(check_in_path).each_line do |line|
        string = line
      end
      expect(Time.parse(string).to_s).to include(Time.now.to_s)
    end

    it 'returns the check in time' do
      if FileTest.exists?(check_in_path)
        FileUtils.rm(check_in_path)
      end
      expect(cmd.output).to include("#{Time.now.hour}:#{Time.now.min}")
    end

  end


  context 'checking out' do
    let(:cmd) {cmd = MissionControlCommand.new('out')}
    let(:check_in_path) {cmd.class.check_in_path}

    before(:each) do
      unless FileTest.exists?(check_in_path)
        File.open(check_in_path, 'w') do |f|
          f << "#{Time.now}"
        end
      end
    end

    it 'acknowledges my check out' do
      expect(cmd.output).to include('You are checked out')
    end

    it 'removes a check in file' do
      cmd.output
      expect(FileTest.exists?(check_in_path)).to be_false
    end

    it 'returns you have not checked in yet so you cannot check out' do
      if FileTest.exists?(check_in_path)
        FileUtils.rm(check_in_path)
      end
      expect(cmd.output).to eql("You have not checked in yet!")
    end

    it 'returns your time difference' do
      string = ''
      File.open(check_in_path).each_line do |line|
          string = line
      end
      difference = Time.now - Time.parse(string)
      minutes = (difference / 60).round(0)
      cmd = MissionControlCommand.new('out')
      expect(cmd.output).to include(minutes.to_s)
    end
  end
end
