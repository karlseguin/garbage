source = if process.argv[1] == 'app.coffee' then './src/' else './lib/'

redis = require(source + 'redis')
config = require(source + 'config')
cluster = require('cluster')
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
    require(source + 'server')
