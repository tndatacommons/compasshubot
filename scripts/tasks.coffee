
module.exports = (robot) ->
  robot.respond /add (.*) to (.*)/, (res) ->
    user = res.message.user
    mods = robot.brain.get(user.room + "-mods")
    if user.name in mods
      tasks = robot.brain.get(res.match[2] + "-tasks")
      if tasks is null
        tasks = []
      tasks.push(res.match[1])
      robot.brain.set(res.match[2] + "-tasks", tasks)
      res.send "Done!"

  robot.respond /what are my tasks\?/, (res) ->
    tasks = robot.brain.get(res.message.user.name + "-tasks")
    if tasks is null || tasks.length == 0
      res.send "Yo have no tasks."
    else
      output = ["Here are your tasks:"]
      for task in tasks
        output.push("*#{task}*")
      res.send output.join("\n")
