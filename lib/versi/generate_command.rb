require "versi/generate_command/interactors/generate_release"

class Versi < Clamp::Command
  class GenerateCommand < Clamp::Command
    option ["-t", "--type"],    "TYPE",    "The release type #{Versi::Util::SemanticReleaseTypes.pretty_list}"
    option ["-n", "--name"],    "NAME",    "The release tag name"
    option ["-p", "--prefix"],  "PREFIX",  "The release tag prefix"
    option ["-m", "--message"], "MESSAGE", "The release tag annotation message"
    option ["-r", "--remote"],  "REMOTE",  "The remote git server that will be used"
    option ["-d", "--debug"],   :flag,     "This flag will prevent the command from persisting the release tag"

    def execute
      validate
      if options[:debug]
        context = Versi::GenerateCommand::Interactors::BuildReleaseTag.call(options: options)
      else
        context = Versi::GenerateCommand::Interactors::GenerateCommandRelease.call(options: options)
      end
      
      if context.error
        raise context.error
      end
    end
    
    private
    
    def validate
      if options[:type] != nil && !Versi::Util::SemanticReleaseTypes::ALL.include?(options[:type])
        raise "Invalid release type: \"#{options[:type]}\". The valid ones are: #{Versi::Util::SemanticReleaseTypes.pretty_list}"
      end
    end
    
    def options
      { type:    type,
        name:    name,
        prefix:  prefix,
        message: message,
        remote:  remote,
        debug:   debug? }
    end
  end
end
