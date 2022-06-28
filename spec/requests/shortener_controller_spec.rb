require 'rails_helper'

RSpec.describe "ShortenerController", type: :request do
  param_url = 'https://docs.google.com/document/d/1jUGP5Pd9eZX-JTGTRrc8g30WLVzzoJ9Ie8OQlWLMjk5/edit#'
  modify_param_url = param_url + (Statistic.all.count + 1).to_s
  encode_url = [ENV['DOMAIN'], Digest::SHA2.new(512).hexdigest(modify_param_url)[0..6]].join("/")
  describe 'GET /encode' do
    it 'it return to short link successfully' do
      get '/shortener/encode', params: {  url: param_url}
      expect(@response).to have_http_status(200)
      expect(JSON.parse(@response.body)["data"]["short_link"]).to eq(encode_url)
    end

    context 'it return to short link unsuccessfully' do
      it 'with empty original link' do
        expect { get '/shortener/encode' }.to raise_error(ShortenerController::MissingUrlParamsError) 
      end

      it 'with invalid original link' do
        expect { get '/shortener/encode', params: {  url: 'abc' } }.to raise_error(ShortenerController::InvalidUrlParamsError) 
      end
    end
  end

  describe 'GET /decode' do
    it "it return to original link successfully" do
      get '/shortener/decode', params: {  url: encode_url}
      expect(@response).to have_http_status(200)
      expect(JSON.parse(@response.body)["data"]["original_link"]).to eq(param_url)
    end

    context 'it return to original link unsuccessfully' do
      it 'with empty short link' do
        expect { get '/shortener/decode' }.to raise_error(ShortenerController::MissingUrlParamsError) 
      end

      it 'with invalid short link' do
        expect { get '/shortener/decode' }.to raise_error(ShortenerController::MissingUrlParamsError) 
      end

      it 'with wrong encoded short link' do
        expect { get '/shortener/decode' }.to raise_error(ShortenerController::MissingUrlParamsError) 
      end
    end
  end
end
