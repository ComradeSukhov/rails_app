require 'rails_helper'

RSpec.describe GrapeApi::UsersApi do
  describe 'GET /api/users' do

    before(:all) do
      create_list(:user, 5)
      get '/api/users'
    end
  
    after(:all) do
      User.destroy_all
    end
  
    it 'has a 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'has a array body' do
      expect(JSON.parse(response.body)).to be_instance_of(Array)
    end

    it 'returns user attributes' do
      users = JSON.parse(response.body)
      expect(users[0].keys).to contain_exactly('id', 'full_name')
    end
  
    it 'filter by ballance' do
      get '/api/users', params: { balans: 11 }
      expect(JSON.parse(response.body).count).to eq(4)
    end

    it 'returns JSON format response' do
      expect(response.header['content-type']).to eq('application/json')
    end

    it 'For a user who is not present 404 is returned' do
      get  '/api/users/999'
      expect(response.code).to eq('404')
    end

    it 'If there is a user, a hash with the correct parameters is returned' do
      get  '/api/users/1'
      user = JSON.parse(response.body)
      expect(user.keys).to contain_exactly('id', 'full_name')
    end

    it 'If you pass detail, it will also return ballance' do
      get  '/api/users/1?detail=true'
      user = JSON.parse(response.body)
      expect(user.keys).to contain_exactly('id', 'full_name', 'balans')
    end
  end

  describe 'POST /api/users' do

    let(:user_params) { { name: 'Пётр', surname: 'Петров', balans: 1 } }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

    before(:each) do
      User.destroy_all
    end
  
    after(:each) do
      User.destroy_all
    end
  
    it 'has a required params' do
      post '/api/users',
        params: { foo: 'bar' }.to_json,
        headers: { 'CONTENT_TYPE' => 'application/json' }
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to include('error')
    end

    it 'creates user with valid params' do
      post '/api/users',
        params: user_params.to_json,
        headers: headers
      expect(User.first).to have_attributes(user_params)
    end

    it 'returns user attributes' do
      post '/api/users',
        params: { name: 'Пётр', surname: 'Петров', balans: 1 }.to_json,
        headers: { 'CONTENT_TYPE' => 'application/json' }
      expect(JSON.parse(response.body).keys).to contain_exactly('id', 'full_name', 'balans')
    end
  
  end
end
