require "rescue_interactor"

class Versi < Clamp::Command
  class BranchCommand < Clamp::Command
    class Interactors
      class BuildReleaseBranchName
        include RescueInteractor
        
        DEFAULT_BRANCH_PREFIX = "release"

        before :setup

        def call
          branch_prefix = DEFAULT_BRANCH_PREFIX
          if context.release_name == Versi::Util::SemanticReleaseTypes::MAJOR
            branch_prefix = "major-release"
          end
          
          context.branch_name = "#{branch_prefix}/#{context.release_name}"
          Versi::LOG.info("The branch name will be #{context.branch_name}")
        end

        private

        def setup
          raise(ArgumentError, "Missing options argument") if !context.options
          raise(ArgumentError, "Missing release_name argument") if !context.release_name
        end
      end
    end
  end
end
