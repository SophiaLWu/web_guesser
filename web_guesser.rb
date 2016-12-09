require "sinatra"
require "sinatra/reloader"

set :secret_number, rand(100)
@@guesses_left = 5

def check_guess(guess, secret_number)
  if guess > secret_number
    if guess - secret_number > 5
      "Way too high!"
    else
      "Too high!"
    end
  elsif guess < secret_number
    if secret_number - guess > 5
      "Way too low!"
    else
      "Too low!"
    end
  else
    "You got it right!"
  end
end

get "/" do
  guess = params["guess"].to_i
  cheat_mode = params["cheat"]
  message = check_guess(guess, settings.secret_number)
  @@guesses_left -= 1
  if @@guesses_left == 0 || message == "You got it right!"
    settings.secret_number = rand(100)
    @@guesses_left = 5
    if message != "You got it right!"
      message = "You lost! There is now a new secret number."
    end
  end
  erb :index, :locals => {:guess => guess,
                          :message => message,
                          :secret_number => settings.secret_number,
                          :cheat_mode => cheat_mode,
                          :guesses_left => @@guesses_left}
end