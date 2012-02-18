helper = require('./../helper')
config =
  tags:
    GET:
      '/': ['user', 'asset', 'type']
    POST:
      'about': ['id', 'verify']

signature = helper.require('./middleware/signature')(config)
FakeContext = helper.FakeContext

describe 'Signature Middleware', ->

  it "by default get doesn't need signature", ->
    fake = new FakeContext({method: 'GET', _context: {}})
    signature(fake.request, null, fake.pass)
    fake.assertNext(1)

  it "uses config override for get", ->
    fake = new FakeContext({query: {sig: 'f81a9b4f05524937f654e0c2304db860c524331a', user: 'leto', score: 5}, method: 'GET', _context: {resource: 'tags'}})
    signature(fake.request, null, fake.pass)
    fake.assertNext(1)

  it "delete gets signature from query", ->
    fake = new FakeContext({query: {sig: 'a7783bb4e0cedecf808c443e66bdf9f58e81de8b', user: 'leto', score: 5}, method: 'DELETE', _context: {resource: 'r'}})
    signature(fake.request, fake.response, fake.pass)
    fake.assertNext(1)

  it "post gets signature from body", ->
    fake = new FakeContext({body: {sig: '95c41efff97d95d1c1fbbadbd794bb72ce2bf9c2', user: 'ghanima', score: 4}, method: 'POST', _context: {resource: 'a'}})
    signature(fake.request, fake.response, fake.pass)
    fake.assertNext(1)

  it "put gets signature from body", ->
    fake = new FakeContext({body: {sig: 'a8079c987e59e1bef6c946020387ce82492bd95c', user: 'paul', score: 3}, method: 'PUT', _context: {resource: 'b'}})
    signature(fake.request, fake.response, fake.pass)
    fake.assertNext(1)

  it "put gets signature from body", ->
    fake = new FakeContext({body: {sig: 'a8079c987e59e1bef6c946020387ce82492bd95c', user: 'paul', score: 3}, method: 'PUT', _context: {resource: 'b'}})
    signature(fake.request, fake.response, fake.pass)
    fake.assertNext(1)

  it "uses override with action", ->
    fake = new FakeContext({body: {sig: '8ff38e718d119ecf272ab3e1c2d20291fc651729', test: true}, method: 'POST', _context: {resource: 'tags', action: 'about'}})
    signature(fake.request, fake.response, fake.pass)
    fake.assertNext(1)

  it "is invalid if the signature is invalid", ->
    fake = new FakeContext({body: {sig: '123'}, method: 'POST', _context: {resource: '32'}})
    signature(fake.request, fake.response, fake.pass)
    fake.assertInvalid({error: 'invalid signature'})

