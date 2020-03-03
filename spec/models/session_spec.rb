# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Persona::Session, type: :model do
  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:users).class_name('Persona::User') }
  end

  describe 'class methods' do
    describe '#self.used_by_another_user?' do
      it 'calls Queries::Sessions::UsedByOtherUsersQuery.new(ip, user_id).call.any?' do
        ip = '111.222.333.444'
        user_id = 1
        service = Queries::Sessions::UsedByOtherUsersQuery

        instance = double('used_by_other_users_query')
        instances = double('active_record_relation')
        allow(service).to receive(:new).and_return(instance)
        instance.stub(:call).and_return(instances)
        instances.stub(:any?).and_return(true)

        described_class.used_by_another_user?(ip, user_id)

        expect(service).to have_received(:new).with(ip, user_id)

        expect(instance).to have_received(:call)
        expect(instances).to have_received(:any?)
      end
    end
  end
end
