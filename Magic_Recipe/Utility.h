//
//  Utility.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol UtilityDelegate;

@class AppDelegate, MBProgressHUD;

@interface Utility : NSObject <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) id<UtilityDelegate>  _delegate;
@property (nonatomic, strong) UIViewController *viewController;

+ (Utility *)sharedInstance;

+ (CGFloat)calculateCellHeightForText:(NSString *)strCellText
                         withFontSize:(float)_fontSize maxSize:(CGSize)aSize;

//-------------------- server unable to process -----------------------------//
+ (void)showAlertWithServerUnableToProcess:(UIViewController *)viewController;

//-------------------- check internet connection alert -----------------------------//
+ (void)showAlertWithCheckInternetConnection:(UIViewController *)viewController;


@end

//////////////////// protocol method define ///////////////////////////////////////////
@protocol UtilityDelegate
- (void)sendResponse:(NSDictionary *)_responseJSONDict;

@end
