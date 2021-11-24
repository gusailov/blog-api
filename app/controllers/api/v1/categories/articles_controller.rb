# frozen_string_literal: true
module Api
  module V1
    module Categories
      class ArticlesController < BaseController
        def index
          # TODO: Add a query-object that will filter Article by: date (assume the date is in ISO8601), by title (must be able to find
          # article even by a part of it's title)
          category = Category.find(params[:category_id])

          render json: category.articles, each_serializer: ArticlesSerializer
        end
      end
    end
  end
end
