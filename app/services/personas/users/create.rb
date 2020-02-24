# frozen_string_literal: true

module Services
  module Personas
    module Users
      class Create
        def initialize(login)
          @login = login
        end

        def call
          create_user
        end

        private

        def create_user
          user = Persona::User.where(login: @login).first_or_create!
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error(e.record.errors)
        rescue ActiveRecord::RecordNotUnique => e
          if Persona::User.exists?(login: @login)
            user
          else
            Rails.logger.error(e.record.errors)
          end
        end
      end
    end
  end
end
