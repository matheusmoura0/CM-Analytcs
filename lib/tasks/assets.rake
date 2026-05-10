# Dummy assets task for Rails 8 compatibility with deployment platforms
namespace :assets do
  desc "Dummy assets:precompile task for Rails 8 - assets are handled differently"
  task :precompile do
    puts "Skipping assets:precompile - Rails 8 handles assets differently"
  end
end
