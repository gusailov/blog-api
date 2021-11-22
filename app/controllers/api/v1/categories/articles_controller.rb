# frozen_string_literal: true
module Api
  module V1
    module Categories
      class ArticlesController < BaseController
        def index
          category = Category.find(params[:category_id])

          render json: category.articles, each_serializer: ArticlesSerializer
        end
      end
    end
  end
end