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
          create_match if @login && @ip
          create_post
          create_statistics
          @post
        end
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error(e.record.errors)
        e
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

      # good idea to store this data in dynamo db or
      # other document-oriented storage
      # it's analytical information
      def create_match
        @match = Services::Matches::Create.new(@ip, @user).call
      end

      def create_post
        @post = if @user
                  @user.posts.create!(title: @title, content: @content)
                else
                  Post.create!(title: @title, content: @content)
                end
      end

      def create_statistics
        @post.create_statistics!
      end
    end
  end
end
