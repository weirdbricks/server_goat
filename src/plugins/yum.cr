require "../common_functions.cr"

module YUM
  extend self 

#  unless command_in_our_path?("yum")
#    abort "yum not found"
#  end

  # returns true if the package is already installed
  # returns false if the package is not installed
  def check_if_yum_package_is_installed(name_of_package)
    exit_code, command_output = run_cmd("yum list installed #{name_of_package}")
    return exit_code, command_output
  end

  def get_real_yum_package_name(name_of_package)
    exit_code, command_output = run_cmd("yum provides #{name_of_package}")
    if exit_code.zero?
      # we convert the string to an array by splitting on new lines
      command_output = command_output.split("\n")
      # any empty lines should be removed as well as lines that we don't need from the array
      command_output.reject! { |line| line.empty? || line.starts_with?("Repo") || line.starts_with?("Matched from:") || line.starts_with?("Provide") || line.starts_with?("Last metadata expiration check") }
      # what's left should be the package name - it will look like this:
      # "mysql-8.0.30-1.module_el8.6.0+3340+d764b636.x86_64 : MySQL client programs and shared libraries"
      # so we split on " : " and keep only the first part which is the real package name
      result = command_output.first.split(" : ")[0]
      return exit_code, result
    else
      return exit_code, command_output
    end
  end

  def install_yum_package(name_of_package)
    exit_code, command_output = run_cmd("yum --assumeyes install #{name_of_package}")
    return exit_code, command_output
  end

  def remove_yum_package(name_of_package)
    exit_code, command_output = run_cmd("yum --assumeyes remove #{name_of_package}")
    return exit_code, command_output
  end

  def install_yum_package(package_name)
    exit_code, package_name = get_real_yum_package_name(package_name)
    if exit_code.zero?
      puts "Using package name: \"#{package_name}\""
    else
      abort "Cannot find package: \"#{package_name.delete('\n')}\""
    end
    if check_if_yum_package_is_installed(package_name)[0].zero?
      puts "package \"#{package_name}\": already installed"
    else
      puts "package \"#{package_name}\": Not installed"
      exit_code, command_output = install_yum_package(package_name)
      if exit_code.zero?
        puts "package \"#{package_name}\": Successfully installed"
      else
        abort "package \"#{package_name}\": Could not install: Error: #{command_output}"
      end
    end
  end

  def remove_yum_package(package_name)
    exit_code, package_name = get_real_yum_package_name(package_name)
    if exit_code.zero?
      puts "Using package name: \"#{package_name}\""
    else
      abort "Cannot find package: \"#{package_name.delete('\n')}\""
    end
    if !check_if_yum_package_is_installed(package_name)[0].zero?
      puts "package \"#{package_name}\": Not installed"
      exit 0
    else
      puts "package \"#{package_name}\": already installed"
      exit_code, command_output = remove_yum_package(package_name)
      if exit_code.zero?
        puts "package \"#{package_name}\": Successfully removed"
      else
        abort "package \"#{package_name}\": Could not remove: Error: #{command_output}"
      end
    end
  end
end
