# frozen_string_literal: true
module Api
  module V1
    module Users
      class ArticlesController < BaseController
        def index
          # TODO: Add a query-object that will filter Article by: date (assume the date is in ISO8601), by title (must be able to find
          # article even by a part of it's title)
          user = User.find(params[:user_id])
          articles = user.articles.order(created_at: :desc).page(params[:page]).per(params[:per])

          render json: articles, each_serializer: ArticlesSerializer
        end
      end
    end
  end
end
