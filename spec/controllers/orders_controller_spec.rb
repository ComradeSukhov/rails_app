require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe 'GET orders/check' do

    before do
      stub_request(:get, "http://possible_orders.srv.w55.ru/")
                   .to_return(body: { vm_id: 'vm1' }
                   .to_json)

      allow_any_instance_of(CheckService).to receive(:get_config).and_return({})
    end

    it 'redirects to the login page if the user is not logged in' do
      get :check
      expect(response).to redirect_to :login
    end

    it 'returns an error if the user doesnt have the money entity' do
      get :check, session: { login: 'Ivan' }
      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)).to eq({ 'result' => false, 'error' => 'Mister, you dont have a wallet. How were you going to pay?' })
    end

    it 'returns an error if the user doesnt have enough money for the purchase' do
      cost   = { 'cost' => 1001 }

      allow_any_instance_of(CheckService).to receive(:params_available?).and_return(true)
      allow_any_instance_of(CheckService).to receive(:cost_request).and_return(cost)

      get :check, session: { login: 'Ivan', credits: 1000}

      expect(response).to have_http_status(406)
      expect(JSON.parse(response.body)).to eq({ 'result' => false, 'error' => 'Not enough gold' })
    end

    it 'returns an error if parameters are not available' do
      cost   = { 'cost' => 1000 }
  
      allow_any_instance_of(CheckService).to receive(:params_available?).and_return(false)
      allow_any_instance_of(CheckService).to receive(:cost_request).and_return(cost)
  
      get :check, session: { login: 'Ivan', credits: 1000}
  
      expect(response).to have_http_status(406)
      expect(JSON.parse(response.body)).to eq({ 'result' => false, 'error' => 'Parameters is not available' })
    end

    it 'Returns a positive response if the user has enough money to purchase and the VM configuration is available' do
      cost   = { 'cost' => 500 }
  
      allow_any_instance_of(CheckService).to receive(:params_available?).and_return(true)
      allow_any_instance_of(CheckService).to receive(:cost_request).and_return(cost)
  
      get :check, session: { login: 'Ivan', credits: 1000}
  
      balance = session[:credits]

      response_hash = {
        'result' => true,
        'total' => cost['cost'],
        'balance' => session[:credits],
        'balance_after_transaction' => balance - cost['cost']
      }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(response_hash)
    end
  end
end