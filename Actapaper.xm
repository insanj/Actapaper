#import <libactivator/libactivator.h>
#import <UIKit/UIKit.h>
#import "Actasender.h"

@interface SpringBoard : UIApplication
-(void)applicationOpenURL:(id)arg1 publicURLsOnly:(BOOL)arg2;
@end

@interface Actapaper : NSObject <LAListener, UIAlertViewDelegate> {
@private
	UIAlertView *responseView;
	Actasender *sender;
}
@end

@implementation Actapaper

-(BOOL)dismiss{
	if (responseView) {
		[responseView dismissWithClickedButtonIndex:[responseView cancelButtonIndex] animated:YES];
		[responseView release];
		responseView = nil;
		return YES;
	}//end if

	return NO;
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{

	if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Okay"])
		[(SpringBoard *)[UIApplication sharedApplication] applicationOpenURL:[NSURL URLWithString:@"prefs:root=Actapaper"] publicURLsOnly:NO];

	[responseView release];
	responseView = nil;

	if(sender){
		[sender release];
		sender = nil;
	}//end if
}

-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event{

	if (![self dismiss]){
		if([Actasender hasSavedCredentials]){
			sender = [[Actasender alloc] initWithURL:[NSURL URLWithString:[UIPasteboard generalPasteboard].string]];
			[sender sendToAPI];
		}//end if

		else{
			responseView = [[UIAlertView alloc] initWithTitle:@"Actasender" message:@"Couldn't find saved credentials! Tap to change your Settings." delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Okay", nil];
			[responseView show];
		}//end else

		[event setHandled:YES];
	}//end if
}

-(void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event{
	[self dismiss];
}

-(void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event{
	[self dismiss];
}

-(void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event{
	if ([self dismiss])
		[event setHandled:YES];
}

-(void)dealloc{
	[responseView release];
	[sender release];
	[super dealloc];
}

+(void)load{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[LAActivator sharedInstance] registerListener:[self new] forName:@"libactivator.actapaper"];
	[pool release];
}

@end 