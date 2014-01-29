#import <Twitter/Twitter.h>
#import <Preferences/PSSpecifier.h>
#import <objc/runtime.h>

@interface PSViewController : UIViewController
-(id)initForContentSize:(CGSize)contentSize;
-(void)setPreferenceValue:(id)value specifier:(id)specifier;
@end

@interface PSListController : PSViewController{
	NSArray *_specifiers;
}

-(void)loadView;
-(void)reloadSpecifier:(PSSpecifier*)specifier animated:(BOOL)animated;
-(void)reloadSpecifier:(PSSpecifier*)specifier;
- (NSArray *)loadSpecifiersFromPlistName:(NSString *)name target:(id)target;
-(PSSpecifier*)specifierForID:(NSString*)specifierID;
@end

@interface PSTableCell : UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier;
@end

@interface ActaPreferencesListController: PSListController
-(void)shareTapped:(UIBarButtonItem *)sender;
@end

@implementation ActaPreferencesListController

-(void)loadView{
	UIBarButtonItem *heart = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/ActaPreferences.bundle/heart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareTapped:)];
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), NO, 0.0);
	UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[heart setBackgroundImage:blank forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	self.navigationItem.rightBarButtonItem = heart;

	[super loadView];
}

-(void)shareTapped:(UIBarButtonItem *)sender {
	NSString *text = @"Instapaper has never been more useful than with Actapaper by @insanj!";
	NSString *urlString = @"http://repo.insanj.com/";
	NSURL *url = [NSURL URLWithString:urlString];

	if (%c(TWTweetComposeViewController) && [TWTweetComposeViewController canSendTweet]) {
		TWTweetComposeViewController *viewController = [[[TWTweetComposeViewController alloc] init] autorelease];
		viewController.initialText = text;
		[viewController addURL:url];
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	}

	else if (%c(UIActivityViewController)) {
		UIActivityViewController *viewController = [[[%c(UIActivityViewController) alloc] initWithActivityItems:[NSArray arrayWithObjects:text, url, nil] applicationActivities:nil] autorelease];
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	}

	else {
		text = [text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@%@", text, urlString]]];
	}
}//end sharetapped

-(id)specifiers {
	if(!_specifiers)
		_specifiers = [[self loadSpecifiersFromPlistName:@"ActaPreferences" target:self] retain];

	return _specifiers;
}//end specifiers

-(void)resignKeyboard{
	[self.view endEditing:YES];
}

-(void)twitter{
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:@"insanj"]]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:@"insanj"]]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:@"insanj"]]];

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:@"insanj"]]];

	else 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:@"insanj"]]];
}//end twitter

-(void)mail{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:me%40insanj.com?subject=Actasender%20(1.0)%20Support"]];
}

-(void)donate{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=insanj%40gmail%2ecom&lc=US&item_name=insanj&item_number=buy%20insanj%20a%20cup%20of%20coffee&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted"]];	
}
@end