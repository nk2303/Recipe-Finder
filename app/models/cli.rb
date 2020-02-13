require "tty-prompt"
require 'pry'


class CommandLineInterface
    @prompt = TTY::Prompt.new
    def run
        @prompt = TTY::Prompt.new
        welcome = @prompt.select("What would you like to do?") do |option|
            option.choice "Get my ingredients from a recipe", 1
            option.choice "Get my recipes from ingredients", 2
            option.choice "Check my saved recipes", 3
            option.choice "Exit", 4
        end

        if welcome == 1
            choose_recipes
        elsif welcome == 2
            choose_ingredients
        elsif welcome == 3
            saved_recipes
        elsif welcome == 4
            @prompt.say('Goodbye!', color: :red)
        end
    end
    
    def choose_recipes
        recipe_str = Recipe.all.map{|recipe| recipe.name}
        pick_recipe = @prompt.select("Scroll down for more options. Pick a recipe to see ingredients:", recipe_str) 
        r_obj = Recipe.find_by name: pick_recipe
        @prompt.say(r_obj.get_ingredients, color: :red)
        run
    end

    def choose_ingredients
        ingredient_str = Ingredient.all.map{|ingre| ingre.name }
        pick_ingredient = @prompt.multi_select("Scroll down for more options. Use 'SPACEBAR' to pick ALL ingredients that you have:", ingredient_str) #return [str,str]
        recipes = Ingredient.get_recipes(pick_ingredient)
        recipe_names = recipes.map{|recipe| recipe.name }
        # print recipe_names
        @prompt.say(recipe_names, color: :red)
        #binding.pry
        if(recipe_names.length > 0)
            saving_ingredients(recipes)
        else 
            @prompt.say('No recipes found for given ingredients', color: :red)
            run
        end
    end

    def saving_ingredients(recipe)
        want_to_save = @prompt.yes?(' Do you want to save this recipe list?')
        recipe_names = recipe.map{|r_obj|r_obj.name}
        if want_to_save 
            selected_recipes = @prompt.multi_select("Scroll down for more options. Using 'SPACEBAR', select ALL the recipe that you want to save ", recipe_names)
            user_name = @prompt.ask('Please enter your name ?')
            new_user = User.find_or_create_by(name: user_name)
            selected_recipes.each do |selected_recipe|
                r_obj = Recipe.find_by(name: selected_recipe)
                if new_user.recipes.none?{|r| r == r_obj}
                    new_user.recipes << r_obj
                end
            end
            #puts 'Recipes saved'
            @prompt.say('Recipes saved', color: :red)
        end
        run
    end

    def saved_recipes
        user_name = @prompt.ask('Please enter your name ?')
        if user = User.find_by(name: user_name)
            puts 'Here are your exiting recipes:'
            @prompt.say(recipes_names(user.recipes), color: :red)
            if recipes_names(user.recipes).length > 0
                prompt_options(user, user.recipes)
            else
                # puts "Your list is empty"
                @prompt.say('Your list is empty.', color: :red)
                run
            end
        else
            # puts 'Cannot find a username. Please choose what else you want to do.'
            @prompt.say('Cannot find a username. Please choose what else you want to do.', color: :red)
            run
        end
    end

    def prompt_options(user, recipes)
        options = ["Update Recipe", "Delete Recipe", "Exit"]
        selected_option = @prompt.select("Please pick an option") do |option|
            option.choice "Update Recipe", 1
            option.choice "Delete Recipe", 2
            option.choice "Exit", 3
        end
        if selected_option == 1
            recipe_name_to_update = @prompt.select('Pick recipes you want to update ?', recipes_names(recipes))
            recipe_to_update = Recipe.find_by(name: recipe_name_to_update)
            update_recipes(recipe_to_update)
        elsif selected_option == 2
            #take a list of recipe names
            recipe_names_to_delete = @prompt.multi_select('Pick recipes you want to delete ?', recipes_names(recipes))
            #change it to instances
            recipes_to_delete = Recipe.find_by_list(recipe_names_to_delete)
            # loop thru list of instances and delete
            recipes_to_delete.each do |r_obj|
                user.recipes.delete(r_obj)
            end
            # puts "Recipes deleted!"
            @prompt.say('Recipes deleted!', color: :red)
            run
        elsif selected_option == 3
            # puts "Goodbye!"
            @prompt.say('Goodbye!', color: :red)
        end
    end

    def update_recipes(recipe)
        update_choice = @prompt.select("What would you like to do?") do |option|
            option.choice "Change recipe name", 1
            option.choice "Exit", 2
        end
        if update_choice == 1
            new_recipe_name = @prompt.ask('Enter a new name')
            recipe.update(name: new_recipe_name)
            # puts "Name has changed successfully."
            @prompt.say("Name has changed successfully.", color: :red)
            run
        else
            # puts "Goodbye!"
            @prompt.say("Goodbye!", color: :red)
        end
    end

        
    def user_exists?(user_name)
        User.find_by(name:user_name)
    end

    def recipes_names(recipes)
        recipes.map {|r| r.name}
    end

end

