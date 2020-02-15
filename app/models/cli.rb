require "tty-prompt"
require 'pry'

class CommandLineInterface
    @prompt = TTY::Prompt.new
    @prompt.say("------------------------------ | WELCOME TO RECIPE-FINDER | ------------------------------", color: :yellow)
    @prompt.say("
Recipe-finder will be able to look up the main ingredients for your favorite recipe.
It can also offer all recipes that match with the available ingredients from your kitchen.
Creating an account with a username will be automatic when you save some recipes.
Update a recipe’s name will update the original database. Enjoy!
", color: :yellow)
    @prompt.say("------------------------------------------------------------------------------------------", color: :yellow)
    puts " "

    def seperate_line
        puts "------------------------------------------------------------------------------------------"
        puts " "
    end

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
            @prompt.say('Goodbye!', color: :yellow)
        end
    end
    
    def choose_recipes
        recipe_str = Recipe.all.map{|recipe| recipe.name}
        seperate_line
        @prompt.say("Here are the available recipes:", color: :yellow)
        @prompt.say(recipe_str.join(", "), color: :yellow)
        puts " "
        pick_recipe = @prompt.select("Scroll down for more options. Please pick a recipe to see ingredients from below:", recipe_str) 
        r_obj = Recipe.find_by name: pick_recipe
        seperate_line
        @prompt.say("Recipe's ingredients:", color: :yellow)
        @prompt.say(r_obj.get_ingredients, color: :yellow)
        puts " "
        run
    end

    def choose_ingredients
        seperate_line
        ingredient_str = Ingredient.all.map{|ingre| ingre.name }
        @prompt.say("Here are the available ingredients you can put in the list:", color: :yellow)
        @prompt.say(ingredient_str.join(", "), color: :yellow)
        puts " "
        pick_ingredient = @prompt.multi_select("Scroll down for more options. Use 'SPACEBAR' to pick ALL ingredients that you have:", ingredient_str) #return [str,str]
        recipes = Ingredient.get_recipes(pick_ingredient)
        recipe_names = recipes.map{|recipe| recipe.name }
        seperate_line
        @prompt.say("Here are all the recipes you can make from those ingredients:", color: :yellow)
        @prompt.say(recipe_names, color: :yellow)
        puts " "
        if(recipe_names.length > 0)
            saving_ingredients(recipes)
        else 
            seperate_line
            @prompt.say('No recipes found for given ingredients', color: :yellow)
            puts " "
            run
        end
    end

    def saving_ingredients(recipe)
        want_to_save = @prompt.yes?(' Do you want to save this recipe list?')
        seperate_line
        recipe_names = recipe.map{|r_obj|r_obj.name}
        if want_to_save 
            selected_recipes = @prompt.multi_select("Using spacebar to multi-select ALL the recipe that you want to save ", recipe_names)
            user_name = @prompt.ask('Please enter your name ?')
            new_user = User.find_or_create_by(name: user_name)
            selected_recipes.each do |selected_recipe|
                r_obj = Recipe.find_by(name: selected_recipe)
                if new_user.recipes.none?{|r| r == r_obj}
                    new_user.recipes << r_obj
                end
            end
            seperate_line
            @prompt.say("Recipes saved into your account", color: :yellow)
            puts " "
        end
        run
    end

    def saved_recipes
        seperate_line
        user_name = @prompt.ask('Please enter your name ?')
        seperate_line
        if user = User.find_by(name: user_name)
            @prompt.say('Here are your exiting recipes:', color: :yellow)
            @prompt.say(recipes_names(user.recipes), color: :yellow)
            if recipes_names(user.recipes).length > 0
                prompt_options(user, user.recipes)
                seperate_line
            else
                @prompt.say('Your list is empty.', color: :yellow)
                run
            end
        else
            @prompt.say('Cannot find a username. Please choose what else you want to do.', color: :yellow)
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
            recipe_names_to_delete = @prompt.multi_select('Using spacebar to multi-select all recipes you want to delete', recipes_names(recipes))
            #change it to instances
            recipes_to_delete = Recipe.find_by_list(recipe_names_to_delete)
            # loop thru list of instances and delete
            recipes_to_delete.each do |r_obj|
                user.recipes.delete(r_obj)
            end
            if recipe_names_to_delete.length != 0
                seperate_line
                @prompt.say('Recipes deleted!', color: :yellow)
                puts " "
                run
            else
                seperate_line
                @prompt.say('Nothing deleted!', color: :yellow)
                puts " "
                run
            end
        elsif selected_option == 3
            @prompt.say('Goodbye!', color: :yellow)
        end
    end

    def update_recipes(recipe)
        seperate_line
        update_choice = @prompt.select("What would you like to do?") do |option|
            option.choice "Change recipe name", 1
            option.choice "Exit", 2
        end
        if update_choice == 1
            new_recipe_name = @prompt.ask('Enter a new name')
            recipe.update(name: new_recipe_name)
            seperate_line
            @prompt.say("Name has changed successfully.", color: :yellow)
            run
        else
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

