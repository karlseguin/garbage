(function() {
  var cluster, config, cpus, i, redis, source;

  source = process.argv[1] === 'app.coffee' ? './src/' : './lib/';

  redis = require(source + 'redis');

  config = require(source + 'config');

  cluster = require('cluster');

  cpus = config.cluster.numberOfCpus;

  if (cpus === 0) cpus = require('os').cpus().length;

  if (cluster.isMaster) {
    for (i = 1; 1 <= cpus ? i <= cpus : i >= cpus; 1 <= cpus ? i++ : i--) {
      cluster.fork();
    }
    cluster.on('death', function(w) {
      console.log('worker %d died, restarting', w.pid);
      return cluster.fork();
    });
    console.log('starting %d workers', cpus);
  } else {
    redis.initialize(function(err) {
      if (err != null) return console.log(err);
      return require(source + 'server');
    });
  }

}).call(this);
