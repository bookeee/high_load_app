# frozen_string_literal: true

module Services
  module Posts
    class Create
      def initialize(args)
        @title = args[:title]
        @content = args[:content]
        @login = args[:login]
        @ip = args[:ip]
      end

      def call
        ActiveRecord::Base.transaction do
          create_user if @login
          create_session if @ip
          create_post
        end
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error(e.record.errors)
      end

      private

      def create_user
        @user = Services::Personas::Users::Create.new(@login).call
      end

      def create_session
        if @user.present?
          @user.sessions.create!(ip: @ip)
        else
          Persona::Session.create!(ip: @ip)
        end
      end

      def create_post
        if @user
          @user.posts.create!(title: @title, content: @content)
        else
          Post.create!(title: @title, content: @content)
        end
      end
    end
  end
end