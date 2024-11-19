require 'bundler'
Bundler.require

require_relative 'app'
require_relative 'db/seeder'

run(QotdApi)