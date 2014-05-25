JOURNEY_SERVER = 'http://localhost:3000'

window.Journeys =
  post: ->
    data = slug: document.URL
    $.ajax(
      type: "POST"
      url: "#{JOURNEY_SERVER}/events"
      data: JSON.stringify(data)
      contentType:"application/json; charset=utf-8"
    )
