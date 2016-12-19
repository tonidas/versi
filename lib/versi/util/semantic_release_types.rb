require "set"

class Versi < Clamp::Command
  module Util
    class SemanticReleaseTypes
      PATCH = "patch".freeze
      MINOR = "minor".freeze
      MAJOR = "major".freeze
      ALL   = Set.new([PATCH, MINOR, MAJOR])
      
      def self.pretty_list
        ALL.to_a.to_s
      end
    end
  end
end
