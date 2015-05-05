#
# Cookbook Name: Deploy
# Attribute: default
#


# Bags and Packages List
default[:deploy]["bag"] 	= ""
default[:deploy]["pkgList"] 	= [ "" ]

# Shell Command to actuate on services
default[:deploy]["cmd_ubuntu"] 	= "/usr/bin/service"
default[:deploy]["cmd_centos"] 	= "/etc/init.d"

default[:deploy]['install'] = { }

# Command to execute post
default[:deploy]["post-cmd"] = "echo"
default[:deploy][:block_ip] = [ '' ]
