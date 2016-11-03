# Description:
#
#   This recipe will listen for a few phrases that may indicate someone
#   asking directions. For example:
#
#   - How do I get from my house to southwest tennessee community college?
#   - i need to go from work to school
#   -
#
#   It also response to "where is..." questions, such as:
#
#   - where is the DMV
#   - where can i find a coffee shop
#   - do you know where I can find a coffee shop
#   - where is daycare
#   - help me find a grocery store
#
#

module.exports = (robot) ->

  # Directions.
  robot.hear /(.*) from (.*) to (.*)/i, (res) ->
    source = res.match[2].replace(/\ /g, '+')
    destination = res.match[3].replace(/\ /g, '+')
    url = "https://www.google.com/maps/dir/#{source}/#{destination}/"
    res.send "Perhaps this Google map will help:\n #{url}"

  # Where is...?
  robot.respond /(.* ?)where (i can find|can i find|is the|is a|is an|is|are the|are) (.*)/i, (res) ->
    query = res.match[3].replace(/\ /g, '+')
    url = "https://www.google.com/maps/search/#{query}/"
    res.send "Perhaps this Google map will help:\n #{url}"

  # Find...
  robot.respond /(.* ?)find (.*)/i, (res) ->
    query = res.match[2].replace(/\ /g, '+')
    url = "https://www.google.com/maps/search/#{query}/"
    res.send "Perhaps this Google map will help:\n #{url}"
