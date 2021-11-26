# frozen_string_literal: true
module Api
  module V1
    module Users
      class ArticlesController < BaseController
        def index
          user = User.find(params[:user_id])
          filtered_articles = ArticleFilter.new(user.articles).call(filter_params)
          articles = filtered_articles.order(created_at: :desc).page(params[:page]).per(params[:per])

          render json: articles, each_serializer: ArticlesSerializer
        end

        private

        def filter_params
          params.permit(:search, :date)
        end
      end
    end
  end
end
