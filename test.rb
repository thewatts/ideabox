word = "bubble"

word.chars.inject([]) do |new_word, letter|
  new_word << letter if letter != new_word[-1]
end.join

word.chars.inject(0) do |sum, letter|
  sum += letter.length
end
