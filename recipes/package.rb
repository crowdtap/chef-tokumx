#<
# Installs Tokutek on Ubuntu using the apt repositories provided by Tokutek.
#>
# install these resources ...
apt_repository node.tokumx.repo.name do
  uri node.tokumx.repo.uri
  keyserver 'keyserver.ubuntu.com'
  key '505A7412'
  arch 'amd64'
  distribution node['lsb']['codename']
  components   ['main']
end

package node.tokumx.package

# which provide ...
#
node.default.tokumx.user = 'tokumx'
node.default.tokumx.group = 'tokumx'

service 'tokumx' do
  provider Chef::Provider::Service::Upstart
  action :nothing
end
