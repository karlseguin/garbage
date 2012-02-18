captures = ['version', 'resource', 'action']
routePattern = /\/v(\d+)\/(\w+)(\/(\w+))?/
context =  () ->
  context = (request, response, next) ->
    request._context = {url: request.url, method: request.method}
    match = routePattern.exec(request.url)
    return next() unless match?

    request._context.version = parseInt(match[1])
    request._context.resource = match[2]
    request._context.action = match[4]
    request.url = request.url.substring(2 + match[1].length)
    next()

module.exports = context