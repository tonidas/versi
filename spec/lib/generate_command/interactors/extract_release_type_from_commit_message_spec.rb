describe Versi::GenerateCommand::Interactors::ExtractReleaseTypeFromCommitMessage do

  subject { described_class.call({ commit_message: commit_message }) }

  describe "#call" do
    describe "validations" do
      context "given no commit_message argument" do
        it "should fail" do
          context = described_class.call({})
          expect(context).to be_failure
          expect(context.error).to be_a(ArgumentError)
        end
      end
    end

    context "given a commit message that its not related to a merge" do
      let(:commit_message) { "feature(dream-theater): Builds new sucessful album for 2017\n" }

      it "should not generate any release_type" do
        expect(subject).to be_success
        expect(subject.release_type).to_not be
      end
    end
    
    context "given a commit message that its related to a merge" do
      context "given a merge of a hotfix branch" do
        let(:commit_message) { 
          "Merge branch 'hotfix/images-and-words' of some.repo into some/branch\n"
        }
        
        it "should return the patch release_type" do
          expect(subject).to be_success
          expect(subject.release_type).to eq(Versi::Util::SemanticReleaseTypes::PATCH)
        end
        
        context "given a merge of a branch containing the feature word" do
          let(:commit_message) { 
            "Merge pull request #4284 from hotfix/adds-awesome-FeAtuRe\n\n\n"
          }
          
          it "should return the minor release_type" do
            expect(subject).to be_success
            expect(subject.release_type).to eq(Versi::Util::SemanticReleaseTypes::MINOR)
          end
        end
      end
      
      context "given a merge of a release branch" do
        let(:commit_message) { 
          "Merged release/v1.8.5 into some/branch\n\n"
        }
        
        it "should return the minor release_type" do
          expect(subject).to be_success
          expect(subject.release_type).to eq(Versi::Util::SemanticReleaseTypes::MINOR)
        end
      end
      
      context "given a merge of a major-release branch" do
        let(:commit_message) { 
          "Merged major-release/v1.8.5 into some/branch\n\n"
        }
        
        it "should return the major release_type" do
          expect(subject).to be_success
          expect(subject.release_type).to eq(Versi::Util::SemanticReleaseTypes::MAJOR)
        end
      end
    end
  end
end
