require "rescue_interactor"

class Versi < Clamp::Command
  class GenerateCommand < Clamp::Command
    class Interactors
      class ExtractReleaseTypeFromCommitMessage
        include RescueInteractor
        
        MERGE_COMMIT_REGEXES = [MERGE_COMMIT_REGEX_BITBUCKET = /.*Merge\sbranch\s\'(.*)\'.*/,
                                MERGE_COMMIT_REGEX_GITHUB = /.*Merge.*from\s([^\s]*).*/,
                                MERGE_COMMIT_REGEX_GIT = /.*Merged\s([^\s]*)\sinto\s([^\s]*).*/]

        before :setup

        def call
          source_branch = extract_source_branch
          return if !source_branch
          
          context.release_type = extract_release_type_from_merge_source_branch(source_branch)
        end

        private

        def setup
          raise(ArgumentError, "Missing commit_message argument") if !context.commit_message
        end
        
        def extract_source_branch
          MERGE_COMMIT_REGEXES.each do |regex|
            match_data = context.commit_message.match(regex)
            return match_data[1] if match_data && match_data[1]
          end
          # The nil here is to ensure that the nil value will be returned if
          # the commit_message doesn't match any regex
          nil
        end
        
        def extract_release_type_from_merge_source_branch(source_branch)
          if source_branch.start_with?("hotfix/")
            if source_branch =~ /feature/i
              Versi::Util::SemanticReleaseTypes::MINOR
            else
              Versi::Util::SemanticReleaseTypes::PATCH
            end
          elsif source_branch.start_with?("release/")
            Versi::Util::SemanticReleaseTypes::MINOR
          elsif source_branch.start_with?("major-release/")
            Versi::Util::SemanticReleaseTypes::MAJOR
          end
        end
      end
    end
  end
end
