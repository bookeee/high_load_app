# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Statistics, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:post).class_name('Post') }
    it { is_expected.to have_many(:ratings).class_name('Rating') }
  end
end
