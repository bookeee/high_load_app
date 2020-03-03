# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user).class_name('Persona::User') }
    it { is_expected.to have_many(:evaluations).class_name('Evaluation') }
    it { is_expected.to have_one(:statistics).class_name('Statistics') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
  end
end
