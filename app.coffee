redis = require('./src/redis')
cluster = require('cluster')
config = require('./src/config')
cpus = config.cluster.numberOfCpus

if cpus == 0
  cpus = require('os').cpus().length

if cluster.isMaster
  cluster.fork() for i in [1..cpus]
  cluster.on 'death', (w) ->
    console.log('worker %d died, restarting', w.pid)
    cluster.fork()
  console.log('starting %d workers', cpus)
else
  redis.initialize (err) ->
    return console.log(err) if err?
    require('./src/server')
