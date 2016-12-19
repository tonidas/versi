require "open3"

class System
  class CommandError < StandardError; end

  class << self
    def call(command)
      command = command.to_s
      result = Struct.new(:stdout,
                          :stderr,
                          :exit_status).new([], [], 0)

      Open3.popen3(command) do |stdin, stdout, stderr, thread|
        Thread.new do
          until (line = stdout.gets).nil? do
            result.stdout << line
          end
          result.stdout = result.stdout.join("\n")
        end

        Thread.new do
          until (line = stderr.gets).nil? do
            result.stderr << line
          end
          result.stderr = result.stderr.join("\n")
        end

        thread.join
        result.exit_status = thread.value
      end

      result
    end

    def call!(command)
      call(command).tap do |response|
        raise(System::CommandError,
              "Error running \"#{command.to_s}\" (Exited with status code #{response.exit_status}) \n" \
            + "STDERR: \n#{response.stderr}") if response.exit_status != 0
      end
    end
  end
end
