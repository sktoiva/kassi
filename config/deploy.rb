ssh_options[:verbose] = :debug 

set :application, "Kassi"
set :repository,  "svn+ssh://alpha.sizl.org/svn/kassi/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:

set :deploy_to, "/var/datat/kassi"
#set :deploy_to, "/usr/local/kassi"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

# role :app, "maps.cs.hut.fi"
# role :web, "maps.cs.hut.fi"
# role :db,  "maps.cs.hut.fi", :primary => true

role :app, "alpha.sizl.org"
role :web, "alpha.sizl.org"
role :db,  "alpha.sizl.org", :primary => true

set :use_sudo, false


namespace :deploy do
  task :symlink_listing_images do
    run "rm -rf #{release_path}/public/images/listing_images"
    run "ln -fs #{shared_path}/listing_images/ #{release_path}/public/images/listing_images"  
  end  
end

after 'deploy:update_code', 'deploy:symlink_listing_images'
