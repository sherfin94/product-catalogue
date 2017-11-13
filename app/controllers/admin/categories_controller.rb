class Admin::CategoriesController < ApplicationController
  def index
    @hierarchically_ordered_categories =
      HierarchicallyOrderedCategoriesQuery.new.all
  end

  def new
    @category = Category.new
  end
end
