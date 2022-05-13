# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
conf = File.join(Rails.root, 'config', 'set.rb')
load(conf) if File.exist?(conf)
Rails.application.initialize!
