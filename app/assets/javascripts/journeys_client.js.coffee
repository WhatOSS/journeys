JOURNEY_SERVER = 'http://localhost:3000'

window.Journeys =
  post: ->
    data = slug: document.URL
    $.post("#{JOURNEY_SERVER}/events", JSON.stringify(data))
