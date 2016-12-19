require "logger"

class Versi < Clamp::Command
  LOG = Logger.new(STDOUT)
  
  LOG.formatter = proc do |severity, datetime, progname, msg|
    "Versi@[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}]: #{msg}\n"
  end
end
