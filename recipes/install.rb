#
# Cookbook Name: Deploy
# Recipe: install
# 

dir_lock = "/var/r7/"

# Diretorio para arquivos de lock e temporarios
directory "#{dir_lock}" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

# Variavel para armazenar comando "postinst"
cmd_ubuntu  = node[:deploy]["cmd_ubuntu"]
cmd_centos  = node[:deploy]["cmd_centos"]
hash = Hash.new

node[:deploy]['install'].each do |bag, pkgs|
  #log "DataBag: #{bag}"
  pkgs.each do |packageId|
    #log "DataBag: #{bag} :: Pacote: #{packageId}"
    pkgLoop = data_bag_item(bag,packageId)

    if pkgLoop

      pkg_name = pkgLoop["package"] ||= pkgLoop["id"]

      # Se for algum ambiente listado no array abaixo, ele utiliza versao de producao
      if %w[ qa devel ].include? node.chef_environment
        pkg_version = pkgLoop["env"]["prod"]["version"]
      else
	pkg_version = pkgLoop["env"]["#{node.chef_environment}"]["version"]
      end

      if defined?(pkg_version)
	if not pkg_version.empty?

	  ruby_block "queueService#{packageId}" do
	    block do
	      if pkgLoop.has_key?("service")
		pkg_service_name   = pkgLoop["service"]["name"]
		pkg_service_action = pkgLoop["service"]["action"]
	      end

	      if defined?(pkg_service_name) 
		if not (pkg_service_name.nil? || pkg_service_name.empty?)
		  Chef::Log.info "Schedulling Service #{pkg_service_name} to #{pkg_service_action}..."
		  hash.merge! pkg_service_name => pkg_service_action
		end
	      end
	    end
	    action :nothing
	  end

	  # Ambientes listados
	  if %w[ prod homol staging ].include? node.chef_environment
	    package "#{pkg_name}" do
	      case node[:platform]
	      when "ubuntu", "debian"
		options "--force-yes"
	      when "centos", "redhat"
		options "-y"
	      end
	      version "#{pkg_version}"
	      ignore_failure true
	      notifies :create, "ruby_block[queueService#{packageId}]", :immediately
	      notifies :create, "ruby_block[queueServiceExec]", :delayed
	      notifies :run, "execute[post-cmd]", :delayed
	    end
	  else
	    # Bloco aplicado a ambientes nao listados acima (QA e Dev)
	    package "#{pkg_name}" do
	      case node[:platform]
	      when "ubuntu", "debian"
		options "--force-yes"
	      when "centos", "redhat"
		options "-y"
	      end
	      ignore_failure true
	      notifies :create, "ruby_block[queueService#{packageId}]", :immediately
	      notifies :create, "ruby_block[queueServiceExec]", :delayed
	      notifies :run, "execute[post-cmd]", :delayed
	      not_if { ::File.exists?("#{dir_lock}/chef-lock-install-#{pkg_name}") }
	    end

	    execute "lock-install-#{pkg_name}" do
	      command "touch #{dir_lock}/lock-install-#{pkg_name}"
	      not_if { ::File.exists?("#{dir_lock}/chef-lock-install-#{pkg_name}") }
	    end

	  end
	end
      end
    end
  end
end

ruby_block "queueServiceExec" do
  block do
    #hash.each { |srv, act| Chef::Log.info "queueServiceExec: #{srv} -> #{act}" }
    if not hash.empty?
      hash.each do |srv, act|
	case node["platform"]
	when "ubuntu"	
	  Chef::Log.info "Running: #{cmd_ubuntu} #{srv} #{act}"
	  cmd_exec = Chef::ShellOut.new( %Q[ #{cmd_ubuntu} #{srv} #{act} ] ).run_command

	when "centos"
	  cmd_concat = "#{cmd_centos}/#{srv}"
	  Chef::Log.info "Running: #{cmd_concat} #{act}"
	  cmd_exec = Chef::ShellOut.new( %Q[ #{cmd_concat} #{act} ] ).run_command

	end
	unless cmd_exec.exitstatus == 0
	  Chef::Application.fatal!("Error on #{act} #{srv}")
	end
      end
    end
  end
  action :nothing
end


if node[:deploy]['post-cmd']
  execute "post-cmd" do
    command "#{node[:deploy]['post-cmd']}"
    action :nothing
  end
end
