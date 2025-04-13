def loading_bar_startup(duration) # For um, why not
  i = 0
  while i <= duration
    system("cls") || system("clear")
    puts "--------------------------------"
    puts "      Welcome to Hangman!"
    puts "--------------------------------"
    puts "Please wait a moment"
    puts "Loading hangman."

    sleep 0.5

    system("cls") || system("clear")
    puts "--------------------------------"
    puts "      Welcome to Hangman!"
    puts "--------------------------------"
    puts "Please wait a moment"
    puts "Loading hangman.."
    
    sleep 0.5

    system("cls") || system("clear")
    puts "--------------------------------"
    puts "      Welcome to Hangman!"
    puts "--------------------------------"
    puts "Please wait a moment"
    puts "Loading hangman..."
    
    sleep 0.5
    i += 1
  end
end

def loading_bar_play(max_duration = 100)
  width = 30
  progress = 0

  while progress < max_duration
    increment = rand(1..2)
    progress += increment
    progress = max_duration if progress > max_duration

    percent = ((progress.to_f / max_duration) * 100).round
    completed = ((progress.to_f / max_duration) * width).round
    bar = "=" * completed + " " * (width - completed)

    system("cls") || system("clear")
    puts "Loading game..."
    puts "Please wait a moment"
    puts "[#{bar}] #{percent}%"

    sleep(rand(0.1..0.3))
  end

  system("cls") || system("clear")
  puts "[#{'=' * width}] 100%"
  puts "✅ All done!"

  sleep 2
  system("cls") || system("clear")
end


# Word banks
WORD_BANK_EASY = [
  "apple", 
  "table", 
  "chair", 
  "house", 
  "water", 
  "happy", 
  "beach", 
  "music", 
  "light", 
  "smile", 
]

WORD_BANK_MEDIUM = [
  "lantern", 
  "thunder", 
  "whisper", 
  "journey", 
  "blanket", 
  "sunrise", 
  "courage", 
  "mystery", 
  "cactus"
]

WORD_BANK_HARD = [
  "quizzical", 
  "obsidian", 
  "zephyr", 
  "chrysalis", 
  "labyrinth", 
  "knapsack", 
  "vortex", 
  "phosphor", 
  "jigsaw"
]

@wrong_guess_limit = 10 # Default wrong guess limit set to 10
@previous_guesses = []  # Array to store previously guessed letters to avoid duplicate guesses

@settings_difficulty = "medium" # For future implementation of difficulty levels used for User Interface
@difficulty = WORD_BANK_MEDIUM  # Default word bank set to medium difficulty

@word = @difficulty.sample # Selects a random word from the word bank

  puts loading_bar_startup(5) # Loading bar for the startup
