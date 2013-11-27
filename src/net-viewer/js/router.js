
/// Create the basic router function
function route( handlers, pathname, response, postData ){
    console.log("About to route a request for " + pathname);
    
    if (typeof handlers[pathname] === 'function'){
        handlers[pathname](response, postData);
    } else{
        console.log("No request handler found for " + pathname );
        response.writeHead(404,{"Content-Type":"text/plain"});
        response.write("404 Not found");
        response.end();
    }

}

// Export the route function
exports.route = route;

