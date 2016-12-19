require "versi/generate_command/interactors/build_release_tag"
require "versi/generate_command/interactors/build_local_git_tag"
require "versi/generate_command/interactors/push_git_tag"

class Versi < Clamp::Command
  class GenerateCommand < Clamp::Command
    class Interactors
      class GenerateCommandRelease
        include Interactor::Organizer

        INTERACTORS = [Versi::GenerateCommand::Interactors::BuildReleaseTag,
                       Versi::GenerateCommand::Interactors::BuildLocalGitTag,
                       Versi::GenerateCommand::Interactors::PushGitTag]

        organize(*INTERACTORS)
      end
    end
  end
end
