require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @recipes = []
    @csv_file = csv_file_path
    load_csv
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    recipe = Recipe.new(recipe)
    @recipes << recipe
    add_csv(recipe)
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    save_csv
  end

  def cooked_recipe(index)
    @recipes[index].done!
    save_csv
  end

  private

  def load_csv
    CSV.foreach(@csv_file) do |row|
      @recipes << Recipe.new(name: row[0], description: row[1], prep_time: row[2], done: row[3])
    end
  end

  def add_csv(recipe)
    CSV.open(@csv_file, 'a') do |csv|
      csv << [recipe.name, recipe.description, recipe.prep_time, recipe.done]
    end
  end

  def save_csv
    CSV.open(@csv_file, 'w') do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.done]
      end
    end
  end
end

