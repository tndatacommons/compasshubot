# Initialization
#   Anything involving setting initial values, managing user lists, or
#   setting names and mods.

module.exports = (robot) ->

  robot.hear /I('m| am) the mod/i, (res) ->
    user = res.message.user
    mod = robot.brain.get(user.room + "-mod")
    if mod is null
      robot.brain.set(user.room + "-mod", user.id)
      res.send "Okay, gotcha!"

  robot.respond /count people/i, (res) ->
    people = robot.brain.get(res.message.user.room + "-people")
    res.send people.length + " people"

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

  # Id of the user, username, and id of the room
  robot.respond /who am I?/i, (res) ->
    user = res.message.user
    res.send user.id + " -> " + user.name + " @ " + user.room

  # Say something when somone enters the channel.
  enterReplies = [
    "Hi! I'm the compass bot.",
    'Howdy. Ask me queestions or say "compass help" to learn more.',
  ]
  leaveReplies = ['Later!', 'Goodbye', 'Adios']

  robot.enter (res) ->
    user = res.message.user
    people = robot.brain.get(user.room + "-people")
    if people is null
      people = []
    people.push(user.name)
    robot.brain.set(user.room + "-people", people)
    res.send res.random enterReplies

  robot.leave (res) ->
    user = res.message.user
    people = robot.brain.get(user.room + "-people")
    if people isnt null
      index = people.indexOf(user.name)
      if index isnt -1
        people.splice(index, 1)
        robot.brain.set(user.room + "-people", people)
    res.send res.random leaveReplies
