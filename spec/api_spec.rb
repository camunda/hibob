# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bob::API do
  let(:url) { 'https://api.hibob.com/v1/test' }
  let(:response) { double(body: '[{"test":"test"}]', code: 200) }

  let(:json_headers) do
    { Accept: 'application/json', Authorization: 'Basic Og==', 'Content-Type': 'application/json' }
  end
  let(:bodyless_headers) { { Accept: 'application/json', Authorization: 'Basic Og==' } }

  before do
    allow(Bob).to receive(:configuration).and_return({ access_token: 'access-token', api_version: 'v1' })
  end

  describe '.get' do
    it 'performs request without a Content-Type header' do
      allow(RestClient).to receive(:get).and_return(response)

      result = described_class.get('test')

      expect(result).to eq(['test' => 'test'])
      expect(RestClient).to have_received(:get).with(url, bodyless_headers).once
    end
  end

  describe '.delete' do
    it 'performs request without a Content-Type header' do
      allow(RestClient).to receive(:delete).and_return(response)

      described_class.delete('test')

      expect(RestClient).to have_received(:delete).with(url, bodyless_headers).once
    end
  end

  describe '.put' do
    it 'sends the JSON Content-Type header with the body' do
      allow(RestClient).to receive(:put).and_return(response)

      described_class.put('test', { a: 1 })

      expect(RestClient).to have_received(:put).with(url, '{"a":1}', json_headers).once
    end
  end

  describe '.post' do
    it 'sends the JSON Content-Type header with the body' do
      allow(RestClient).to receive(:post).and_return(response)

      described_class.post('test', { a: 1 })

      expect(RestClient).to have_received(:post).with(url, '{"a":1}', json_headers).once
    end
  end
end
