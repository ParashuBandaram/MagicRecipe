//
//  Constants.h


//---------------------- Test Server ----------------------------//
#define appDomainURL @"http://www.recipepuppy.com/api/?"

// web services


// Device detection macros
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)


//----------- App delegate --------------//
//#define AppDelegate *appDelegate (AppDelegate*)[[UIApplication sharedApplication] delegate];


#define kSEND_BACK_ALERT 111
