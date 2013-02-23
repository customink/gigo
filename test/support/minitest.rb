require 'minitest/emoji'

if ENV['CI']
  MiniTest::Emoji::DEFAULT.merge! '.' => ".", 'F' => "F", 'E' => "E", 'S' => "S"
else
  MiniTest::Emoji::DEFAULT.merge! '.' => "\u{1f49A} ", 'F' => "\u{1f494} ", 'E' => "\u{1f480} ", 'S' => "\u{1f49B} "
end
