class DecodeService
  attr_reader :short_link

  def initialize(short_link)
    @short_link = short_link
  end

  def call
    original_link = REDIS_CACHE.read(short_link)
    if original_link.blank?
      statistic = Statistic.where(short_link: short_link).first
      REDIS_CACHE.write(short_link, statistic.original_link) if statistic.present?
    end
    original_link || REDIS_CACHE.read(short_link)
  end
end


