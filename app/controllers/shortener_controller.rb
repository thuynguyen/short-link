class ShortenerController < ApplicationController
  class MissingUrlParamsError < StandardError; end
  class InvalidUrlParamsError < StandardError; end

  before_action :validate_param, only: [:encode, :decode]

  def encode
    sequence = Statistic.all.count + 1
    short_link = ShortenerService.new(shortener_params[:url] + sequence.to_s).()
    last_record = Statistic.save_encode_record({original_link: shortener_params[:url],
                                 short_link: short_link, sequence: sequence}.merge(statistic_attrs))
    REDIS_CACHE.write(short_link, shortener_params[:url]) unless REDIS_CACHE.read(short_link).present?
    render json: { data: { short_link: short_link } }
  end

  def decode
    sequence = Statistic.all.count + 1
    original_link = REDIS_CACHE.read(shortener_params[:url]) 
    statistic = Statistic.where(original_link: original_link, short_link: shortener_params[:url]).first
    statistic&.update(sequence: sequence)
    render json: { data: { original_link: original_link } }
  end

  private
  def shortener_params
    params.permit(:url)
  end

  def validate_param
    raise MissingUrlParamsError, "The URL param is rquired" unless params[:url].present?
    raise InvalidUrlParamsError, 'This URL is invalid.' unless Statistic::REGEX_URL.match(params[:url]).present?
  end

  def statistic_attrs
    os = request.headers['sec-ch-ua-platform'].to_s
    browser = request.headers['sec-ch-ua'].to_s
    { visit: 1, os: os, browser: browser, action: params[:action] }
  end
end