loop do

  system("cls") || system("clear") # Clear the console for a better user experience
  welcome_message = [
    "--------------------------------",
    "      Welcome to Hangman!",
    "--------------------------------",
    "  What would you like to do?",
    "  Play: Play a game",
    "  Settings: Change settings",
    "  Rules: Learn how to play",
    "  Exit: Exit the game",
    "--------------------------------"
  ]
  puts welcome_message.join("\n")
  print "> "
  main_menu_choice = gets.chomp.downcase

  case main_menu_choice
  when "play", "start", "play game", "game"
    system("cls") || system("clear") # Clear the console for a better user experience
    puts loading_bar_play(60) # Loading bar for the game start

    @display_word = Array.new(@word.length, '_') # create an array of underscores with the same length as the word
    puts "Starting a new game..."
    
    sleep 1

    loop do
      system("cls") || system("clear") # Clear the console for a better user experience

      puts "Chances left: #{@wrong_guess_limit}"
      puts "Difficulty: #{@settings_difficulty}"
      puts @display_word.join(" ")
      puts "\nGuess a letter or the whole word:"
      print "> "
      guess = gets.chomp.downcase

      if guess.empty?
        system("cls") || system("clear") # Clear the console for a better user experience

        puts "Please enter a guess."
        sleep 1
        next #skip to the next iteration of the loop

      elsif @previous_guesses.include?(guess)
        system("cls") || system("clear") # Clear the console for a better user experience

        puts "You already guessed that letter! Try again."
        sleep 1
        next # skip to the next iteration of the loop

      elsif guess == @word
        system("cls") || system("clear") # Clear the console for a better user experience

        puts "Congratulations! You guessed the word!"
        sleep 1
        break # exit the loop if the user guesses the word correctly

      elsif guess.length > @word.length
        system("cls") || system("clear") # Clear the console for a better user experience

        puts "Your guess is too long!"
        @wrong_guess_limit -= 1
        sleep 1
        next # skip to the next iteration of the loop

      elsif guess.length == @word.length && guess != @word
        system("cls") || system("clear") # Clear the console for a better user experience

        puts "Your guess is incorrect!"
        @wrong_guess_limit -= 1
        sleep 1
        next # skip to the next iteration of the loop

      elsif guess.length > 1
        system("cls") || system("clear") # Clear the console for a better user experience

        puts "Please guess a single letter or the whole word."

        sleep 1
        next # skip to the next iteration of the loop

      elsif @word.include?(guess)
        system("cls") || system("clear") # Clear the console for a better user experience

        puts "Correct!"
        # update the word with the correct guess
        @word.split("").each_with_index do |letter, i|
          if letter == guess
            @display_word[i] = guess
          end
        end
        # display the word with the correct guess
        
        if !@display_word.include?('_')
          puts "Congratulations! You completed the word!"
          sleep 1
          break
        end
        sleep 1

      else
        system("cls") || system("clear") # Clear the console for a better user experience

        puts "Incorrect! Try again."
        @wrong_guess_limit -= 1
        sleep 1
        next # skip to the next iteration of the loop

      end

      if @wrong_guess_limit == 0
        system("cls") || system("clear") # Clear the console for a better user experience

        puts "You guessed worng too many times! The word was #{@word}."
        break # exit the loop if the user runs out of chances
      end
    end

  when "settings"    
    loop do
      system("cls") || system("clear") # Clear the console for a better user experience
      settings_options = [
        "--------------------------------",
        "         Settings Menu:         ",
        "--------------------------------",
        " What would you like to change? ",
        " Difficulty: Change the difficulty level, currently set to #{@settings_difficulty}.",
        " Guesses: Change the maximum number of wrong guesses, currently set to #{@wrong_guess_limit}.",
        " Back: Return to main menu",
        "--------------------------------"
      ]
      puts settings_options.join("\n")
      print "> "
      settings_choice = gets.chomp.downcase
      case settings_choice

      when "difficulty", "diff" # settings for difficulty levels

        puts "Enter the new difficulty level (easy, medium, hard)"
        loop do
          print "> "
          new_difficulty = gets.chomp.downcase
          case new_difficulty
          when "easy"
            @difficulty = WORD_BANK_EASY
            @settings_difficulty = "easy"
            puts "Difficulty set to Easy."
            sleep 1
            break
          when "medium"
            @difficulty = WORD_BANK_MEDIUM
            @settings_difficulty = "medium"
            puts "Difficulty set to Medium."
            sleep 1
            break
          when "hard"
            @difficulty = WORD_BANK_HARD
            @settings_difficulty = "hard"
            puts "Difficulty set to Hard."
            sleep 1
            break
          else
            puts "Invalid difficulty level. Please enter \"easy\", \"medium\" or \"hard\"."
          end
        end

      when "guesses"
        puts "Enter the new maximum number of wrong guesses"
        loop do
          print "> "
          new_wrong_guess_limit = gets.chomp.to_i
          if new_wrong_guess_limit > 0
            @wrong_guess_limit = new_wrong_guess_limit
            puts "Maximum number of wrong guesses set to #{@wrong_guess_limit}."
            sleep 1
            break
          else
            puts "Please enter a positive number."
          end
        end

      when "back"
        puts "Returning to main menu..."
        break
      else
        puts "Invalid option, please enter \"Difficulty\", \"Chances\" or \"back\"."
      end
    end
  when "rules", "how to play"
    system("clear") || system("cls")  # Clears the terminal for a better user experience
    RULES = [
      "--------------------------------",
      "          How to play:",
      "--------------------------------",
      "      Welcome to Hangman!",
      " A random word will be chosen.",
      " You must guess the word one letter at a time or the whole word.",
      " You only get a limited number of incorrect guesses.",
      " You currently have #{@wrong_guess_limit} chances.",
      " If you guess a letter that is in the word, it will be revealed.",
      " Each wrong guess draws part of the hangman.",
      " The game ends when you either:",
      "   - Guess all the letters or the word correctly.",
      "   - Guess wrong too many times.",
      " To guess, just type a single letter or the whole word and press Enter.",
      " Letters you've already guessed won't count again.",
      "   Good luck, and have fun!",
      "--------------------------------"
    ]
    puts RULES.join("\n")
    puts "Press Enter to continue..."
    gets
    system("clear") || system("cls")  # Clears the terminal after pressing Enter

  when "exit"
    puts "Exiting the game..."
    sleep 1
    system("cls") || system("clear") # Clears the terminal before exiting the code so the terminal is empty for a better user experience
    break
  else
    puts "Invalid option, please try again."
  end
end