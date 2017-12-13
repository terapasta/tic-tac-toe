const AllServer = require('./servers/all')
const ChatworkServer = require('./servers/chatwork')
const LineServer = require('./servers/line')
const MicrosoftServer = require('./servers/microsoft')

const chatworkServer = new ChatworkServer()
const lineServer = new LineServer()
const microsoftServer = new MicrosoftServer()
new AllServer({ lineServer, chatworkServer, microsoftServer }).run()