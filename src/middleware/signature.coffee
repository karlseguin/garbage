hashlib = require('hashlib')

signature = (config) ->
  signature = (request, response, next) ->
    method = request.method
    context = request._context
    action = if context.action? then context.action else '/'
    keys = config[context.resource]?[method]?[action]

    return next() if method == 'GET' && !keys?

    params = if method == 'GET' || method == 'DELETE' then request.query else request.body
    signature = params['sig']
    return response.invalid({error: 'missing signature'}) unless signature?

    keys = Object.keys(params).sort()
    str = ''
    str += key + '|' + params[key] + '|' for key in keys when key != 'sig'
    str += context.resource.toLowerCase() #todo add secret

    return response.invalid({error: 'invalid signature'}) if hashlib.sha1(str) != signature
    next()

module.exports = signature