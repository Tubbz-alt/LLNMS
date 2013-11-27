
// Import our server from server.js
var server = require("./server");

// Import our router from router.js
var router = require("./router");

// Import our request handlers from requestHandlers.js
var requestHandlers = require("./requestHandlers");

//  Create the list of handlers
var handlers = {}
handlers["/"] = requestHandlers.start;
handlers["/networks"] = requestHandlers.networks;

// start our server
server.start(router.route, handlers );

