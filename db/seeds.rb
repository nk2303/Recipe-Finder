# create a hash where recipe name is the key and an array of ingredients are the values
# itereate over hash and make an instance of a Recipe with each key
# and an instance of RecipeIngredient with each item in the ingredient array
User.delete_all
Recipe.delete_all
UserRecipe.delete_all
Ingredient.delete_all
RecipeIngredient.delete_all

@reci_ingre = {
    "Fried Chicken" => ["chicken", "flour"],
    "Sushi" => ["salmon", "seaweed", "rice"],
    "Hamburger" => ["bun", "beef", "lettuce"],
    "Carbonara" => ["pasta", "cheese", "bacon"],
    "Cheese and egg Toast" => ["cheese", "bread", "egg"],
    "Garlic Bread" => ["butter", "bread"],
    "Fried Rice" => ["rice", "egg", "carrot"],
    "Baked Garlic Chicken" => ["chicken"],
    "Salad" => ["tomato", "lettuce", "egg"],
    "Curry" => ["chicken", "tomato", "onion"],
    "Ramen" => ["egg", "noodle"],
    "Musubi" => ["spam", "seaweed", "rice"],
    "Garlic Butter Salmon" => ["salmon"],
    "Tomato Pasta" => ["tomato", "pasta"],
    "Tomato Soup" => ["tomato", "cream"],
    "Spam and Egg" => ["rice", "spam", "egg"]
}



def ingredient
    ingre = []
    @reci_ingre.each do |r,i|
        i.each do |i_name|
            if ingre.none?(i_name)
              ingre << i_name
            end
        end
      end
    ingre
end

ingredient.each do |i_name|
    Ingredient.create(name: i_name)
end

@reci_ingre.each do |r_name, i_array|
    r1 = Recipe.create(name: r_name)
    i_array.each do |i_name|
        ingred = Ingredient.find_by(name: i_name)
        RecipeIngredient.create(recipe_id: r1.id, ingredient_id: ingred.id)
    end
end