require "rescue_interactor"

class Versi < Clamp::Command
  class GenerateCommand < Clamp::Command
    class Interactors
      class BuildLocalGitTag
        include RescueInteractor

        before :setup

        def call
          @git.create_tag(context.release_tag.name, context.release_tag.message)
        end

        def rollback
          Versi::LOG.warn("Triggered rollback for the local git tag creation: #{context.release_tag.name}")
          if @git.delete_tag(context.release_tag.name)
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
