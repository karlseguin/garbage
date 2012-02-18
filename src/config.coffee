module.exports =
  listen:
    host: '127.0.0.1'
    port: 4005
  cluster:
    numberOfCpus: 1
  redis:
    host: '127.0.0.1'
    port: 6379
    db: 0
  signature: {}