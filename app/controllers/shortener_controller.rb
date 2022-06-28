class ShortenerController < ApplicationController
  class MissingUrlParamsError < StandardError; end
  class InvalidUrlParamsError < StandardError; end

  before_action :validate_param, only: [:encode, :decode]

  def encode
    short_link = EncodeService.new(shortener_params[:url], statistic_attrs).()
    render json: { data: { short_link: short_link } }
  end

  def decode
    original_link = DecodeService.new(shortener_params[:url]).()
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
