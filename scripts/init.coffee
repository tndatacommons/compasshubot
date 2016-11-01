
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
