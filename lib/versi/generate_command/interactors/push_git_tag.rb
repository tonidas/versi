require "rescue_interactor"

class Versi < Clamp::Command
  class GenerateCommand < Clamp::Command
    class Interactors
      class PushGitTag
        include RescueInteractor

        before :setup

        def call
          @git.push_tag(context.release_tag.name)
        end

        def rollback
          Versi::LOG.warn("Triggered rollback for the pushing of git tag: #{context.release_tag.name}")
          if git.delete_tag_remote(context.release_tag.name)
            Versi::LOG.warn("Rollback was successful")
          else
            Versi::LOG.warn("There was an error on the rollback!")
          end
        end

        private

        def setup
          raise(ArgumentError, "Missing release_tag argument") if !context.release_tag
          remote = context.options ? context.options[:remote] : nil
          @git = Versi::Interfaces::GitInterface.new(remote: remote)
        end
      end
    end
  end
end
