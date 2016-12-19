describe Versi::GenerateCommand::Interactors::BuildReleaseTag do
  let(:tag_list) { ["2.3.2", "1.3.2"] }
  subject { described_class.call(options: options) }
  
  before do
    # Disable fetch_tags for test isolation of exterior world
    allow_any_instance_of(Versi::Interfaces::GitInterface).to receive(:fetch_tags)
    allow_any_instance_of(Versi::Interfaces::GitInterface).to receive(:list_tags).and_return(tag_list)
  end

  describe "#call" do
    describe "validations" do
      context "given no options argument" do
        it "should fail" do
          context = described_class.call({})
          expect(context).to be_failure
          expect(context.error).to be_a(ArgumentError)
        end
      end
    end

    context "given a custom release name" do
      let(:options) { { name: "3.2.1" } }

      it "should generate a release tag with the custom release name" do
         expect(subject).to be_success
         expect(subject.release_tag.name).to eq("3.2.1")
      end
    end

    context "given a semantic versioning release type" do
      context "given a patch semantic versioning release" do
        let(:options) { { type: "patch" } }
        
        it "should generate a \"2.3.3\" release tag" do
           expect(subject).to be_success
           expect(subject.release_tag.name).to eq("2.3.3")
        end

        context "given no releases yet" do
          let(:tag_list) { [] }

          it "should generate a \"0.0.1\" release tag" do
            expect(subject).to be_success
            expect(subject.release_tag.name).to eq("0.0.1")
          end
        end
      end

      context "given a minor semantic versioning release" do
        let(:options) { { type: "minor" } }
        
        it "should generate a \"2.4.0\" release tag" do
           expect(subject).to be_success
           expect(subject.release_tag.name).to eq("2.4.0")
        end
      end

      context "given a major semantic versioning release" do
        let(:options) { { type: "major" } }
        
        it "should generate a \"3.0.0\" release tag" do
           expect(subject).to be_success
           expect(subject.release_tag.name).to eq("3.0.0")
        end
      end
    end
    
    context "given full options" do
      let(:options) { { prefix:  "v",
                        suffix:  "pre1",
                        type:    "minor",
                        message: "Builds Scary Monsters and Nice Sprites" } }
      
      it "should build the tag name and message" do
        expected_tag_name    = "v2.4.0-pre1"
        expected_tag_message = "Builds Scary Monsters and Nice Sprites"
          
        expect(subject).to be_success
        expect(subject.release_tag.name).to    eq(expected_tag_name)
        expect(subject.release_tag.message).to eq(expected_tag_message)
      end
    end

    context "given no options" do
      def mock_last_commit_message(message)
        allow_any_instance_of(Versi::Interfaces::GitInterface).to \
          receive(:last_commit_message).and_return(message)
      end
      
      let(:options) { { } }
      
      context "given last commit is a merge from a branch containing hotfix/ as prefix" do
        before { mock_last_commit_message("Merge branch 'hotfix/add-theater' of foo.bar.com into master") }
        
        it "should generate a patch version change" do
          expect(subject).to be_success
          expect(subject.release_tag.name).to eq("2.3.3")
        end
        
        context "given last commit is a merge from a branch containing the feature word" do
          before { mock_last_commit_message("Merge branch 'hotfix/add-theater-feature' of foo.bar.com into master") }
          it "should generate a minor version change" do
            expect(subject).to be_success
            expect(subject.release_tag.name).to eq("2.4.0")
          end
        end
      end
      
      context "given last commit is a merge from a branch containing release/ as prefix" do
        before { mock_last_commit_message("Merge branch 'release/add-theater' of foo.bar.com into master") }
        
        it "should generate a minor version change" do
          expect(subject).to be_success
          expect(subject.release_tag.name).to eq("2.4.0")
        end
      end
      
      context "given last commit is a merge from a branch containing major-release/ as prefix" do
        before { mock_last_commit_message("Merge branch 'major-release/add-theater' of foo.bar.com into master") }
        
        it "should generate a major version change" do
          expect(subject).to be_success
          expect(subject.release_tag.name).to eq("3.0.0")
        end
      end
      
      context "given last commit is not a merge" do
        before { mock_last_commit_message("fix(opeth): Fix non-gutural albuns") }
        
        it "should fail with UnknownReleaseTypeError" do
          expect(subject).to be_failure
          expect(subject.error).to be_a(Versi::Errors::UnknownReleaseTypeError)
        end
      end
      
      context "given last commit is a merge from a branch without any known pattern" do
        before { mock_last_commit_message("Merge branch 'dream/add-theater' of foo.bar.com into feature/progressive-metal") }
        
        it "should fail with UnknownReleaseTypeError" do
          expect(subject).to be_failure
          expect(subject.error).to be_a(Versi::Errors::UnknownReleaseTypeError)
        end
      end
    end
  end
end
