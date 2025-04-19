def hamburger(ham)
  i = 0 
  while i <= 6
    puts "Hamburger #{i}"
    if i == 3
      puts "I am full"
      break
    end
     i += 1
  end
  puts "I am hungry"
  unless i = ham
    puts "I am NOT hungry"
  end
  begin
    
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  ensure
    puts "I love hamburgers"
  end
  return ham + 1
end