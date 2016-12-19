require "rescue_interactor"
require "semantic"
require "versi/interfaces/git_interface"
require "versi/generate_command/interactors/extract_release_type_from_commit_message"

class Versi < Clamp::Command
  class GenerateCommand < Clamp::Command
    class Interactors
      class BuildReleaseTag
        include RescueInteractor

        before :setup

        def call
          context.latest_release_version = find_latest_release_version
          generate_release_name
          generate_release_tag
          Versi::LOG.info("Your latest release tag is \"#{context.latest_release_version.to_s}\"")
          Versi::LOG.info("Your next release tag will be \"#{context.release_tag.name}\"")
        end

        private

        def setup
          raise(ArgumentError, "Missing options argument") if !context.options
          remote = context.options ? context.options[:remote] : nil
          @git = Versi::Interfaces::GitInterface.new(remote: remote)
        end

        def generate_release_name
          if context.options[:name]
            context.release_name = context.options[:name]
          else
            release_type = context.options[:type]
            release_type ||= extract_release_type_from_last_commit_message
            
            raise(Versi::Errors::UnknownReleaseTypeError) if !release_type
            raise(Versi::Errors::CannotGenerateCommandVersionError, release_type) if !context.latest_release_version

            context.release_version = generate_next_semantic_version(release_type)
            context.release_name    = context.release_version.to_s
          end
        end
        
        def generate_release_tag
          context.release_tag = Versi::Transients::GitTag.new(build_tag_name, build_tag_message)
        end
        
        def build_tag_name
          suffix = context.options[:suffix] ? "-#{context.options[:suffix]}" : nil
          "#{context.options[:prefix]}#{context.release_name}#{suffix}"
        end
        
        def build_tag_message
          context.options[:message] || "Release #{context.release_name}"
        end
        
        def extract_release_type_from_last_commit_message
          Versi::GenerateCommand::Interactors::ExtractReleaseTypeFromCommitMessage \
            .call(commit_message: @git.last_commit_message)
            .release_type
        end

        def generate_next_semantic_version(release_type)
          context.latest_release_version.send("#{release_type}!")
        end

        def find_latest_release_version
          latest_version = nil
          @git.fetch_tags
          return Semantic::Version.new("0.0.0") if @git.list_tags.empty?
          
          @git.list_tags.each do |release_name|
            version = Semantic::Version.new(release_name) rescue next

            if latest_version
              latest_version = version if version > latest_version
            else
              latest_version = version
            end
          end

          latest_version ? latest_version : nil
        end
      end
    end
  end
end
