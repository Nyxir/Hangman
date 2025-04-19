# --- Constants ---
WELCOME_MESSAGE = [
  "--------------------------------",
  "     Welcome to Hangman!      ",
  "--------------------------------",
  "What would you like to do?",
  "  Play: Play a game",
  "  Settings: Change settings",
  "  Instructions: Learn how to play",
  "  Exit: Exit the game",
  "--------------------------------"
].freeze # Use .freeze for constants that shouldn't change

WORD_BANK_EASY = [
  "apple", "table", "chair", "house", "water", "happy", "beach", "music", "light", "smile", "fart", "dance"
].freeze # Store words in lowercase directly for simplicity

WORD_BANK_MEDIUM = [
  "lantern", "thunder", "whisper", "journey", "blanket", "sunrise", "courage", "mystery", "cactus"
].freeze 

WORD_BANK_HARD = [
  "quizzical", "obsidian", "zephyr", "chrysalis", "labyrinth", "knapsack", "vortex", "phosphor", "jigsaw"
].freeze

WORD_BANK_IMPOSSIBLE = [
  "pneumonoultramicroscopicsilicovolcanoconiosis", "floccinaucinihilipilification",
  "antidisestablishmentarianism", "hippopotomonstrosesquippedaliophobia",
  "supercalifragilisticexpialidocious", "sesquipedalianism",
  "dichlorodifluoromethane", "electroencephalographically", "thyroparathyroidectomized",
  "uncharacteristically", "subcompartmentalization", "counterdemonstration", "quantumchromodynamics",
  "psychoneuroendocrinological", "triskaidekaphobia", "pseudopseudohypoparathyroidism"
].freeze
# --- Settings Variables ---
current_word_bank = WORD_BANK_MEDIUM # default word bank
settings_difficulty = "medium"       # default difficulty name
default_guesses = 10                 # default number of chances

