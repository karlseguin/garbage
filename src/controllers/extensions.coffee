http = require('http')

http.ServerResponse.prototype.invalid = (errors) ->
  @writeHead(400, {'Content-Type', 'application/json'})
  @end(JSON.stringify(errors))

http.ServerResponse.prototype.valid = (body) ->
  @writeHead(200, {'Content-Type', 'application/json'})
  @end(JSON.stringify(body))