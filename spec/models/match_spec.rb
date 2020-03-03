# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Match, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:ip) }
    it { is_expected.to validate_presence_of(:logins) }
  end
end
