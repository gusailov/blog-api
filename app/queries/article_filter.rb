class ArticleFilter
  attr_accessor :initial_scope

  def initialize(initial_scope)
    @initial_scope = initial_scope
  end

  def call(params)
    result = search(initial_scope, params[:search])
    result = filter_by_date(result, params[:date])

    result
  end

  private

  def search(scoped, query = nil)
    query ? scoped.where('title ILIKE ?', "%#{query}%") : scoped
  end

  def filter_by_date(scoped, date = nil)
    date.present? ? scoped.where(created_at: date.to_date.all_day) : scoped
  end
end