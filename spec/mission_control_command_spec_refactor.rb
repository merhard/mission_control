require 'rspec'
require 'time'

require_relative '../lib/mission_control_command'

describe MissionControlCommand do
  let(:check_in_path) {MissionControlCommand.check_in_path}

  context 'check in' do
    let(:cmd) {cmd = MissionControlCommand.new('in')}

    context 'file does not exist' do
      before(:each) do
        if FileTest.exists?(check_in_path)
          File.delete(check_in_path)
        end
      end

      it 'acknowledges my check in' do
        expect(cmd.output).to include('You are checked in')
      end

      it 'creates a check in file' do
        cmd.output
        expect(FileTest.exists?(check_in_path)).to be_true
      end

      it 'puts the time into the file' do
        cmd.output

        string = ''
        File.open(check_in_path).each_line do |line|
          string = line
        end

        expect(Time.parse(string).to_s).to include(Time.now.to_s)
      end

      it 'returns the check in time' do
        expect(cmd.output).to include("#{Time.now.strftime('%l:%M %p')}")
      end
    end

    context 'file already exists' do
      before(:each) do
        unless FileTest.exists?(check_in_path)
          File.open(self.class.check_in_path, 'w') do |f|
            f << Time.now.to_s
          end
        end
      end

      it 'checks if file exists before creating' do
        expect(cmd.output).to eq('You have already checked in!')
      end
    end
  end

  context 'check out' do
    let(:cmd) {cmd = MissionControlCommand.new('out')}

    context 'file does not exist' do
      before(:each) do
        if FileTest.exists?(check_in_path)
          File.delete(check_in_path)
        end
      end

      it 'returns you have not checked in yet so you cannot check out' do
        expect(cmd.output).to eql("You have not checked in yet!")
      end
    end

    context 'file already exists' do
      before(:each) do
        unless FileTest.exists?(check_in_path)
          File.open(check_in_path, 'w') do |f|
            f << Time.now.to_s
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

      it 'returns your time difference' do
        string = ''
        File.open(check_in_path).each_line do |line|
          string = line
        end

        difference = Time.now - Time.parse(string)
        minutes = (difference / 60).round(0)

        expect(cmd.output).to include(minutes.to_s)
      end
    end
  end

  it 'responds to a command other than in/out' do
    cmd = MissionControlCommand.new
    expect(cmd.output).to eq('Please call a valid command!')
  end
end
