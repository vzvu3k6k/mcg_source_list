require 'sinatra/base'
require 'slim'
require 'redcarpet'
require 'builder'
require_relative './lib/source'

Mongoid.load!(File.expand_path("./config/mongoid.yml", __dir__))

class App < Sinatra::Base
  get '/' do
    slim :index, locals: {
      sources: Source.all.sort(last_used_at: -1).limit(100),
      styles: %w(index),
    }
  end

  get '/about' do
    slim <<HERE
== slim :_nav_bar
.container
  == markdown :about
HERE
  end

  get '/feed/sources.atom' do
    builder :"feed/sources", locals: {
      sources: Source.all.sort(created_at: -1).limit(20),
    }
  end
end