# --- Main Menu Loop ---
loop do
  puts WELCOME_MESSAGE.join("\n")
  print "> "
  choice = gets.chomp.downcase

  case choice
  when "play"
    puts "\nStarting a new game..."
    puts "Difficulty: #{settings_difficulty.capitalize}" # Capitalize for display because big letters are cool

    # --- Game Setup ---
    word = current_word_bank.sample # Selects a random word (already lowercase)
    if word.nil? || word.empty?
      puts "Error: Word bank for difficulty '#{settings_difficulty}' is empty or invalid."
      next # Go back to main menu
    end
    guesses_left = default_guesses      # Reset guesses for this game
    display_word = Array.new(word.length, '_')
    already_guessed = [] # Track guessed letters

    puts "Guesses left: #{guesses_left}"
    puts "Word: #{display_word.join(" ")}\n"

    # --- Game Loop ---
    loop do
      puts "Guessed letters: #{already_guessed.empty? ? 'None yet' : already_guessed.join(', ')}"
      print "Guess a letter or the whole word (#{guesses_left} guesses left): "
      guess = gets.chomp.downcase

      # --- Input Validation / Handling ---
      if guess.empty?
        puts "Please enter a guess."
        next
      elsif already_guessed.include?(guess)
        puts "You already guessed '#{guess}'. Try a different letter."
        next
      end

      # --- Guess Processing ---
      if guess == word # Correct full word guess
        puts "\nCongratulations! You guessed the word: #{word.capitalize}" # Show original case maybe? Or just keep lowercase.
        break # Exit game loop (win)

      elsif guess.length == word.length # Incorrect full word guess
         puts "Sorry, that's not the word."
         guesses_left -= 1
         already_guessed << guess # Add the wrong word guess to history if desired? Maybe not.

      elsif guess.length == 1 && word.include?(guess) # Correct letter guess
        puts "Correct!"
        found_letter = false # Flag to ensure we add guess to already_guessed only once if correct
        word.chars.each_with_index do |letter, i|
          if letter == guess
            display_word[i] = guess
            found_letter = true
          end
        end
        already_guessed << guess if found_letter # Add correct letter guess to history
        puts "\nWord: #{display_word.join(" ")}"

        if !display_word.include?('_')
          puts "\nCongratulations! You completed the word: #{word.capitalize}"
          break # Exit game loop (win)
        end

      elsif guess.length == 1 # Incorrect letter guess
        puts "Incorrect! The word doesn't contain '#{guess}'."
        guesses_left -= 1
        already_guessed << guess # Add incorrect letter guess to history

      else # Invalid guess (neither single letter nor full word length)
        puts "Invalid guess. Please enter a single letter or the whole word."
        # Optionally, don't penalize for this type of invalid input:
        # next
        # Or penalize:
        # guesses_left -= 1
      end

      # --- Check Loss Condition ---
      puts "Guesses left: #{guesses_left}"
      if guesses_left <= 0
        puts "\nYou ran out of guesses! The word was: #{word.capitalize}"
        break # Exit game loop (loss)
      end
      puts "--------------------------------" # Separator for next turn

    end # End of inner game loop

  when "settings"
    puts "\n--- Settings ---"
    puts "What would you like to change?"
    settings_options = [
      "  Difficulty: Change the difficulty level (Current: #{settings_difficulty.capitalize})",
      "  Chances: Change the number of guesses (Current: #{default_guesses})",
      "  Back: Return to main menu",
      "--------------------------------"
    ]
    puts settings_options.join("\n")
    print "> "
    settings_choice = gets.chomp.downcase

    case settings_choice
    when "difficulty", "diff"
      puts "\nSelect a difficulty level:"
      difficulty_options = ["Easy", "Medium", "Hard", "Impossible"]
      puts difficulty_options.map { |d| "  #{d}" }.join("\n") # Indent options
      print "> "
      difficulty_choice = gets.chomp.downcase

      case difficulty_choice
      when "easy"
        settings_difficulty = "easy"
        current_word_bank = WORD_BANK_EASY
        puts "Difficulty set to Easy."
      when "medium"
        settings_difficulty = "medium"
        current_word_bank = WORD_BANK_MEDIUM
        puts "Difficulty set to Medium."
      when "hard"
        settings_difficulty = "hard"
        current_word_bank = WORD_BANK_HARD
        puts "Difficulty set to Hard."
      when "impossible"
        settings_difficulty = "impossible"
        current_word_bank = WORD_BANK_IMPOSSIBLE
        puts "Difficulty set to Impossible."
      else
        puts "Invalid difficulty level selected. No changes made."
      end

    when "chances", "chance"
      print "Enter the desired number of chances (e.g., 10): "
      input_chances = gets.chomp
      # Validate input is a positive integer
      if input_chances.match?(/^\d+$/) && input_chances.to_i > 0
        default_guesses = input_chances.to_i
        puts "Number of chances set to #{default_guesses}."
      else
        puts "Invalid input. Please enter a positive whole number for chances. No changes made."
      end
    when "back"
        puts "Returning to main menu."
    else
      puts "Invalid settings option."
    end
    puts "" # Add a newline for spacing

  when "instructions"
    puts "\n--- Instructions ---"
    instructions = [
      "A random word from the '#{settings_difficulty.capitalize}' word bank will be chosen.",
      "You will have #{default_guesses} chances (guesses) to figure out the word.",
      "Each turn, you can guess a single letter or the entire word.",
      "If you guess a correct letter, its position(s) in the word will be revealed.",
      "If you guess an incorrect letter or word, you lose a chance.",
      "Guessing a letter you already tried won't cost a chance.",
      "If you guess the whole word correctly, you win!",
      "If you run out of chances before guessing the word, you lose.",
      "Good luck!",
      "--------------------------------"
    ]
    puts instructions.join("\n")
    puts "(Returning to menu automatically...)"
    sleep 4 # Slightly longer pause

  when "exit"
    puts "\nThanks for playing Hangman! Exiting..."
    break # Exit the main loop
  else # Invalid main menu option
    puts "Invalid option '#{choice}'. Please choose Play, Settings, Instructions, or Exit."
  end
  puts "\n" # Add spacing before showing the menu again
end # End of main loop