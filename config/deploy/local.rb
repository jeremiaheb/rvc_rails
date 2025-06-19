set :stage, :vagrant
set :rails_env, "production"

server "127.0.0.1", user: "rvcrails", roles: %w[app web db]
set :repo_url, File.realpath(File.join(File.dirname(__FILE__), "..", ".."))