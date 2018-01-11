require 'json'
require 'open-uri'

puts 'fetching json'
@emotes_json = JSON.load(open("https://twitchemotes.com/api_cache/v3/global.json"))
@subscriber_json = JSON.load(open("https://twitchemotes.com/api_cache/v3/subscriber.json"))

puts 'sorting subscriber json data'
@sub_emotes = []

@subscriber_json.each_pair do |channel, data|
  data['emotes'].each do |emote|
    @sub_emotes << emote
  end
end

Dir.mkdir('1x') unless Dir.exist?('1x')
Dir.mkdir('2x') unless Dir.exist?('2x')
Dir.mkdir('3x') unless Dir.exist?('3x')

def user_choice
  puts 'Global or Subscriber emotes?'
  puts 'options: global, subscriber'
  glob_or_sub = gets.chomp

  puts 'Download all emotes or specific emote?'
  puts 'options: all, emote name'
  puts 'example: BibleThump'
  all_or_single = gets.chomp

  case
  when glob_or_sub == 'subscriber' && all_or_single == 'all'
    sub_emotes_all
  when glob_or_sub == 'subscriber' && all_or_single != 'all'
    sub_emote_specific(all_or_single)
  when glob_or_sub == 'global' && all_or_single == 'all'
    global_emotes_all
  when glob_or_sub == 'global' && all_or_single != 'all'
    global_emote_specific(all_or_single)
  end
end

def sub_emotes_all
  @sub_emotes.each do |emote|
    urlx1 = "https://static-cdn.jtvnw.net/emoticons/v1/#{emote['id']}/1.0"
    urlx2 = "https://static-cdn.jtvnw.net/emoticons/v1/#{emote['id']}/2.0"
    urlx3 = "https://static-cdn.jtvnw.net/emoticons/v1/#{emote['id']}/3.0"

    3.times do |x|
      puts "saving emote:#{emote['code']} size:#{(x + 1)}x"
      open("#{(x + 1)}x/#{emote['code']}.png", 'wb') do |file|
        file << open(urlx1).read if x == 0
        file << open(urlx2).read if x == 1
        file << open(urlx3).read if x == 2
      end
      puts 'sleeping 5 seconds between to avoid hammering'
      sleep(5)
    end
    puts 'sleeping 30 seconds to avoid hammering'
    sleep(30)
  end
  user_choice
end

def sub_emote_specific(emote_code)
  @sub_emotes.each do |emote|
    next if emote['code'] != emote_code

    urlx1 = "https://static-cdn.jtvnw.net/emoticons/v1/#{emote['id']}/1.0"
    urlx2 = "https://static-cdn.jtvnw.net/emoticons/v1/#{emote['id']}/2.0"
    urlx3 = "https://static-cdn.jtvnw.net/emoticons/v1/#{emote['id']}/3.0"

    3.times do |x|
      puts "saving emote:#{emote['code']} size:#{(x + 1)}x"
      open("#{(x + 1)}x/#{emote['code']}.png", 'wb') do |file|
        file << open(urlx1).read if x == 0
        file << open(urlx2).read if x == 1
        file << open(urlx3).read if x == 2
      end
      puts 'sleeping 5 seconds between to avoid hammering'
      sleep(5)
    end
    puts 'sleeping 30 seconds to avoid hammering'
    sleep(30)
  end
  user_choice
end

def global_emotes_all
  @emotes_json.each_pair do |emote, json_data|
    urlx1 = "https://static-cdn.jtvnw.net/emoticons/v1/#{json_data['id']}/1.0"
    urlx2 = "https://static-cdn.jtvnw.net/emoticons/v1/#{json_data['id']}/2.0"
    urlx3 = "https://static-cdn.jtvnw.net/emoticons/v1/#{json_data['id']}/3.0"

    3.times do |x|
      puts "saving emote:#{emote} size:#{(x + 1)}x"
      open("#{(x + 1)}x/#{emote}.png", 'wb') do |file|
        file << open(urlx1).read if x == 0
        file << open(urlx2).read if x == 1
        file << open(urlx3).read if x == 2
      end
      puts 'sleeping 5 seconds between to avoid hammering'
      sleep(5)
    end
    puts 'sleeping 30 seconds to avoid hammering'
    sleep(30)
  end
  user_choice
end

def global_emote_specific(emote)
  id = @emotes_json["#{emote}"]['id']
  urlx1 = "https://static-cdn.jtvnw.net/emoticons/v1/#{id}/1.0"
  urlx2 = "https://static-cdn.jtvnw.net/emoticons/v1/#{id}/2.0"
  urlx3 = "https://static-cdn.jtvnw.net/emoticons/v1/#{id}/3.0"

  3.times do |x|
    puts "saving emote:#{emote} size:#{(x + 1)}x"
    open("#{(x + 1)}x/#{emote}.png", 'wb') do |file|
      file << open(urlx1).read if x == 0
      file << open(urlx2).read if x == 1
      file << open(urlx3).read if x == 2
    end
    puts 'sleeping 5 seconds between to avoid hammering'
    sleep(5)
  end
  puts 'sleeping 30 seconds to avoid hammering'
  sleep(30)
  user_choice
end

user_choice

# Old Python script found on reddit
# import urllib
# import os
# import json
#
# if not os.path.exists('./emotes'):
#     os.makedirs('./emotes')
# print('Saving emotes to folder: ' + os.path.abspath('./emotes') + '...')
# print('Grabbing emote list...')
# emotes = json.load(urllib.urlopen('https://twitchemotes.com/api_cache/v2/global.json'))
# for code, emote in emotes['emotes'].items():
#     print('Downloading: ' + code + '...')
#     urllib.urlretrieve('http:' + emotes['template']['large'].replace('{image_id}', str(emote['image_id'])),
#                       './emotes/' + code + '.png')
# print('Done! Kappa')
