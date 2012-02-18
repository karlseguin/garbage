helper = require('./../helper')
context = helper.require('./middleware/context')()
FakeContext = helper.FakeContext

describe 'Version Middleware', ->

  it "extracts the context", ->
    fake = new FakeContext({url: '/v3/users/rename', method: 'METH'})
    context(fake.request, null, fake.pass)
    expect(fake.request.url).toEqual('/users/rename')
    expect(fake.request._context.version).toEqual(3)
    expect(fake.request._context.resource).toEqual('users')
    expect(fake.request._context.action).toEqual('rename')
    expect(fake.request._context.url).toEqual('/v3/users/rename')
    expect(fake.request._context.method).toEqual('METH')
    fake.assertNext(1)

  it "extracts the context with no action", ->
    fake = new FakeContext({url: '/v102/fun', method: 'DEL'})
    context(fake.request, null, fake.pass)
    expect(fake.request.url).toEqual('/fun')
    expect(fake.request._context.version).toEqual(102)
    expect(fake.request._context.resource).toEqual('fun')
    expect(fake.request._context.action).toBeUndefined()
    expect(fake.request._context.url).toEqual('/v102/fun')
    fake.assertNext(1)