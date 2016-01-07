//
//  Utility.m
/*
 * Frequentz LLC Confidential
 * OCO Source Materials
 * 5724-O98
 * (c) Copyright Frequentz LLC 2013
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 */

#import "Utility.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <sys/utsname.h>

@implementation Utility

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code.
   
    }
    
    return self;
}

+ (Utility *)sharedInstance {
    
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] init];
    });
    return sharedInstance;
}

+ (id) alloc {
    return [self sharedInstance];
}

+ (NSString *)getDeviceType {
    NSString *deviceModel = (NSString*)[UIDevice currentDevice].model;
    
    if ([deviceModel rangeOfString:@"iPhone"].location != NSNotFound)  {
        //NSLog(@"I am an iPhone");
        return @"iPhone";
    } else if ([deviceModel rangeOfString:@"iPad"].location != NSNotFound) {
        //NSLog(@"I am not an iPad");
        return @"iPad";
    }
    
    return @"Unknown device";
}

+ (NSString*)deviceName {
    
    static NSDictionary* deviceNamesByCode = nil;
    static NSString* deviceName = nil;
    
    if (deviceName) {
        return deviceName;
    }
    
    deviceNamesByCode = @{
                          @"i386"      :@"Simulator",
                          @"x86_64"    :@"Simulator",
                          @"iPod1,1"   :@"iPod Touch",      // (Original)
                          @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                          @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                          @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                          @"iPhone1,1" :@"iPhone",          // (Original)
                          @"iPhone1,2" :@"iPhone",          // (3G)
                          @"iPhone2,1" :@"iPhone",          // (3GS)
                          @"iPad1,1"   :@"iPad",            // (Original)
                          @"iPad2,1"   :@"iPad 2",          //
                          @"iPad3,1"   :@"iPad",            // (3rd Generation)
                          @"iPhone3,1" :@"iPhone 4",        //
                          @"iPhone4,1" :@"iPhone 4S",       //
                          @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                          @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                          @"iPad3,4"   :@"iPad",            // (4th Generation)
                          @"iPad2,5"   :@"iPad Mini",       // (Original)
                          @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                          @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                          @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                          @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                          @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                          @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                          @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
                          @"iPad4,5"   :@"iPad Mini",        // (2nd Generation iPad Mini - Cellular)
                          @"iPhone7,1" :@"iPhone 6 Plus",    // (iPhone 6 Plus)
                          @"iPhone7,2" :@"iPhone 6"         // (iPhone 6)
                          };
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found in database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        } else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        } else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        } else {
            deviceName = @"Simulator";
        }
    }
    
    return deviceName;
}

+ (CGFloat)calculateCellHeightForText:(NSString *)strCellText
                         withFontSize:(float)_fontSize maxSize:(CGSize)aSize {
	
	CGFloat lRetval = 0;
	CGRect frame;
	CGSize maximumLabelSize = CGSizeMake(aSize.width, MAXFLOAT);
    //CGSize maximumLabelSize = CGSizeMake(231, MAXFLOAT);
	CGSize expectedLabelSize;
	
    //_fontSize = 14.0f;
    
	NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
										  [UIFont fontWithName:@"HelveticaNeue" size:_fontSize], NSFontAttributeName,
										  nil];
	
	frame = [strCellText boundingRectWithSize:maximumLabelSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   attributes:attributesDictionary
                                      context:nil];
    
	expectedLabelSize = frame.size;
	lRetval = expectedLabelSize.height + 10;
    
    return lRetval;
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK",  nil];
    [alert show];
}


//-------------------- server unable to process alert -----------------------------//
+ (void) showAlertWithServerUnableToProcess:(UIViewController *)viewController {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Server unable to process your request" delegate:viewController cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    alert.tag = 111;
    [alert show];
}

//-------------------- check internet connection alert -----------------------------//
+ (void) showAlertWithCheckInternetConnection:(UIViewController *)viewController {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please check internet connection" delegate:viewController cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    alert.tag = 111;
    [alert show];
}

@end
