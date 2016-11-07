# Initialization
#   Anything involving setting initial values, managing user lists, or
#   setting names and mods.
#
# Commands:
#   I am the mod - You self procclaimed as the mod of this room. Only works if job is vacant.
#   grant <user> mod privileges - If you are a mod you can promote other people!
#   Who is the mod? - Lists the mods
#   My name is <name> - I'll remember that
#   Hello - If you want to greet compass

token = process.env.HUBOT_SLACK_TOKEN

module.exports = (robot) ->

  robot.hear /I('m| am) the mod/i, (res) ->
    user = res.message.user
    mods = robot.brain.get(user.room + "-mods")
    if mods is null
      mods = []
    if mods.length == 0
      mods.push(user.name)
      robot.brain.set(user.room + "-mods", mods)
      res.send "Okay, gotcha!"

  robot.respond /grant (.*) mod privileges/i, (res) ->
      user = res.message.user
      mods = robot.brain.get(user.room + "-mods")
      if mods is null
        mods = []
      if mods.length == 0
        mods.push(res.match[1])
        robot.brain.set(user.room + "-mods", mods)
        res.send "Okay, gotcha!"
      else
        if user.name in mods
          mods.push(res.match[1])
          robot.brain.set(user.room + "-mods", mods)
          res.send "Okay, gotcha!"

  robot.respond /Who(\'s| is| are) the mo(d|ds)?/i, (res) ->
    user = res.message.user
    mods = robot.brain.get(user.room + "-mods")
    if mods is null || mods.length == 0
      res.send "We have no mods"
    else
      output = []
      for mod in mods
        output.push(mod)
      res.send output.join("\n")

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

  robot.respond /test/i, (res) ->
    console.log("Token", token)
    query = "https://slack.com/api/chat.postMessage?token=#{token}&channel=@compass&text=Test"
    robot.http(query).post() (err, resp, body) ->
      console.log("INIT", body)

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
