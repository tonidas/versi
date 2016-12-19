class Versi < Clamp::Command
  module Transients
    GitTag = Struct.new(:name, :message)
  end
end
