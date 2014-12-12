require 'pg'
require 'pry'
require 'sinatra'


def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')
    yield(connection)
  ensure
    connection.close
  end
end

get '/' do
  redirect '/recipes'
  erb :recipes
end

get '/recipes' do

  db_connection do |conn|
    @recipes = conn.exec("SELECT id, name FROM recipes ORDER BY name").to_a
  end

  erb :recipes

end

get '/recipes/:id' do
  @id_number = params[:id]

  db_connection do |conn|
    @recipe_info = conn.exec("SELECT id, name, description, instructions FROM recipes").to_a
    @ingredients = conn.exec("SELECT recipes.id, ingredients.name FROM recipes JOIN ingredients ON ingredients.recipe_id = recipes.id").to_a
  end

  @recipe_arr = Array.new
  @ingredients_arr = Array.new

  @recipe_info.each do |recipe|
    if recipe["id"] == @id_number
      @recipe_arr << recipe
    end
  end

  @ingredients.each do |ingredient|
    if ingredient["id"] == @id_number
      @ingredients_arr << ingredient
    end
  end

  erb :id

end
