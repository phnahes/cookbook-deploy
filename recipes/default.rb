#
# Cookbook Name: Deploy
# Recipe: default
# 

cmd  	= node[:deploy]["cmd"]
hash 	= Hash.new

env1	= node[:deploy]["env1"]
env2	= node[:deploy]["env2"]

node[:deploy]['install'].each do |bag, pkgs|
	log "DataBag: #{bag}"
	pkgs.each do |packageName|
		log "DataBag: #{bag} :: Pacote: #{packageName}"
		pkgLoop = data_bag_item(bag,packageName)

		if pkgLoop
			pkg_env1 	= pkgLoop["#{env1}"]["version"]
			pkg_env2  	= pkgLoop["#{env2}"]["version"]
			
			pkg_name = pkgLoop["id"]

			case node.chef_environment
			when "#{env1}" # Environment 1
				pkg_version = pkg_env1
			when "#{env2}"  # Environment 2
				pkg_version = pkg_env2
			end

			if defined? pkg_version
				if not pkg_version.empty?

					ruby_block "queueService" do
						block do
							pkg_service_name 	= pkgLoop["service"]["name"]
							pkg_service_action 	= pkgLoop["service"]["action"]

							if defined? pkg_service_name
								if not pkg_service_name.empty?
									#log "Schedulling Service #{pkg_service_name} to #{pkg_service_action} ..."
									hash.merge! pkg_service_name => pkg_service_action
								end
							end
						end
						action :nothing
					end				
					package "#{pkg_name}" do
						version "#{pkg_version}"
						options "--force-yes"
						ignore_failure true
						notifies :create, "ruby_block[queueService]", :immediately
					end

				end
			end
		end			
	end
end

hash.each do |srv,act|
	execute "#{cmd} #{srv} #{act}"
end

