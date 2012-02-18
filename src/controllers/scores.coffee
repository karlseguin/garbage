Score = require('./../models/score')

module.exports = (app) ->
  app.post '/scores', (req, res) ->
    score = Score.fromParams(req.body)
    return res.invalid(score.errors) if !score.validate()
    score.save (err, data) ->
      return res.invalid({error: err}) if err?
      res.valid(data)