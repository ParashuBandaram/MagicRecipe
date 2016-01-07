//
//  ConnectionManager.h

//delegate to help parse JSON returned from server

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "AppDelegate.h"
#import "Utility.h"

@class AppDelegate, MBProgressHUD;

@interface ConnectionManager : NSObject {
    AppDelegate *appDelegate;
    MBProgressHUD *HUD;
    
    NSMutableData *responseData;
    NSInteger httpResponseCode;
}

+ (void)sendRequestWithURLString:(NSString *)strURL indicatorMessage:(NSString*)indMessage requestDictionary:(NSDictionary *)requestDictionary completionHandler:(void (^) (NSDictionary *responseDictionary, NSError *error))completionHandler;

+ (ConnectionManager *)sharedInstance;

@end
