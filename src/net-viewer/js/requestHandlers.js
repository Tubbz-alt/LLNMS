
// Import the querystring module
var querystring = require("querystring");

// Import the filesystem module
var fs = require('fs');

//  Start request handler
function start( response, postData ){

    console.log("Request handler 'start' was called.");
    
    // create the content of our body
    var body="";

    // make sure the main file of our body exists
    fs.readFile('../html/main.html', function read(err,data){
        if(err){
            throw err;
        }
        body = data;

        // process file
        response.writeHead(200,{"Content-Type":"text/html"});
        response.write(body);
        response.end();
    });

}

//  Upload request handler
function networks( response, postData ){

    console.log("Request handler 'networks' was called.");

    // create the content of our body
    var body=""

    // make sure the main file of our body exists
    fs.readFile('../html/networks.html', function read(err,data){
        if(err){
            throw err;
        }
        body = data;

        // process file
        response.writeHead(200,{"Content-Type":"text/html"});
        response.write(body);
        response.end();
    });

}

// export our request handlers
exports.start    = start
exports.networks = networks

