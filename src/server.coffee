connect = require('connect')
config = require('./config')
middleware = require('./middleware/index')

require('./controllers/extensions')

server = connect()
server.use connect.bodyParser()
server.use connect.query()
server.use middleware.context()
server.use middleware.signature(config.signature)
server.use connect.router require('./controllers/scores')
server.listen(config.listen.port, config.listen.host)
console.log("listening on http://%s:%d", config.listen.host, config.listen.port)