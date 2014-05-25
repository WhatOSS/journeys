JOURNEY_SERVER = 'http://stage.journ.cyanoryx.com'

window.Journeys =
  post: ->
    data = slug: document.URL
    $.ajax(
      type: "POST"
      url: "#{JOURNEY_SERVER}/events"
      data: JSON.stringify(data)
      contentType:"application/json; charset=utf-8"
    )
