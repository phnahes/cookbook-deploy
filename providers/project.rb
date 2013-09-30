#
# Author:: Paulo Nahes <phnahes@gmail.com>
# Cookbook Name:: deploy
# Provider:: project
#

def whyrun_supported?
  true
end

action :deploy do
	Chef::Log.info "#{ @new_resource } doing the magic."

	pkg_name 	= new_resource.package
	pkg_version 	= new_resource.version
	pkg_service 	= new_resource.service
	pkg_doit 	= new_resource.doit

	package "#{pkg_name}" do
		version "#{pkg_version}"
		ignore_failure true
	end

	if defined? pkg_service
		if not pkg_service.empty?
			execute "service #{pkg_service} #{pkg_doit}"
		end
	end
end

action :nothing do 
	Chef::Log.info "#{ @new_resource } Nothing to do! (action :nothing)"
	Chef::Log.info "#{new_resource.package} #{new_resource.version} #{new_resource.service} #{new_resource.doit}"
end
