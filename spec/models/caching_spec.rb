# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Settings::Caching, type: :model do
  describe 'validations' do
    describe '#validates :only_one_record' do
      context 'when we dont have any instances before creation' do
        it 'is valid' do
          caching = create(:caching)
          expect(caching).to be_valid
          expect(caching.errors).to be_empty
        end
      end

      context 'when we have 1 instance before creation' do
        before do
          create(:caching)
        end

        it 'is not valid' do
          second_caching = create(:caching)
          expect(second_caching).not_to be_valid
        end

        it 'contains correct error' do
          second_caching = create(:caching)
          second_caching.valid?
          expect(second_caching.errors).to have_key(:base)
          expected_message = ['You can have only 1 instance of this model']
          expect(second_caching.errors[:base]).to eql(expected_message)
        end
      end
    end
  end
end
