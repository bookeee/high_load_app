# frozen_string_literal: true

module Api
  module V1
    class PostsController < ApplicationController
      def create
        @post = Services::Posts::Create.new(post_params).call

        if @post.persisted?
          render json: PostPresenter.new(@post), status: :ok
        else
          render_error_response(@post.errors.messages, 422)
        end
      end

      def top
        @posts = Services::Posts::Top.new(params[:posts_amount]).call
        if @posts.present?
          render json: PostsPresenter.new(@posts)
        else
          render_error_response(@post.errors.messages, 422)
        end
      end

      private

      def post_params
        params.require(:post).permit(:title, :content, :ip, :login)
      end
    end
  end
end
