# RECIPE FINDER - Command Line CRUD App

This repository contains a simple command-line-interface program that allows the user to find recipes with a list of available ingredients. User can also find the ingredients from a specific recipe. As the user wants to save his/her recipes, the program will create a data for that user, so that they can access to their saved recipes later. The program utilizes Ruby and SQLite3 (through ActiveRecord) to create a database with various associations, provides the methods to access the database, and creates an user experience through CLI.

# INSTALLATION

Fork and clone the repository. You will need to have Ruby installed on your device.

Open the directory in your terminal
enter: bundle install to install the necessary gems
enter: rake db:migrate to create the database
enter: rake db:seed to add data to the databas (optional)

If you want to add more recipes:
Add them under seed file.
Run command rake db:seed in your terminal.

# START THE PROGRAM

Enter into your terminal: ruby bin/run.rb

Choose any options out of four using up/down button.

## Option 1 : Get my ingredients from a recipe

 Pick a recipe to see ingredients.
 Ingredients of that recipe will appear on screen.
 The program will automatically go back to the beginning menu option.

# Option 2 : Get my recipes from ingredients
 Pick ALL ingredients that you have.
 The program will return a list of recipes that the user can cook with.
 And ask you which recipe you want to save into your account. Choose Y or N.
 N will take you back to the beginning menu option.
 Y will ask you to choose the recipe you want to save into your account.
 Enter your username for you account.
 If you haven't had an account, the program will CREATE a new account for you, and save the chosen recipes.

## Option 3 : Check my saved recipes
 Ask for 3 options:
### Option 1 : Update Recipe
 The program will ask you to choose which recipe you want to change from your save list.
 Enter the new name for your recipe.
 The program will appear the orginal menu which you can go to your saved recipes and see if it's updated.
### Option 2 : Delete Recipe
 The program will ask you to choose which recipe you want to delete from your save list.
 Pick your recipe or exit.
### Option 3 : Exit
 Exit out of the program.

## Option 4 : Exit
-- Exit out of the program.



![describe photo here](url)
