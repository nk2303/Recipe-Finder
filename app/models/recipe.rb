class Recipe < ActiveRecord::Base
    has_many :recipe_ingredients
    has_many :ingredients, through: :recipe_ingredients
    has_many :user_recipes
    has_many :users, through: :user_recipes

    def get_ingredients
        ingredients.map{|r_i_obj| r_i_obj.name}
    end

    def self.find_by_list(array)
        #go to this array of recipe names, return the recipe instace
        array.map{|recipe_name| Recipe.find_by(name:recipe_name)}
    end
end