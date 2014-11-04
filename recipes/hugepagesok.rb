#<
# Installs TokuMX with workarounds to allow running with transparent hugepages
# (primarily for hosted CI environments).
#
# TokuMX requires transparent huge pages to be disabled at the kernel level.
# Indeed, it attempts to force the issue during boot. In some cases, however
# you may be running in a container where you don't control the kernel - this
# happens to us (Crowdtap) in CircleCI. Tokutek begrudgingly pointed out the
# existence of a variable to prevent the failure assertion in the mongod itself.
# This recipe takes other various workaround to make it actually install
# and start in spite of this setting.
#
#>


# prevent installation of server from starting it (which will fail due to
# hugepage setting, thus failing the install); allow other services to be
# modified - especially let mongodb be stopped.
file '/usr/sbin/policy-rc.d' do
  owner 'root'
  group 'root'
  mode 0755
  action :create_if_missing
  notifies :delete, 'file[/usr/sbin/policy-rc.d]', :delayed
  content <<EOF
#!/bin/bash
while [ $# -gt 3 ]; do
  shift
done

if [ $0 = tokumx ]; then
  exit 101
fi

exit 0
EOF
end

include_recipe 'tokumx::package'

edit_init_script = Chef::Util::FileEdit.new('/etc/init/tokumx.conf')
edit_init_script.search_file_delete_line('echo never > /sys/kernel/mm/transparent_hugepage/enabled')
edit_init_script.write_file

file '/etc/default/tokumx' do
  content 'export TOKU_HUGE_PAGES_OK=1'
  action :create_if_missing
  notifies :start, 'service[tokumx]'
end
