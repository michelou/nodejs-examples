const config = require('../config.json');
const uri = config.use_local ? config.local_db.uri : config.remote_db.user+':'+config.remote_db.password+'@'+config.remote_db.uri;

module.exports = {
  uri: `mongodb://${uri}`,
  is_local: config.use_local
} 
