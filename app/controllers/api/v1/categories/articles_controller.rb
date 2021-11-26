# frozen_string_literal: true
module Api
  module V1
    module Categories
      class ArticlesController < BaseController
        def index
          category = Category.find(params[:category_id])
          filtered_articles = ArticleFilter.new(category.articles).call(filter_params)
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
