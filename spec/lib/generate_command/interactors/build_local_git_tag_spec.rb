describe Versi::GenerateCommand::Interactors::BuildLocalGitTag do
  let(:release_name) { "3.2.5" }
  let(:release_tag)  { Versi::Transients::GitTag.new(release_name, "Something") }
  
  subject { described_class.call(release_tag: release_tag) }
  
  describe "#call" do
    describe "validations" do
      context "given no release_name argument" do
        it "should fail" do
          context = described_class.call({})
          expect(context).to be_failure
          expect(context.error).to be_a(ArgumentError)
        end
      end
    end

    it "should call the push_tag from git interface" do
      expect_any_instance_of(Versi::Interfaces::GitInterface).to \
        receive(:create_tag).with(release_tag.name, release_tag.message)
      expect(subject).to be_success
    end
  end
end
