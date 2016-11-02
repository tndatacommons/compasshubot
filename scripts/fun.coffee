# Fun content
#   These are but a set of functions designed to tap into a user
#   conversation or respond to users requests for fun content

module.exports = (robot) ->
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

  # Something awesome just happened ;P
  robot.respond /like a boss/i, (res) ->
    res.send ":sunglasses:"

  robot.respond /crack a joke/i, (res) ->
    url = "https://app.tndata.org/api/rewards/?format=json&random=1&type=joke"
    robot.http(url).get() (err, resp, body) ->
      if !err
        data = JSON.parse body
        res.send data.results[0].message
      else
        res.send "Sorry, I don't have anything in store for now..."
