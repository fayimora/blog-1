require('node_hooks/node_modules/coffee-script');
app = module.exports = require('./app');
app.listen(3000, function(){
  console.log('http://dev:3000');
});