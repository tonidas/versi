require "clamp"
require "versi/all"

class Versi < Clamp::Command
  subcommand "generate", "Generate a release git version", Versi::GenerateCommand
end
