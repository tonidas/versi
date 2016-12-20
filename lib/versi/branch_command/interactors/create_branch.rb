require "versi/branch_command/interactors/build_release_branch_name"
require "versi/branch_command/interactors/create_release_branch"

class Versi < Clamp::Command
  class BranchCommand < Clamp::Command
    class Interactors
      class CreateBranch
        include Interactor::Organizer

        INTERACTORS = [Versi::BranchCommand::Interactors::BuildReleaseBranchName,
                       Versi::BranchCommand::Interactors::CreateReleaseBranch]

        organize(*INTERACTORS)
      end
    end
  end
end
