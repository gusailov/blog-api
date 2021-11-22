# frozen_string_literal: true
module Api
  module V1
    module Users
      class ArticlesController < BaseController
        def index
          user = User.find(params[:user_id])

          render json: user.articles, each_serializer: ArticlesSerializer
        end
      end
    end
  end
end