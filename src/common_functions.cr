require "process"

def command_in_our_path?(command_name)
  Process.find_executable(command_name)
end

def run_cmd(cmd)
  stdout = IO::Memory.new
  stderr = IO::Memory.new
  status = Process.run(cmd, output: stdout, error: stderr,shell: true)
  if status.success?
    {status.exit_code, stdout.to_s}
  else
    {status.exit_code, stderr.to_s}
  end
end
