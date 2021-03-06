require 'spec_helper'

describe MasterService do
  let(:service) { described_class.new }

  describe 'connection' do
    it 'has a connection' do
      expect(service.send(:conn).url_prefix.to_s).to eq('https://mtginventory-api.herokuapp.com/api/v1')
    end
  end
end
