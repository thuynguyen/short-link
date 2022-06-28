class DecodeService
  attr_reader :short_link

  def initialize(short_link)
    @short_link = short_link
  end

  def call
    sequence = Statistic.all.count + 1
    original_link = REDIS_CACHE.read(short_link) 
    statistic = Statistic.where(original_link: original_link, short_link: short_link).first
    statistic&.update(sequence: sequence)
    original_link
  end
end


