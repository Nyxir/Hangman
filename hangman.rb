def clear_screen 
  # Function for less clutter in the code
  system("cls") || system("clear")
end

def loading_bar(max_duration = 100) 
  # I used ChatGPT to make this loading bar function
  # I had to integrate it into the game and change some things to make it work like I wanted it to but still...
  width = 30
  progress = 0

  while progress < max_duration
    progress = [progress + rand(1..5), max_duration].min
    percent = ((progress.to_f / max_duration) * 100).round
    completed = ((progress.to_f / max_duration) * width).round
    bar = "=" * completed + " " * (width - completed)
    
    clear_screen
    puts "Loading game..."
    puts "Please wait a moment"
    puts "[#{bar}] #{percent}%"
    sleep(rand(0.1..0.3))
  end

  clear_screen
  puts "[#{'=' * width}] 100%"
  puts "✅ All done!"
  sleep 0.5
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

# Game variables
@wrong_guess_limit = 10         # Default guess limit
@previous_guesses = []          # Empty arrray for storing users previous guesses
@settings_difficulty = "medium" # Default difficulty (used for showing difficulty level in the settings)
@difficulty = WORD_BANK_MEDIUM  # Default word bank
@word = @difficulty.sample      # Grabs a random word from the current difficulty wordbank

loading_bar(60)
# Show the loading bar

def welcome_menu
  clear_screen

  puts <<~MENU # Using HEREDOC for better readability and future changes (learned from ChatGPT)
    --------------------------------
          Welcome to Hangman!
    --------------------------------
      What would you like to do?
      Play: Play a game
      Settings: Change settings
      Rules: Learn how to play
      Exit: Exit the game
    --------------------------------
  MENU
end

def settings_menu_options
  clear_screen
  puts <<~SETTINGS # Using HEREDOC for better readability and future changes
    --------------------------------
            Settings Menu:
    --------------------------------
      What would you like to change?
      Difficulty: (Currently set to #{@settings_difficulty})
      Guesses: (Currently set to #{@wrong_guess_limit})
      Back: Return to main menu
    --------------------------------
  SETTINGS
end

def settings_menu
  loop do
    settings_menu_options
    print "> "
    choice = gets.chomp.downcase
    case choice
    when "difficulty", "diff"
      new_diff = nil # Initialize new_diff before loop to avoid uninitialized variable error and to avoid making it global

      loop do
        print "Enter the new difficulty (easy, medium or hard): "
        new_diff = gets.chomp.downcase

        case new_diff 
        when "easy"
          @difficulty = WORD_BANK_EASY
          break

        when "medium"
          @difficulty = WORD_BANK_MEDIUM
          break

        when "hard"
          @difficulty = WORD_BANK_HARD
          break

        else
          puts "Invalid choice."
          sleep 1
          next
        end
      end

      @settings_difficulty = new_diff
      puts "Difficulty set to #{new_diff}."
      sleep 1
      
    when "guesses"
      loop do
        print "Enter the new maximum number of wrong guesses: "
        new_limit = gets.chomp

        if new_limit.match?(/^\d+$/)
          new_limit = new_limit.to_i
          if new_limit > 0
            @wrong_guess_limit = new_limit
            puts "Wrong guess limit set to #{@wrong_guess_limit}."
            sleep 1
            break
          else 
            next
          end

        else
          puts "Invalid input. Please enter a positive number."
          sleep 1.5

          clear_screen
          settings_menu_options

        end
      end
      
    when "back", "exit", "return"
      break
    else
      puts "Invalid option. Please choose Difficulty, Guesses or Back."
      sleep 1
    end
  end
end

def display_rules
  clear_screen
  rules = <<~RULES
    --------------------------------
              How to play:
    --------------------------------
          Welcome to Hangman!
     A random word will be chosen.
     You must guess the word one letter at a time or the whole word.
     You only get a limited number of incorrect guesses.
     You currently have a maximum of #{@wrong_guess_limit} incorrect guesses.
     If you guess a letter that is in the word, it will be revealed.
     Each wrong guess draws part of the hangman.
     The game ends when you either:
       - Guess all the letters or the word correctly.
       - Guess wrong too many times.
     To guess, just type a single letter or the whole word and press Enter.
     Letters you've already guessed won't count again.
       Good luck, and have fun!
    --------------------------------
  RULES
  puts rules
  puts "Press Enter to continue..."
  gets
end

def game_loop
  @display_word = Array.new(@word.length, '_')

  loop do
    clear_screen

    if @wrong_guess_limit <= 0
      puts "Too many wrong guesses! The word was #{@word}."
      sleep 2
      exit
    end

    puts "Chances left: #{@wrong_guess_limit}"
    puts "Difficulty: #{@settings_difficulty.capitalize}"
    puts @display_word.join(" ")
    puts "\nGuess a letter or the whole word:"
    print "> "
    guess = gets.chomp.downcase

    # Handle empty or invalid input
    if guess.empty?
      puts "Please enter a guess."
      sleep 1
      next
    elsif @previous_guesses.include?(guess)
      puts "You already guessed \"#{guess}\". Try again."
      sleep 1
      next
    end

    # Record the guess if it's a single letter
    @previous_guesses << guess if guess.length == 1

    if guess == @word
      clear_screen
      puts "Congratulations! You guessed the word \"#{@word}\"!"
      sleep 0.5

      puts "Thanks for playing Hangman! Goodbye!"
      sleep 1.5
      break

    elsif guess.length > 1
      if guess.length == @word.length
        puts "Incorrect guess for the whole word."
      else
        puts "Your guess is too long. Please guess a single letter or the whole word."
      end
      @wrong_guess_limit -= 1
      sleep 1
      next
    elsif @word.include?(guess)
      puts "Correct guess!"
      @word.chars.each_with_index do |char, i|
        @display_word[i] = guess if char == guess
      end
      if !@display_word.include?('_')
        puts "Congratulations! You completed the word: #{@word}!"
        sleep 0.5

        puts "Thanks for playing Hangman! Goodbye!"
        sleep 1.5

        break
      end
    else
      puts "Incorrect! Try again."
      @wrong_guess_limit -= 1
    end
    sleep 1
  end
end

# Main Menu Loop
loop do
  puts welcome_menu
  print "> "
  choice = gets.chomp.downcase
  case choice
  when "play", "start", "play game", "game"
    clear_screen
    puts "Starting a new game..."
    sleep 1
    game_loop
  when "settings", "options", "config", "menu"
    settings_menu
  when "rules", "how to play"
    display_rules
  when "exit", "quit", "leave"
    puts "Exiting the game..."
    sleep 1
    clear_screen
    break
  else
    puts "Invalid option. Please try again."
    sleep 1
  end
end
