require "process"

def command_in_our_path?(command_name)
  Process.find_executable(command_name)
end

def check_if_file_exists(filename)
  unless File.file?(filename)
    abort "Sorry, but I cannot find the file \"#{filename}\""
  end
end

def run_cmd(cmd)
  stdout = IO::Memory.new
  stderr = IO::Memory.new
  status = Process.run(cmd, output: stdout, error: stderr, shell: true)
  if status.success?
    {status.exit_code, stdout.to_s}
  else
    {status.exit_code, stderr.to_s}
  end
end
