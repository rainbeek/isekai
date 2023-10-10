# frozen_string_literal: true

source 'https://rubygems.org'

gem 'danger'
gem 'fastlane'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
# No use of defined variable is a workaround
# for Gemfile parsing failure in dependabot.
# See https://github.com/dependabot/dependabot-core/issues/1720#issuecomment-600831687
eval_gemfile('fastlane/Pluginfile') if File.exist?(plugins_path)
