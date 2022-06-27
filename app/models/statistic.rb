class Statistic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :original_link, type: String
  field :short_link, type: String
  field :encode, type: String
  field :os, type: String
  field :visit, type: Integer
  field :browser, type: String
  field :action, type: String
  field :sequence, type: Integer

  REGEX_URL = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:
[0-9]{1,5})?(\/.*)?$/ix

  index({ short_link: 1, original_link: 1 })

  def self.save_encode_record(attrs)
    self.create(attrs)
  end
end