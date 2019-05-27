require 'rails_helper'

RSpec.describe Api::V1::ArticlesController, type: :request do
  let(:headers) { { HTTP_ACCEPT: 'application/json' } }

  describe 'GET /api/v1/articles' do
    before do
      5.times { FactoryBot.create(:article) }
    end

    it 'returns a collection of articles' do
      get '/api/v1/articles', headers: headers
      expect(json_response['data'].count).to eq 5
    end

    it 'returns 200 response' do
      get '/api/v1/articles', headers: headers
      expect(response.status).to eq 200
    end
  end

  describe 'GET /api/v1/articles/id' do
    let(:article) { FactoryBot.create(:article)}
    before do
      get "/api/v1/articles/"+"#{article.id}", headers: headers
    end

    it 'returns a specific article' do
      expect(json_response['id']).to eq article.id
    end

    it 'returns 200 response' do
      expect(response.status).to eq 200
    end
  end

  describe 'POST /api/v1/articles successfully' do
    before do
      post '/api/v1/articles', params: {
        article: { 
          title: 'Gothenburg is great', 
          ingress: 'According to many', 
          body: 'Not many people really think that Stockholm is a better place to live in', 
          image: 'https://assets.craftacademy.se/images/people/students_group.png',
          written_by: 'Steffe Karlberg'
        }
      }, headers: headers
    end

    it 'creates an article entry' do
      expect(json_response['message']).to eq 'Successfully created'
    end

    it 'send back into the response the newly created article information' do
      article = Article.last
      expect(json_response['article_id']).to eq article.id
    end
  end

  describe 'POST /api/v1/articles unsuccessfully' do

    it 'can not be created without all fields filled in' do
      post '/api/v1/articles', params: {
        article: {
          title: "Stockolm is not too bad",
          written_by: 'Steffe Karlberg'
        }
      }, headers: headers
      
      expect(json_response['error']).to eq ["Ingress can't be blank", "Body can't be blank", "Image can't be blank"]
    end
  end
end
