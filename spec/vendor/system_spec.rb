describe System do
  subject { described_class }

  let(:statement) { "ps aux | grep ruby" }
  let(:command) { double('command', to_s: statement) }

  describe ".call" do
    it "calls Open3 with the command" do
      expect(Open3).to receive(:popen3).with(statement)
      subject.call(command)
    end
  end

  describe ".call!" do
    context "given a command that return status code 0" do
      before do
        expect(subject).to receive(:call).with(command).
          and_return(double(exit_status: 0, stderr: ""))
      end

      it "should not raise error" do
        expect { subject.call!(command) }.to_not raise_error
      end
    end

    context "given a command that return status code 31" do
      before do
        expect(subject).to receive(:call).with(command).
          and_return(double(exit_status: 31, stderr: "Agent detected!"))
      end

      it "should raise error" do
        expect { subject.call!(command) }.to \
         raise_error(described_class::CommandError,
                     /status\ code\ 31.*\n.*\n.*Agent\ detected\!/)
      end
    end
  end
end
