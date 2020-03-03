# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Persona::User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:posts).class_name('Post') }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:login) }
  end
end
