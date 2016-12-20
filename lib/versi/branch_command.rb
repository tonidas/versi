require "versi/branch_command/interactors/create_branch"

class Versi < Clamp::Command
  class BranchCommand < Clamp::Command
    option ["-t", "--type"],  "TYPE", "The release type #{Versi::Util::SemanticReleaseTypes.pretty_list}", required: true
    option ["-d", "--debug"], :flag,  "This flag will prevent the command from creating branchs"

    def execute
      validate
      
      context = Versi::GenerateCommand::Interactors::BuildReleaseTag.call(options: options)
      raise context.error if context.error
      release_name = context.release_name
      
      if debug?
        context = Versi::BranchCommand::Interactors::BuildReleaseBranchName \
                    .call(options: options, release_name: release_name)
        Versi::LOG.info("No branch will be created, because we are in debug mode")
      else
        context = Versi::BranchCommand::Interactors::CreateBranch \
                    .call(options: options, release_name: release_name)
      end
      
      if context.error
        raise context.error
      end
    end
    
    private
    
    def validate
      if !Versi::Util::SemanticReleaseTypes::ALL.include?(options[:type])
        raise "Invalid release type: \"#{options[:type]}\". The valid ones are: #{Versi::Util::SemanticReleaseTypes.pretty_list}"
      end
    end
    
    def options
      { type: type }
    end
  end
end
