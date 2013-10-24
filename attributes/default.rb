#
# Cookbook Name: Deploy
# Attribute: default
#

# Environments
default[:deploy]["env1"] 	= "homol"
default[:deploy]["env2"] 	= "prod"

# Shell Command to actuate on services
default[:deploy]["cmd"] 	= "/usr/bin/service"

# Bags and Packages List
default[:deploy]['install'] = { }

#default[:deploy]['install'] = { 
#	'deploy-db1' => ["db1par1", "db1par2", "db1par3"],
#	'deploy-db2' => ["db2par1", "db2par2", "db2par3"],
#	'deploy-db3' => ["db3par1", "db3par2", "db3par3"]
#}
