// NWURLConnection - an NSURLConnectionDelegate based on blocks with cancel.
// Similar to the `sendAsynchronousRequest:` method of NSURLConnection, but
// with `cancel` method. Requires ARC on iOS 6 or Mac OS X 10.8.
// License: BSD
// Author:  Leonard van Driel, 2012

// Modified by Julian Weiss for AlienBlueVelox:
// Does not require ARC, tweaked for readability, etc.

@interface NWURLConnection : NSObject <NSURLConnectionDelegate>{
    NSURLConnection *connection;
    NSHTTPURLResponse *response;
    NSMutableData *responseData;
}

@property (retain) NSURLRequest *request;
@property (retain) NSOperationQueue *queue;
@property (copy) void(^completionHandler)(NSURLResponse *response, NSData *data, NSError *error);

+(NWURLConnection *)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void(^)(NSURLResponse *response, NSData *data, NSError *error))completionHandler;
-(void)start;
-(void)cancel;

@end