module Modules
  class CategoriesOfRecipes < Grape::API
    prefix :api
    format :json

    helpers do
      include SessionHelper
      include UserHelpers
    end

    before do
      @current_user = get_user_from_token(users_token)
    end

    resource :categories_of_recipes do

      desc 'All categories'
      get do
        categories_of_recipes = RecipeCategory.all
        present categories_of_recipes, with: Api::Entities::CategoryOfRecipes
      end

      desc 'Current category'
      params do
        requires :id, type: Integer
      end
      get ':id' do
        category_of_recipes = RecipeCategory.find(params[:id])
        present category_of_recipes, with: Api::Entities::CategoryOfRecipes
      end

      desc 'Create new category'
      params do
        requires :title, type: String
      end
      post do
        { error: 'not authorized' } unless user_admin? @current_user
        category_of_recipes = RecipeCategory.new(
            declared(params, include_missing: false).to_h)
        if category_of_recipes.save
          present category_of_recipes, with: Api::Entities::CategoryOfRecipes
          {status: :success}
        else
          error!(status: :error, message: category_of_recipes.errors.full_messages.first) if category_of_recipes.errors.any?
        end
      end

      desc 'Update category'
      params do
        requires :id, type: Integer
        requires :title, type: String
      end
      put ':id' do
        { error: 'not authorized' } unless user_admin? @current_user
        category_of_recipes = RecipeCategory.find(params[:id])
        if category_of_recipes.update(declared(params, include_missing: false).to_h)
          present category_of_recipes, with: Api::Entities::CategoryOfRecipes
          {status: :success}
        else
          error!(status: :error, message: category_of_recipes.errors.full_messages.first) if category_of_recipes.errors.any?
        end
      end

      desc 'Delete category'
      params do
        requires :id, type: Integer
      end
      delete ':id' do
        { error: 'not authorized' } unless user_admin? @current_user
        {status: :success} if RecipeCategory.find(params[:id]).destroy
      end
    end
  end
end