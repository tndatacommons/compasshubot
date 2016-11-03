# Description:
#   Listen for a few phrases and suggest a compass goal.
#   This is just an example script that fetches data from an api.

module.exports = (robot) ->

  # -------------
  # Goal searches
  # -------------
  robot.hear /(howto|How do|How to|How do I|I wish) (.*)/i, (res) ->
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
