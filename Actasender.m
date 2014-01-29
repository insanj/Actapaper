#import "Actasender.h"

@implementation Actasender

-(Actasender *)initWithURL:(NSURL *)url{
	if((self = [super init]))
		sendURL = [url copy];

	return self;
}


+(BOOL)hasSavedCredentials{
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/libactivator.actapaper.plist"]];
	return ([settings objectForKey:@"username"] && [settings objectForKey:@"password"] && ![[settings objectForKey:@"username"] isEmpty] && ![[settings objectForKey:@"password"] isEmpty]);
}

-(void)sendToAPI{
	saveView = [[UIAlertView alloc] initWithTitle:@"Actapaper" message:@"Saving...\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
	[saveView show];

	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/libactivator.actapaper.plist"]];
	NSMutableURLRequest *saveRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.instapaper.com/api/add"]];
	[saveRequest setHTTPMethod:@"POST"];

	NSString *saveRequestString = [NSString stringWithFormat:@"username=%@&password=%@&url=%@&selection=%@", [settings objectForKey:@"username"], [settings objectForKey:@"password"], sendURL, @"Saved with Actapaper by @insanj."];
	[saveRequest setHTTPBody:[saveRequestString dataUsingEncoding:NSUTF8StringEncoding]];
	NSOperationQueue *saveQueue = [[NSOperationQueue alloc] init]; //asdlfiuahsdlkf

	connection = [[[NWURLConnection alloc] init] retain];
	connection.request = saveRequest;
	connection.queue = saveQueue;
	connection.completionHandler = ^(NSURLResponse *response, NSData *data, NSError *error){
		if ([data length] > 0 && error == nil)
			[self performSelectorOnMainThread:@selector(processResponseData:) withObject:data waitUntilDone:NO];

		else if ([data length] == 0 && error == nil)
			[self performSelectorOnMainThread:@selector(processResponseData:) withObject:[@"Received empty reply." dataUsingEncoding:NSUTF8StringEncoding] waitUntilDone:NO];

		else if (error != nil && error.code == NSURLErrorTimedOut)
			[self performSelectorOnMainThread:@selector(processResponseData:) withObject:[@"Timed out." dataUsingEncoding:NSUTF8StringEncoding] waitUntilDone:NO];

		else if (error != nil)
			[self performSelectorOnMainThread:@selector(processResponseData:) withObject:[@"Download error." dataUsingEncoding:NSUTF8StringEncoding] waitUntilDone:NO];

		else
			[self performSelectorOnMainThread:@selector(processResponseData:) withObject:[@"You broke something!" dataUsingEncoding:NSUTF8StringEncoding] waitUntilDone:NO];
	};

	[connection start];
}

-(void)processResponseData:(NSData *)data {
	connection = nil;

	NSDictionary *codes = [NSDictionary dictionaryWithObjectsAndKeys:@"This URL has been successfully added to this Instapaper account.", @"201", @"Bad request or exceeded the rate limit. (This is probably because you didn't copy a valid URL!)", @"400", @"Invalid username or password.", @"403", @"The service encountered an error. Please try again later.",  @"500", nil];

	[saveView dismissWithClickedButtonIndex:[saveView cancelButtonIndex] animated:YES];
	NSString *saveResponseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	if(![saveResponseString isEqualToString:@"201"])
  	 	saveView = [[UIAlertView alloc] initWithTitle:@"Actapaper" message:[NSString stringWithFormat:@"Encountered a problem trying to save your pasteboard to Instapaper:\n%@", [codes objectForKey:saveResponseString]] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];

  	else
		saveView = [[UIAlertView alloc] initWithTitle:@"Actapaper" message:@"Saved your link to Instapaper successfully!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];

	[saveView show];
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(connection)
		[connection cancel];

	[saveView release];
	saveView = nil;
}

-(void)dealloc{
	[saveView release];
	[connection release];
	[sendURL release];
	[super dealloc];
}
@end

@implementation NSString (Actapaper)
- (BOOL)isEmpty {
   if([self length] == 0)
       return YES;

   if(![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
       return YES;

   return NO;
}

- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options {
   NSRange rng = [self rangeOfString:string options:options];
   return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
   return [self containsString:string options:0];
}
@end