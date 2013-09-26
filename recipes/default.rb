#
# Packages Installation
# 

bag  	= node[:deploy]["bag"]
pkgList = node[:deploy]["pkgList"]

pkgList.each do |packageName|
	pkgLoop = data_bag_item(bag, packageName)

	if pkgLoop
		pkg_homol 	= pkgLoop["homol"]["version"]
		pkg_prod  	= pkgLoop["prod"]["version"]
		
		pkg_name = pkgLoop["id"]

		case node.chef_environment
		when "homol"
			pkg_version = pkg_homol
		when "prod"
			pkg_version = pkg_prod
		end

		if defined? pkg_version
			if not pkg_version.empty?

				# deploy_project - Just run if there are versions
				pkg_service_name 	= pkgLoop["service"]["name"]
				pkg_service_action 	= pkgLoop["service"]["action"]

				deploy_project "#{pkg_name}" do 
					version "#{pkg_version}"
					service "#{pkg_service_name}"
					doit	"#{pkg_service_action}"
					action :deploy
				end
			end
		end
	end
end


