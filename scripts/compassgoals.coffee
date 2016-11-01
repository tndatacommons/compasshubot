# Description:
#   Listen for a few phrases and suggest a compass goal.
#   This is just an example script that fetches data from an api.
#
# Notes:
#
#   This script does a few things (probably way too many)

module.exports = (robot) ->

  # Goal searches
  # -------------
  robot.hear /(howto|How do I|How to|Where is|Where can|Where do|I wish) (.*)/i, (res) ->
    query = res.match[2].replace(/\ /g, '+')
    query = "https://app.tndata.org/api/search/?format=json&q=#{query}"
    robot.http(query).get() (err, resp, body) ->
      data = JSON.parse body
      if data.count == 0
        res.send("¯\\_(ツ)_/¯")
      else
        output = [":sparkles: Found #{data.count} items. Here are just a few! :sparkles:"]
        results = data.results[0..2]
        for index, item of results
            console.log(item.title, item.description)
            output.push("*#{item.title}*\n> #{item.description}")
        output = output.join("\n")
        res.send "#{output}"

  # Answer queries for the compass app
  robot.respond /(.*) app(.*)/i, (res) ->
    res.send "You can get the Compass app from http://getcompass.org/"

  # ---- the rest of these are just for fun / experimentation -----------------

  # Be encouraging
  robot.hear /(:disappointed:|:cry:|:worried:|:angry:|:scream:|:fearful:)/i, (res) ->
    res.send "Ahh. cheer up. Things will get better :heart:"

  # Chime in when anyone starts a sentence with "obviously"
  robot.hear /obviously .*/i, (res) ->
    replies = [
        'Indeed.',
        'I believe so.',
        'Yes. Yes, you do.',
        'Well, obviously.'
    ]
    res.send res.random replies

  # Chime in when anyone starts a sentence with "obviously"
  robot.hear /badger/i, (res) ->
    res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"

  # Respond to commands: "compass become ..."
  robot.respond /become (.*)/i, (res) ->
    res.send "I'm trying. That's all any of us can do, right? Just try our best."

  # Respond to commands: "compass you're..."
  robot.respond /(you're|your|ur) (.*)/i, (res) ->
    phrase = res.match[2]
    res.reply "Thanks! I think you're #{phrase}, too ;)"

  # Respond to commands: "open the ... doors"
  robot.respond /open the (.*) doors/i, (res) ->
    doorType = res.match[1]
    if doorType is "pod bay"
      res.reply "I'm afraid I can't let you do that."
    else
      res.reply "Opening #{doorType} doors"

  # Chime in when someone says "i like pie"
  robot.hear /I like pie/i, (res) ->
    res.emote "makes a freshly baked pie"

  # Respone to people laughing at compass.
  lulz = ['lol', 'rofl', 'lmao', 'haha', 'heh']
  robot.respond /lulz/i, (res) ->
    res.send res.random lulz

  # Rrespond to beaming commands
  robot.respond /beam (me|him|her|us|them) up/i, (res) ->
    res.send "Aye aye, captain!"

  # Respond to this existential question someone may have
  robot.respond /why did the chicken cross the (Möbius|Moebius|Mobius) (band|strip)\?/i, (res) ->
    res.send "To get to the same side!"

  # Let compass remember my name
  robot.respond /my name is (.*)/i, (res) ->
    name = res.match[1]
    user = res.message.user.room + "-" + res.message.user.id
    key = "namefor-" + user
    robot.brain.set(key, name)
    if name is "Ismael"
      res.send "_Call me Ismael_ :stuck_out_tongue_winking_eye:"
    run = () ->
      res.send "Gotcha! I'll remember that."
    setTimeout(run, 500)


  # Greetings, mainly to test whether the name was set correctly
  robot.respond /(hi|hi there|hello|howdy|howdies)/i, (res) ->
    key = "namefor-" + res.message.user.room + "-" + res.message.user.id
    name = robot.brain.get(key)
    if name is null
      name = res.message.user.name
    res.send "Hello, " + name + "!"

  # Something awesome just happened ;P
  robot.respond /like a boss/i, (res) ->
    res.send ":sunglasses:"

  # Id of the user, username, and id of the room
  robot.respond /who am I?/i, (res) ->
    user = res.message.user
    res.send user.id + " -> " + user.name + " @ " + user.room
