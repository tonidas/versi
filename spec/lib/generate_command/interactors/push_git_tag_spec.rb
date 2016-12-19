describe Versi::GenerateCommand::Interactors::PushGitTag do
  let(:release_tag) { Versi::Transients::GitTag.new("v3.2.5-pre", "Something") }
  subject { described_class.call(release_tag: release_tag) }

  describe "#call" do
    describe "validations" do
      context "given no release_tag argument" do
        it "should fail" do
          context = described_class.call({})
          expect(context).to be_failure
          expect(context.error).to be_a(ArgumentError)
        end
      end
    end

    it "should call the push_tag from git interface" do
      expect_any_instance_of(Versi::Interfaces::GitInterface).to \
        receive(:push_tag).with(release_tag.name)
      expect(subject).to be_success
    end
  end
end
