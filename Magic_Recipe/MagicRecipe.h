//
//  MagicRecipe.h
//  Magic_Recipe
//
//  Created by Parshuram Bandaram on 06/01/16.
//  Copyright (c) 2016 Magic Recipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MagicRecipe : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *ingredients;
@property (strong, nonatomic) NSString *webLink;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) UIImage *image;

@end
