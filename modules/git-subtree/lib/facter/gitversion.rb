#
# Fact that retrieves the current installed version of git.
#
# On some Debian and Ubuntu versions, the package is called git-core
#

require 'puppet'

pkg = Puppet::Type.type(:package).new(:name => "git")
gitversion = pkg.retrieve[pkg.property(:ensure)].to_s

if gitversion == "purged" then
  pkg = Puppet::Type.type(:package).new(:name => "git-core")
  gitversion = pkg.retrieve[pkg.property(:ensure)].to_s
end

Facter.add("gitversion") do
  setcode do
    gitversion
  end
end
