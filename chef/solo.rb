root = File.absolute_path(File.dirname(__FILE__))
file_cache_path root
cookbook_path '/var/chef/cookbooks'
role_path '/var/chef/roles'
data_bag_path '/var/chef/data_bags'
ssl_verify_mode :verify_peer
