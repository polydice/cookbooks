#
# See the README for a description of each attribute.
#

# required
default[:scout][:key] = nil

# optional
default[:scout][:user] = "scout"
default[:scout][:group] = "scout"
default[:scout][:name] = nil
default[:scout][:roles] = nil
default[:scout][:scout_bin] = nil
default[:scout][:version] = nil
default[:scout][:public_key] = nil
default[:scout][:http_proxy] = nil
default[:scout][:https_proxy] = nil
default[:scout][:delete_on_shutdown] = false	# create rc.d script to remove the server from scout on shutdown
default[:scout][:plugin_gems] = []   # list of gems to install to support plugins for role
