require('../src/redis').instance =
  zscore: ->
  zadd: ->

module.exports.require = (path) ->
  require('../src/' + path)

module.exports.controller = (name, method, path) ->
  app = new FakeApp()
  require('../src/controllers/' + name)(app)
  app.routes[method][path]

class FakeApp
  constructor: ->
    @routes = {get: {}, post: {}, put: {}, delete: {}}

  get: (path, cb) ->
    @routes.get[path] = (context) -> cb(context.request, context.response)

  post: (path, cb) ->
    @routes.post[path] = (context) -> cb(context.request, context.response)

  put: (path, cb) ->
    @routes.put[path] = (context) -> cb(context.request, context.response)

  delete: (path, cb) ->
    @routes.delete[path] = (context) -> cb(context.request, context.response)

class FakeContext
  constructor: (request) ->
    @request = request || {}

    @response =
      invalid: (errors) ->
        @writeHead(400, {'Content-Type', 'application/json'})
        @end(JSON.stringify(errors))
      valid: (body) ->
        @writeHead(200, {'Content-Type', 'application/json'})
        @end(JSON.stringify(body))
      writeHead: (code, headers) =>
        @responseCode = code
        @responseHeaders = headers
      end: (body) =>
        @responseBody = body

    @nextCount = 0

  pass: (err) =>
    @nextCount += 1
    expect(err).toBeUndefined()

  assertNext: (count) ->
    expect(@nextCount).toEqual(count || 1)

  assertInvalid: (errors) ->
    @assertResponse(400, errors)

  assertValid: (body) ->
    @assertResponse(200, body)

  assertResponse: (status, body) ->
    expect(@responseCode).toEqual(status)
    expect(@responseHeaders).toEqual({'Content-Type', 'application/json'})
    expect(JSON.parse(@responseBody)).toEqual(body)

module.exports.FakeContext = FakeContext