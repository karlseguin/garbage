helper = require('./../../helper')
Score = helper.require('./models/score')
redis = helper.require('./redis').instance

describe 'Score Save', ->

  it "checks the current score", ->
    spyOn(redis, 'zscore').andCallFake (key, user, cb) -> cb('err')
    score = new Score({user: 'paul', score: 22, lid: 334})
    score.save (err, cb) ->
      expect(redis.zscore).toHaveBeenCalledWith('lb:334', 'paul', jasmine.any(Function))

  it "returns error if we can't get the current score", ->
    spyOn(redis, 'zscore').andCallFake (key, user, cb) -> cb('error', null)
    score = new Score({user: 'leto', score: 99})
    score.save (err, cb) ->
      expect(err).toEqual('error')
      expect(cb).toBeUndefined()

  it "returns non-high score if this isn't a high score", ->
    spyOn(redis, 'zscore').andCallFake (key, user, cb) -> cb(null, '100')
    score = new Score({user: 'leto', score: 99})
    score.save (err, cb) ->
      expect(err).toBeNull()
      expect(cb).toEqual({high: false})

  it "returns high score if user didn't previously have a score", ->
    spyOn(redis, 'zscore').andCallFake (key, user, cb) -> cb(null, null)
    spyOn(redis, 'zadd')
    score = new Score({user: 'ghanima', score: 44, lid: 123})
    score.save (err, cb) ->
      expect(err).toBeNull()
      expect(cb).toEqual({high: true})
      expect(redis.zadd).toHaveBeenCalledWith('lb:123', 44, 'ghanima')