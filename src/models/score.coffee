model = require('node-model')
redis = require('./../redis').instance

class Score extends model.Model
  @attr 'user', model.types.string
  @attr 'score', model.types.integer
  @attr 'lid', model.types.integer

  @validateLength 'user', {required: true, min:1, max: 30}, 'user should be between 1-30 characters'
  @validatePresence 'score', 'score is required'
  @validatePresence 'lid', 'leaderboard id (lid) is required'

  @fromParams: (params) ->
    new Score(params)

  save: (callback) ->
    key = 'lb:' + @lid
    redis.zscore key, @user, (err, data) =>
      return callback(err) if err?
      oldScore = if data? then parseInt(data) else 0

      high = false
      if oldScore < @score
        high = true
        redis.zadd key, @score, @user

      callback(null, {high: high})


module.exports = Score