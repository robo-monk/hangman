def save_game
  File.open("games/last_game.txt", 'w') { |file| file.write("#{@target_word.chomp}\n#{@gues.to_s[1...-1]}\n#{@remain_gues}") }
end
def render_frame ph, rg
  system "clear"
  puts "\n\n" + ph +"\n\n"
  puts "#{rg} attempts remaining!" +"\n"
end
def get_user_input msg
  print msg + " >> "
  user_input = gets.chomp
  if user_input == ":s"
    save_game
    return
  end
  return user_input
end
def build_placeholder target, keys
  ph = target.chomp.chars.map do |letter|
    if keys.any?{|l| l==letter}
      letter
    else
      "_"
    end
  end
  return ph.join("")
end
def won? target, keys
  return target.chomp.chars.all? do |letter| keys.any? {|l| l==letter} end
end
def initialize_game
  @filtered_words = Array.new

  File.open("words/5desk.txt", "r") do |f|
    f.each_line do |word|
      if !(word.length < 5 || word.length > 12)
        @filtered_words << word
      end
    end
  end
  puts "Welcome to Hangman!"
  print "Would you like to load last game? [Y/any] >> "
  if gets.chomp.downcase == "y"
    File.open("games/last_game.txt", "r") do |f|
      f.each_with_index do |line, index|
        case index
        when 0
          @target_word = line
        when 1
          @gues = line.split(", ").map{|seq| seq[1...-1]}
        when 2
          @remain_gues = line.to_i
        end
      end
    end
  else
    @target_word = @filtered_words[rand(@filtered_words.length)]
    puts @target_word
    placeholder = "_"*@target_word.length
    @remain_gues = 5
    @gues = Array.new
  end

  won = false
  while @remain_gues>0 do 
    render_frame((build_placeholder @target_word, @gues), @remain_gues)
    @gues << get_user_input("Enter letter [:S, to save game]")
    if @target_word.chomp.chars.any?{|l| l==@gues.last}
      puts 'nice'
    else
      puts ':O'
      @remain_gues-=1
    end
    if won? @target_word, @gues
      won = true
      break
    end
  end
  puts "\n\n\n"
  puts won ? "Nice dude" : ["F"]*1000
  puts "Would you like to try again?[any/N]"
  if gets.chomp.downcase != "n"
    initialize_game
  else
    puts "Thanks for playing! Bye."
  end
end

initialize_game