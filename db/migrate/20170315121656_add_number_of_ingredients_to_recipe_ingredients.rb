class AddNumberOfIngredientsToRecipeIngredients < ActiveRecord::Migration[5.0]
  def change
    add_column :recipe_ingredients, :number_of_ingredient, :string
  end
end
