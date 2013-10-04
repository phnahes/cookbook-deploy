#
# Cookbook Name: Deploy
# Attribute: default
#

# Environments
default[:deploy]["env1"] 	= "homol"
default[:deploy]["env2"] 	= "prod"

# Bags and Packages List
default[:deploy]["bag"] 	= ""
default[:deploy]["pkgList"] 	= [ "" ]

# Shell Command to actuate on services
default[:deploy]["cmd"] 	= "/usr/bin/service"
