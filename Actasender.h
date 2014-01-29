#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#include <stdlib.h>
#import "NWURLConnection.h"
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface Actasender : NSObject <UIAlertViewDelegate>{
	NWURLConnection *connection;
	UIAlertView *saveView;
	NSURL *sendURL;
}

-(Actasender *)initWithURL:(NSURL *)url;
+(BOOL)hasSavedCredentials;
-(void)sendToAPI;
-(void)processResponseData:(NSData *)data;
@end


@interface NSString (Actasender)
-(BOOL)isEmpty;
- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options;
@end