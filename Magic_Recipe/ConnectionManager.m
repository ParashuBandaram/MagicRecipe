//
//  ConnectionManager.m


#import "ConnectionManager.h"
#import "MBProgressHUD.h"
#import "Constants.h"

static ConnectionManager *sharedInstance = nil;

@implementation ConnectionManager

+ (ConnectionManager *)sharedInstance {
    if(sharedInstance == nil)
        sharedInstance = [[super alloc] init];

    return sharedInstance;
}

+ (id) alloc {
   
    return [self sharedInstance];
}

+ (void)sendRequestWithURLString:(NSString *)strURL indicatorMessage:(NSString*)indMessage requestDictionary:(NSDictionary *)requestDictionary completionHandler:(void (^) (NSDictionary *responseDictionary, NSError *error))completionHandler {

    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if([AppDelegate isServerReachable]) {
        
        // Configuring activity indicator (MBProgressHUD) code
        
        MBProgressHUD *HUD;
        
        if (indMessage.length) {
            HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
            HUD.dimBackground = YES;
            HUD.labelText = indMessage;
        }
        
        NSError *error = nil;
        __block NSDictionary *responseDictionary = nil;
        
        //create a JSON string to send to the server in the request
        if(requestDictionary == nil)
            requestDictionary = @{};
        
        
        NSLog(@"req url: %@", strURL);
        
        NSData *requestJSON = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        //NSLog(@"####### req string: %@", [[NSString alloc] initWithData:requestJSON encoding:NSUTF8StringEncoding]);
        
        //build request
        // use the following method to set timeout interval for POST explicitly.
        //default minimum timeout for POST is 240 seconds
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:strURL]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:requestJSON];
        
        //send request
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSLog(@"responseCode: %ld", (long)[(NSHTTPURLResponse *)response statusCode]);
            
            if([(NSHTTPURLResponse *)response statusCode] == 200) {

                if(!connectionError && data) {
                    
                    responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
                    
                    //NSLog(@">>> responseDictionary: %@", responseDictionary);
                    
                    if(!error && responseDictionary) {
                        
                        completionHandler(responseDictionary, connectionError);
                    } else {
                        [Utility showAlertWithServerUnableToProcess: nil];
                    }
                } else {
                    
                    //completionHandler(responseDictionary, connectionError);
                    //response code wrong(bad request)
                    
                    NSString *strMessage = [NSString stringWithFormat:@"HTTP Error : %ld\n%@", (long)[(NSHTTPURLResponse *)response statusCode],[connectionError localizedDescription]];
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ERROR_TITLE"
                                                                   message:strMessage
                                                                  delegate:self
                                                         cancelButtonTitle:nil
                                                         otherButtonTitles:@"BTN_TITLE_OK", nil];
                    
                    [alert performSelectorOnMainThread:@selector(show) withObject:alert waitUntilDone:YES];
                }
            } else {

                NSLog(@"server msg: %@", [responseDictionary objectForKey:@"message"]);
                [Utility showAlertWithServerUnableToProcess: nil];
            }
            
            [HUD hide:YES];
        }];
    } else {
        [Utility showAlertWithCheckInternetConnection: nil];
    }
}

- (void)dealloc {
}

@end
