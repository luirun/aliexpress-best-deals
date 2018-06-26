set :stage, :production
set :rails_env, :production
set :branch, "master"

server "193.70.114.252", user: "deployer", roles: %w{app db web}