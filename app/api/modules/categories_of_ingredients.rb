module Modules
  class CategoriesOfIngredients < Grape::API
    prefix :api
    format :json

    helpers do
      include SessionHelper
      include UserHelpers
    end

    resource :categories_of_ingredients do

      desc 'All categories'
      get do
        categories_of_ingredients = IngredientCategory.all
        present categories_of_ingredients, with: Api::Entities::CategoryOfIngredients
      end

      desc 'Current category'
      params do
        requires :id, type: Integer
      end
      get ':id' do
        category_of_ingredients = IngredientCategory.find(params[:id])
        present category_of_ingredients, with: Api::Entities::CategoryOfIngredients
      end

      desc 'Create new category'
      params do
        requires :title, type: String
      end
      post do
        if user_admin? @current_user
          category_of_ingredients = IngredientCategory.new(
            declared(params, include_missing: false).to_h)
          if category_of_ingredients.save
            { status: :success }
          else
            error!(status: :error, message: category_of_ingredients.errors.full_messages.first) if category_of_ingredients.errors.any?
          end
          present category_of_ingredients, with: Api::Entities::CategoryOfIngredients
        else
          { error: 'not authorized' }
        end
      end

      desc 'Update category'
      params do
        requires :id, type: Integer
        requires :title, type: String
      end
      put ':id' do
        if user_admin? @current_user
          category_of_ingredients = IngredientCategory.find(params[:id])
          if category_of_ingredients.update(declared(params, include_missing: false).to_h)
            present category_of_ingredients, with: Api::Entities::CategoryOfIngredients
            { status: :success }
          else
            error!(status: :error, message: category_of_ingredients.errors.full_messages.first) if category_of_ingredients.errors.any?
          end
        else
          { error: 'not authorized' }
        end
      end

      desc 'Delete category'
      params do
        requires :id, type: Integer
      end
      delete ':id' do
        if user_admin? @current_user
          { status: :success } if IngredientCategory.find(params[:id]).destroy
        else
          { error: 'not authorized' }
        end
      end
    end
  end
end