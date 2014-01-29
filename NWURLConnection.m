#import "NWURLConnection.h"

@implementation NWURLConnection

@synthesize request, queue, completionHandler;

+(NWURLConnection *)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void(^)(NSURLResponse *response, NSData *data, NSError *error))completionHandler{

    NWURLConnection *result = [[NWURLConnection alloc] init];
    result.request = request;
    result.queue = queue;
    result.completionHandler = completionHandler;
    [result start];

    return result;
}

-(void)start{

    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection scheduleInRunLoop:NSRunLoop.mainRunLoop forMode:NSDefaultRunLoopMode];

    if (connection)
        [connection start];

    else{
        if (completionHandler){
            completionHandler(nil, nil, nil); 
            completionHandler = nil;
        }//end if
    }//end else

}//end start

-(void)cancel{

    [connection cancel]; 
    connection = nil;
    completionHandler = nil;

}//end cancel

-(void)connection:(NSURLConnection *)_connection didReceiveResponse:(NSHTTPURLResponse *)_response{

    response = [_response retain];

}//end didReceiveResponse

-(void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)data{

    if (!responseData)
        responseData = [[NSMutableData dataWithData:data] retain];

    else
        [responseData appendData:data];

}//end didReceiveData

-(void)connectionDidFinishLoading:(NSURLConnection *)_connection{

    connection = nil;
     
    if (completionHandler) {
        void(^b)(NSURLResponse *response, NSData *data, NSError *error) = completionHandler;
        completionHandler = nil;

        [queue addOperationWithBlock:^{b(response, responseData, nil);}];
    }//end if

}//end connectionDidFinishLoading

-(void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error{

    connection = nil;

    if (completionHandler) {
        void(^b)(NSURLResponse *response, NSData *data, NSError *error) = completionHandler;
        completionHandler = nil;

        [queue addOperationWithBlock:^{b(response, responseData, error);}];
    }//end if

}//end didFailWithError


-(void)dealloc{
    [self cancel];

    [connection release];
    [response release];
    [responseData release];

    [super dealloc];

}//end dealloc

@end