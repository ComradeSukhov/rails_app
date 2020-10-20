require 'rails_helper'

RSpec.describe CreateVmService do
  subject { CreateVmService.call }
  
  before do
    stub_request(:any, 'https://cloud.com/vms').
      to_return(body: { vm_id: 'vm1' }.to_json)
  end

  it 'return error if vm params invalid' do
    allow(CheckVmService).to receive(:call).and_return(false)
    expect(subject).to eq({ error: 'invalid vm params' })
  end
 
  it 'send notification' do
    allow(CheckVmService).to receive(:call).and_return(true)
    expect(NotifierService).to receive(:call)
    subject
  end

  it 'create vm' do
    allow(CheckVmService).to receive(:call).and_return(true)
    allow(NotifierService).to receive(:call)
    expect(subject).to eq('vm1')
  end

end  
