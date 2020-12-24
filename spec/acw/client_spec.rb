require 'spec_helper'

RSpec.describe Acw::Client do
  let(:config) do
    {
      url: 'https://url.api-us1.com/api/3/',
      token: 'token'
    }
  end

  let(:client) do
    described_class.new(config)
  end

  describe '#initialize' do
    context 'success' do
      it 'is a Acw Client instance' do
        expect(client.is_a?(Acw::Client)).to be_truthy
      end

      it 'has a connection with headers' do
        expect(client.connection.headers).to_not be_nil
      end
    end
  end

  describe '#create_contact', :vcr do
    context 'success' do
      let(:result) do
        client.create_contact(
          {
            email: 'fulanodetal2@sicrano.com',
            firstName: 'Fulano',
            lastName: 'Sicrano',
            phone: '1231123123'
          }
        )
      end

      it 'hash a true success? result' do
        expect(result.success?).to be_truthy
      end

      it 'has the correct email' do
        expect(result.value['contact']['email']).to eq('fulanodetal2@sicrano.com')
      end
    end
  end

  describe '#sync_contact', :vcr do
    context 'success' do

      let(:result) do
        client.sync_contact(
          {
            email: 'fulanodetal3@sicrano.com',
            firstName: 'Fulano2',
            lastName: 'Sicrano2',
            phone: '1231123123'
          }
        )
      end

      it 'hash a true success? result' do
        expect(result.success?).to be_truthy
      end

      it 'has the correct email' do
        expect(result.value['contact']['email']).to eq('fulanodetal3@sicrano.com')
      end
    end
  end

  describe '#retrieve_contact', :vcr do
    context 'success' do
      let(:result) do
        client.retrieve_contact('349151')
      end

      it 'has a true success? result' do
        expect(result.success?).to be_truthy
      end

      it 'is a hash' do
        expect(result.value.is_a?(Hash)).to be_truthy
      end
    end

    context 'failure' do
      let(:result) do
        client.retrieve_contact('99999999999')
      end

      it 'has a false success? result' do
        expect(result.success?).to be_falsey
      end

      it 'has an error' do
        expect(result.error).to eq('{"message":"No Result found for Subscriber with id 99999999999"}')
      end
    end
  end

  describe '#retrieve_contact_by_email', :vcr do
    context 'success' do

      let(:result) do
        client.retrieve_contact_by_email('someone@email.com')
      end

      it 'has a true success? result' do
        expect(result.success?).to be_truthy
      end

      it 'is a hash' do
        expect(result.value.is_a?(Hash)).to be_truthy
      end

      it 'has a correct contact' do
        expect(result.value['contacts'].first['id']).to eq('349151')
      end
    end
  end

  describe '#retrieve_lists', :vcr do
    context 'success' do
      let(:result) do
        client.retrieve_lists
      end

      it 'has a true success? result' do
        expect(result.success?).to be_truthy
      end

      it 'is a hash' do
        expect(result.value.is_a?(Hash)).to be_truthy
      end
    end
  end

  describe '#create_tag', :vcr do
    context 'success' do
      let(:result) do
        client.create_tag({ tag: 'teste-api-2021', tagType: 'contact'  })
      end

      it 'has a true success? result' do
        expect(result.success?).to be_truthy
      end
    end
  end

  describe '#add_contact_tag', :vcr do
    context 'success' do
      let(:result) do
        client.add_contact_tag({ contact: '349151', tag: '38' })
      end

      it 'has a true success? result' do
        expect(result.success?).to be_truthy
      end
    end
  end

  describe '#remove_contact_tag', :vcr do
    context 'success' do
      let(:result) do
        client.remove_contact_tag('558923')
      end

      it 'has a true success? result' do
        expect(result.success?).to be_truthy
      end
    end
  end
end
