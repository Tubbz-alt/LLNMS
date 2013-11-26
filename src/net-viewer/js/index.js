
// Import the HTTP Module for NodeJS
var http = require("http");

/// On request function
function onRequest(request, response){
    console.log("Request Recieved.");
    response.writeHead(200,{"Content-Type":"text/plain"});
    response.write("Hello World");
    response.end();
}

//  Create the server
http.createServer(onRequest).listen(8888);

console.log("Server has started.");

