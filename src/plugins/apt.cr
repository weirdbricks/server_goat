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

unless command_in_our_path?("apt")
  abort "apt not found"
end

if ARGV.size.zero?
  abort "no arguments given"
end

if ARGV.size != 2
  abort "need 2 arguments"
end

if ARGV[0] == "install" && !ARGV[1].nil?
  #command_output = `apt install #{ARGV[1]}`
#  command_output = `datez &>/dev/stdout`
#  command_exit_status = $?.exit_status
#  pp command_output
#  pp command_exit_status
  exit_code, command_output = run_cmd("sleep 5")
  puts exit_code
  puts command_output
end
