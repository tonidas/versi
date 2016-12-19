class Versi < Clamp::Command
  module Errors
    class UnknownReleaseTypeError < StandardError
      def initialize
        super("Versi was unable to discover the release type #{Versi::Util::SemanticReleaseTypes.pretty_list}" \
            + " you want to generate. If its your first version, please provide the release name or release type")
      end
    end
  end
end
