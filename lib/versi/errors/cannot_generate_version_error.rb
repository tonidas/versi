class Versi < Clamp::Command
  module Errors
    class CannotGenerateCommandVersionError < StandardError
      def initialize(release_type)
        super("Cannot generate '#{release_type}' release of a project that don't use Semantic Versioning." \
            + " You have two options: Use Semantic Versioning or type your own release name")
      end
    end
  end
end
