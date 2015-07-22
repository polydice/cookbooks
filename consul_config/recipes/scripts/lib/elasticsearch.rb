require "net/http"

uri = URI("http://127.0.0.1:9200/_cat/health?v&ts=0")
result = Net::HTTP.get(uri)

case result
when /green/
  puts 0
when /yellow/
  puts 1
when /red/
  puts 2
end

