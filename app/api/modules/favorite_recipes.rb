module Modules
  class FavoriteRecipes < Grape::API
    prefix 'api'
    format :json

    helpers do
      include SessionHelper
      include UserHelpers
    end

    before do
      @current_user = get_user_from_token(users_token)
    end

    resource :favorite_recipes do

      ###POST /api/favorite_recipes
      desc 'Add favorite recipe', {
      is_array: true,
      success: { message: 'success' },
      failure: [{ code: 406, message: 'Invalid users token or recipe id' },
                { code: 400, message: 'This recipe already exists' }]
      }
      params do
        requires :recipe_id, type: String, desc: 'id recipe'
        optional :notes, type: String, desc: 'notes'
      end
      post do
        recipe = Recipe.find_by id: params[:recipe_id]

        if @current_user && recipe
          fr = FavoriteRecipe.find_by user: @current_user, recipe: recipe
          if fr
            status 400
            return { message: 'This recipe already exists' }
          end

          f = FavoriteRecipe.new
          f.user = @current_user
          f.recipe = recipe
          f.note = params[:notes]
          return { message: 'success' } if f.save
        end
        status 406
        { error: 'Invalid users token or recipe id' }
      end

      ###GET /api/favorite_recipes
      desc 'Get favorite recipes', {
      is_array: true,
      success: { message: 'success' },
      failure: [{ code: 406, message: 'Invalid users token' }]
      }
      params do
        #requires :user_token, type: String, desc: 'users token'
      end
      get ':favorite_recipes' do
        if @current_user
          m = FavoriteRecipe.where(user: @current_user)
          present m, with: Entities::FavoriteRecipeEntities
        else
          status 406
          { error: 'Invalid users token' }
        end
      end

      ###DELETE /api/favorite_recipes/id
      desc 'Delete favorite recipe', {
      is_array: true,
      success: { message: 'success' },
      failure: [{ code: 406, message: 'Invalid users token or recipe id' }]
      }
      params do
        requires :favorite_recipe_id, type: String, desc: 'favorite recipe id'
      end
      delete ':favorite_recipe_id' do
        if @current_user
          fr = FavoriteRecipe.find_by user: @current_user, recipe_id: params[:favorite_recipe_id].to_i
          if fr
            FavoriteRecipe.destroy(fr)
            { message: 'success' }
          end
        end
        status 406
        { error: 'Invalid users token or recipe id' }
      end

    end
  end
end