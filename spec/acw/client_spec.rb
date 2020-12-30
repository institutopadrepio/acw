# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Acw::Client do
  # If any real request is needed, just disable vcr and webmock:
  # WebMock.allow_net_connect!
  # VCR.turn_off!
  # And use your url/token
  let(:config) do
    {
      url: 'https://url.api-us1.com/',
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

      it 'has a connection with the correct URL' do
        expect(client.config[:url]).to eq config[:url]
      end
    end
  end

  describe '#create_contact', :vcr do
    context 'success' do
      let(:result) do
        client.create_contact(
          {
            email: 'fulanodetal@sicrano.com',
            firstName: 'Fulano',
            lastName: 'Sicrano',
            phone: '1231123123'
          }
        )
      end

      it 'is a successfull request' do
        expect(result.success?).to eq true
        expect(result.value['contact']['email']).to eq('fulanodetal@sicrano.com')
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

      it 'is a successfull request' do
        expect(result.success?).to eq true
        expect(result.value['contact']['email']).to eq('fulanodetal3@sicrano.com')
        expect(result.value['contact']['firstName']).to eq('Fulano2')
        expect(result.value['contact']['lastName']).to eq('Sicrano2')
      end
    end
  end

  describe '#retrieve_contact', :vcr do
    context 'success' do
      let(:result) do
        client.retrieve_contact('349151')
      end

      it 'is a successfull request' do
        expect(result.success?).to eq true
        expect(result.value['contact']['id']).to eq '349151'
        expect(result.value['contact']['firstName']).to eq 'Fulano'
        expect(result.value['contact']['email']).to eq 'fulano@email.com'
      end
    end

    context 'failure' do
      let(:result) do
        client.retrieve_contact('99999999999')
      end

      it 'has a request error' do
        expect(result.success?).to eq false
        expect(result.error).to eq('{"message":"No Result found for Subscriber with id 99999999999"}')
      end
    end
  end

  describe '#retrieve_contact_by_email', :vcr do
    context 'success' do
      let(:result) do
        client.retrieve_contact_by_email('someone@email.com')
      end

      it 'is a successfull request' do
        expect(result.success?).to eq true
        expect(result.value['contacts'].first['id']).to eq '349151'
        expect(result.value['contacts'].first['email']).to eq 'someone@email.com'
        expect(result.value['contacts'].first['firstName']).to eq 'Fulano'
        expect(result.value['contacts'].first['lastName']).to eq 'Sicrano'
      end
    end
  end

  describe '#retrieve_lists', :vcr do
    context 'success' do
      let(:result) do
        client.retrieve_lists
      end

      it 'is a successfull request' do
        expect(result.success?).to eq true
        expect(result.value['lists'].size).to eq 2
        expect(result.value['lists'].first['name']).to eq 'EveryOne'
        expect(result.value['lists'].last['name']).to eq 'Just Some'
      end
    end
  end

  describe '#create_tag', :vcr do
    context 'success' do
      let(:result) do
        client.create_tag({ tag: 'teste-api-2021', tagType: 'contact' })
      end

      it 'is a successfull request' do
        expect(result.success?).to eq true
        expect(result.value['tag']['tag']).to eq 'teste-api-2021'
        expect(result.value['tag']['tagType']).to eq 'contact'
      end
    end
  end

  describe '#add_contact_tag', :vcr do
    context 'success' do
      let(:result) do
        client.add_contact_tag({ contact: '349151', tag: '38' })
      end

      it 'is a successfull request' do
        expect(result.success?).to eq true
        expect(result.value['contacts'].first['email']).to eq 'someone@email.com'
        expect(result.value['contactTag']['contact']).to eq '349151'
        expect(result.value['contactTag']['tag']).to eq '38'
      end
    end
  end

  describe '#remove_contact_tag', :vcr do
    context 'success' do
      let(:result) do
        client.remove_contact_tag('774364')
      end

      it 'is a successfull request' do
        expect(result.success?).to eq true
        expect(result.value).to eq({})
      end
    end
  end

  describe '#create_field_value', :vcr do
    context 'success' do
      let(:result) do
        client.create_field_value(
          {
            contact: 572_218,
            field: 2,
            value: 'field_value'
          }
        )
      end

      it 'is a successfull request' do
        expect(result.success?).to eq true
        expect(result.value).to_not be nil
        expect(result.value['contacts'].first['email']).to eq 'fulanodetal222@sicrano.com'
        expect(result.value['fieldValue']['value']).to eq 'field_value'
      end
    end
  end

  describe '#update_field_value', :vcr do
    context 'success' do
      let(:result) do
        client.update_field_value(
          803_383,
          {
            contact: 572_218,
            field: 2,
            value: 'new_field_value_put'
          }
        )
      end

      it 'is a successfull request' do
        expect(result.success?).to eq true
        expect(result.value).to_not be nil
        expect(result.value['contacts'].first['email']).to eq 'fulanodetal222@sicrano.com'
        expect(result.value['fieldValue']['value']).to eq 'new_field_value_put'
      end
    end
  end
end
