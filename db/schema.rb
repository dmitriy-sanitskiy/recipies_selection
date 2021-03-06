# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170508205604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'
  enable_extension 'unaccent'

  create_table 'favorite_recipes', id: :serial, force: :cascade do |t|
    t.integer 'user_id'
    t.integer 'recipe_id'
    t.text 'note'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['recipe_id'], name: 'index_favorite_recipes_on_recipe_id'
    t.index ['user_id'], name: 'index_favorite_recipes_on_user_id'
  end

  create_table 'friendly_id_slugs', force: :cascade do |t|
    t.string 'slug', null: false
    t.integer 'sluggable_id', null: false
    t.string 'sluggable_type', limit: 50
    t.string 'scope'
    t.datetime 'created_at'
    t.index %w(slug sluggable_type scope), name: 'index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope', unique: true
    t.index %w(slug sluggable_type), name: 'index_friendly_id_slugs_on_slug_and_sluggable_type'
    t.index ['sluggable_id'], name: 'index_friendly_id_slugs_on_sluggable_id'
    t.index ['sluggable_type'], name: 'index_friendly_id_slugs_on_sluggable_type'
  end

  create_table 'ingredient_categories', id: :serial, force: :cascade do |t|
    t.string 'title'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'ingredients', id: :serial, force: :cascade do |t|
    t.string 'name'
    t.text 'content'
    t.string 'href'
    t.integer 'ingredient_category_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'calories'
    t.integer 'protein'
    t.integer 'fat'
    t.integer 'carbohydrate'
    t.index ['ingredient_category_id'], name: 'index_ingredients_on_ingredient_category_id'
  end

  create_table 'ingredients_recipes', id: false, force: :cascade do |t|
    t.bigint 'recipe_id', null: false
    t.bigint 'ingredient_id', null: false
    t.index %w(ingredient_id recipe_id), name: 'index_ingredients_recipes_on_ingredient_id_and_recipe_id'
    t.index %w(recipe_id ingredient_id), name: 'index_ingredients_recipes_on_recipe_id_and_ingredient_id'
  end

  create_table 'recipe_categories', id: :serial, force: :cascade do |t|
    t.string 'title'
  end

  create_table 'recipe_ingredients', id: :serial, force: :cascade do |t|
    t.integer 'recipe_id'
    t.integer 'ingredient_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'number_of_ingredient'
    t.index ['ingredient_id'], name: 'index_recipe_ingredients_on_ingredient_id'
    t.index ['recipe_id'], name: 'index_recipe_ingredients_on_recipe_id'
  end

  create_table 'recipes', id: :serial, force: :cascade do |t|
    t.string 'name'
    t.text 'content'
    t.integer 'recipe_category_id'
    t.string 'cooking_time'
    t.integer 'calories'
    t.integer 'protein'
    t.integer 'fat'
    t.integer 'carbohydrate'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index "to_tsvector('russian'::regconfig, (name)::text)", name: 'recipes_name', using: :gin
    t.index "to_tsvector('russian'::regconfig, content)", name: 'recipes_content', using: :gin
    t.index ['recipe_category_id'], name: 'index_recipes_on_recipe_category_id'
  end

  create_table 'users', id: :serial, force: :cascade do |t|
    t.string 'email', null: false
    t.string 'password_digest', null: false
    t.string 'name', null: false
    t.integer 'status', default: 0, null: false
    t.text 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'rid'
    t.string 'slug'
    t.string 'encrypted_token'
    t.string 'encrypted_token_iv'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['rid'], name: 'index_users_on_rid', unique: true
    t.index ['slug'], name: 'index_users_on_slug', unique: true
    t.index ['status'], name: 'index_users_on_status'
  end

end
