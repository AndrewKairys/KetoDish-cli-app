#CLI Controller
class KetoDish::CLI

  def call
    # Priming
    KetoDish::Scraper.new.scrape_dishes
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts <<~HEREDOC
          Looking for something Keto friendly?
          Please type random or R, if you'd
          like to select a dish randomly by
          type. Or select list or L, and a
          list of dishes by type will appear!
          Or type exit to close.
        HEREDOC
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    choice = gets.strip.downcase

      if ["r", "random"].include?(choice)
        random
      elsif ["l", "list"].include?(choice)
        dish_list
      elsif ["exit"].include?(choice)
        goodbye
      else
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        puts "I don't understand that answer."
        call
      end
  end

#List Fork
  def dish_list
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts <<~HEREDOC
          Enter which type of Keto friendly
          dish you'd like: Meal, Snack, Drink,
          or Treat and you'll get a list of
          randomly selected dishes based on
          the type you selected! Or type exit
          to end the program.
         HEREDOC
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    input = gets.strip.downcase

    dishes = dish_by_type(input).sample(10)

    list_dishes(dishes)

    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts "Please enter which number you'd like more information on."
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    input = gets.strip

    number = dish_list_helper(input)

    return_table(dishes[number-1])

    puts "Would you like to go to the recipe for this dish: y or n?"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    answer = gets.strip.downcase

      if ["y"].include?(answer)
        go_to_recipe(dishes[number-1])
      elsif ["n"].include?(answer)
        call
      elsif ["exit"].include?(answer)
        goodbye
      else
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        puts "I don't understand that answer."
        call
      end
  end

#Random Fork
  def random
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts <<~HEREDOC
          Enter what type of Keto friendly
          dish you'd like: Meal, Snack, Drink,
          or Treat and you'll get a randomly
          selected dish! Or type exit to
          end the program.
         HEREDOC
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    input = gets.strip.downcase

    dish = dish_by_type(input).sample

    return_table(dish)

    puts "Would you like to go to the recipe for this dish: y or n?"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    answer = gets.strip.downcase

      if ["y"].include?(answer)
        go_to_recipe(dish)
      elsif ["n"].include?(answer)
        call
      elsif ["exit"].include?(answer)
        goodbye
      else
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        puts "I don't understand that answer."
        call
      end
  end

  def return_table(input)
    dish = input
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "#{dish.name}"
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "Calories per serving:    #{dish.calories} kcal"
      puts "Fat:                     #{dish.fat} g"
      puts "Protein:                 #{dish.protein} g"
      puts "Net-Carbs:               #{dish.net_carbs} g"
      puts "Recipe:                  #{dish.url}"
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  end

  def dish_by_type(input)
    case input
     when "meal"
        KetoDish::Dish.all.select { |e| e.type == "Meal"}
     when "snack"
        KetoDish::Dish.all.select { |e| e.type == "Snack"}
     when "drink"
        KetoDish::Dish.all.select { |e| e.type == "Drink"}
     when "treat"
        KetoDish::Dish.all.select { |e| e.type == "Treat"}
      else
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        puts "I don't understand that answer."
        call
     end
   end

   def dish_list_helper(input)
     if input.to_i.between?(1, 10)
       input.to_i
     else
       puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
       puts "I don't understand that answer."
       call
     end
   end

   def go_to_recipe(dish)
     system("xdg-open '#{dish.url}'")
     call
   end

   def list_dishes(dish)
     puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
     dish.each_with_index do |dish, i|
       puts "#{i+1}." "#{dish.name}"
     end
   end

  def goodbye
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts "Stop by soon for more dishes!"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    exit
  end

end
