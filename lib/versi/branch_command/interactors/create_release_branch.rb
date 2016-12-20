require "rescue_interactor"

class Versi < Clamp::Command
  class BranchCommand < Clamp::Command
    class Interactors
      class CreateReleaseBranch
        include RescueInteractor

        before :setup

        def call
          @git.create_branch(context.branch_name)
        end

        private

        def setup
          raise(ArgumentError, "Missing branch_name argument") if !context.branch_name
          @git = Versi::Interfaces::GitInterface.new
        end
      end
    end
  end
end
