class Ingredient < ActiveRecord::Base
    has_many :recipe_ingredients
    has_many :recipes, through: :recipe_ingredients

    def self.get_recipes(array)
        recipe_list = []
        Recipe.all.each do |r_obj|
            recipe_ingredients = r_obj.get_ingredients
            valid_recipe = recipe_ingredients.all?{|i_name| array.include?(i_name)}
            if valid_recipe
                recipe_list << r_obj
            end
        end
        recipe_list
    end

end