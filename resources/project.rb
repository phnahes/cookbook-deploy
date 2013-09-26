#
# Author:: Paulo Nahes <phnahes@gmail.com>
# Cookbook Name:: deploy
# Resource:: project
#

actions :deploy, :nothing
default_action :nothing

attribute :package, :name_attribute => true, :kind_of => String, :required => true
attribute :version, :kind_of => String, :required => true
attribute :service, :kind_of => String, :required => true
attribute :doit, :kind_of => String, :required => true
