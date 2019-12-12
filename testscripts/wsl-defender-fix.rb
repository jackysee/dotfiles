#!/usr/bin/env ruby

ubuntu = Dir.glob("/mnt/c/Users/*/AppData/Local/Packages/CanonicalGroupLimited.*")
case ubuntu.size
  when 0
    # puts "# ERROR: Unable to detect any Ubuntu WSL /mnt/c/Users/*/AppData/Local/Packages/CanonicalGroupLimited.*"
    target = "ERROR-FINDING-UBUNTU_WSL_PATH"
  when 1
    # puts "# Found a single Ubuntu WSL target: ${ubuntu.first}"
    target = File.basename( ubuntu.first )
  else
    puts "#\n#\n# Found multiple Ubuntu WSL targets"
    ubuntu.each { |t| puts "# #{t}" }
    target = File.basename( ubuntu.first )
    puts "# Using first result: #{target}"
end
puts target

path = ENV['PATH'].split(':').map {|p| "\"#{ p.tr('/',%Q{\\}) }\"" }
puts "

#
# Windows PowerShell command to exclude all linux paths from defender:
#
$win_user = $env:UserName
$linux_user = \"#{ ENV['USER'] }\"
$package = \"#{target}\""

puts '$base_path = "C:\Users\" + $win_user + "AppData\Local\Packages" + $package + "\LocalState\rootfs"'

puts "$dirs = @( #{path.join(", ")} )"

puts '$dirs | ForEach { Add-MpPreference -ExclusionProcess ($base_path + $_ + "\*") }
Add-MpPreference -ExclusionPath $base_path'
