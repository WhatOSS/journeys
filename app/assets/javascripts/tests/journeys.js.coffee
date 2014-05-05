suite('Journeys')

test('.post sends the current url to the journeys server', ->

  server = sinon.fakeServer.create()

  Journeys.post()

  request = server.requests[0]

  assert.isDefined request, "Expected a request to be sent"

  assert.strictEqual request.url, "http://localhost:3000/events",
    "Expected the request to be sent to the journey server"

  assert.strictEqual request.method, "POST",
    "Expected the request to be a POST"

  sentParams = JSON.parse(request.requestBody)
  assert.strictEqual sentParams.slug, document.URL,
    "Expected the correct slug to be sent"
)
