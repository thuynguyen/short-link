class EncodeService
  class DuplicateShorLinkError < StandardError; end
  attr_reader :original_link, :statistic_attrs

  def initialize(original_link, statistic_attrs = {})
    @original_link = original_link
    @statistic_attrs = statistic_attrs
  end

  def call
    try_time = 0
    begin
      sequence ||= Statistic.all.count + 1
      puts "====#{sequence.inspect}========"
      short_link = ShortenerService.new(original_link + sequence.to_s).()
      raise DuplicateShorLinkError, "Collision short link" if REDIS_CACHE.read(short_link).present?
      last_record = Statistic.save_encode_record({ original_link: original_link,
                                                    short_link: short_link, sequence: sequence }
                                                    .merge(statistic_attrs))
      REDIS_CACHE.write(short_link, original_link)
    rescue
      sequence = sequence + 1
      try_time += 1
      retry if try_time < 7
    end
    short_link
  end
end
