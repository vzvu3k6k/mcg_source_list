require 'mongoid'

class Source
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :id_str, type: String
  field :title, type: String
  field :last_used_at, type: Time

  index({ id_str: 1 }, { unique: true })
  index({ last_used_at: -1 })
end
