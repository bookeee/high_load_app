# frozen_string_literal: true

module Services
  module Matches
    class Create
      def initialize(ip, user)
        @ip = ip
        @user = user
      end

      def call
        ActiveRecord::Base.transaction do
          if match_exists?
            set_match
            create_match
            @match
          end
        end
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error(e.record.errors)
        e
      end

      private

      def create_match
        if @match.present?
          update
        else
          create_new
        end
      end

      def update
        if @match.logins.include?(@user.login)
          # do nothing
        else
          @match.logins << @user.login
          @match.save!
        end
      end

      def create_new
        @match = Match.create!(ip: @ip, logins: [@user.login])
      end

      def set_match
        @match = Match.where(ip: @ip).first
      end

      def match_exists?
        Persona::Session.used_by_another_user?(@ip, @user.id)
      end
    end
  end
end
