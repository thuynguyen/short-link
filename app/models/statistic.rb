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
  index({ short_link: 1, original_link: 1 })
  index({ short_link: 1 }, { unique: true })

  validates_uniqueness_of :short_link
  validates_presence_of :original_link, :short_link

  REGEX_URL = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix

  def self.save_encode_record(attrs)
    self.create(attrs)
  end
end