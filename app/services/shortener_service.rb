require 'digest'
class ShortenerService
	attr_reader :original_link

	def initialize(original_link)
		@original_link = original_link
	end

	def call
    [ENV['DOMAIN'], Digest::SHA2.new(512).hexdigest(original_link)[0..6]].join("/")
	end
end

