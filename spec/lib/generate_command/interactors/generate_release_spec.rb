describe Versi::GenerateCommand::Interactors::GenerateCommandRelease do
  let(:interactors_module) { Versi::GenerateCommand::Interactors }
  let(:interactors)        { described_class::INTERACTORS }
  let(:release_name)       { "3.2.5" }
  let(:release_tag)        { Versi::Transients::GitTag.new(release_name, "Release #{release_name}") }

  def expect_interactor(interactor_class)
    allow_any_instance_of(interactor_class)
  end

  def mock_interactor(interactor_class)
    expect_interactor(interactor_class).to receive(:call)
  end

  def errorize_interactor(interactor_class)
    expect_interactor(interactor_class).to receive(:call).and_raise("error!")
  end

  describe "#call" do
    context "given an error on the last interactor (PushGitTag)" do
      subject { described_class.call(options:      {}, 
                                     release_name: release_name,
                                     release_tag:  release_tag) }

      before do
        last_interactor = interactors.pop
        interactors.each { |interactor| mock_interactor(interactor) }
        errorize_interactor(last_interactor)
      end

      it "should call rollback of each rollbackable interactor" do
        expect_any_instance_of(Versi::Interfaces::GitInterface).to \
          receive(:delete_tag).with(release_name).and_return(true)
        expect_interactor(interactors_module::BuildLocalGitTag).to receive(:rollback).and_call_original
        
        expect(subject).to be_failure
      end
    end
  end
end
