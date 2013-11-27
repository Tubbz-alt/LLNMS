
// Import the nodejs http module
var http = require("http");

// Import the nodejs url module
var url = require("url");

/**
 * Create our start function
*/
function start( route, handlers ){

    // a basic on-request function when we start
    function onRequest( request, response ){
       
        // create our post data object
        var postData = "";
        
        // Get the pathname from the request
        var pathname = url.parse(request.url).pathname;
        console.log("Request for " + pathname + " recieved.");
        
        // set the character encoding
        request.setEncoding("utf8");

        // create the listener
        request.addListener("data", function(postDataChunk){
            postData += postDataChunk;
            console.log("Received POST data chunk '"+
                        postDataChunk + "'.");
        }); 

        // add the listener
        request.addListener("end", function(){
            route(handlers,pathname,response,postData);
        });


    } // end of onRequest Function
    
    // create our server
    http.createServer(onRequest).listen(8888);
    console.log("Server has started.");

} /// end of start function

exports.start = start;

