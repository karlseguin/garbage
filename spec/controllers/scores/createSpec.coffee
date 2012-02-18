helper = require('./../../helper')
Score = helper.require('./models/score')
controller = helper.controller('scores', 'post', '/scores')
FakeContext = helper.FakeContext

describe 'Create Score', ->
  beforeEach -> @score = new Score()

  it "writes errors if the score is not valid", ->
    spyOn(Score, 'fromParams').andReturn(@score)
    spyOn(@score, 'validate').andReturn(false)
    @score.errors = {user: 'invalid'}

    context = new FakeContext({body: {}})
    controller(context)
    context.assertInvalid({user: 'invalid'})

  it "writes the save error", ->
    spyOn(Score, 'fromParams').andReturn(@score)
    spyOn(@score, 'validate').andReturn(true)
    spyOn(@score, 'save').andCallFake (a) -> a('err', null)

    context = new FakeContext({body: {}})
    controller(context)
    context.assertInvalid({error: 'err'})

  it "saves the score and writes the response", ->
    spyOn(Score, 'fromParams').andReturn(@score)
    spyOn(@score, 'validate').andReturn(true)
    spyOn(@score, 'save').andCallFake (a) -> a(null, {rank: 23})

    context = new FakeContext({body: {}})
    controller(context)
    context.assertValid({rank: 23})
