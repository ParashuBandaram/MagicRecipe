//
//  DetailViewController.m
//  Magic_Recipe
//
//  Created by Parshuram Bandaram on 07/01/16.
//  Copyright (c) 2016 Magic Recipe. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Recipe Details";
    
    [self recipeDetailLoad];
}

- (void) recipeDetailLoad {
    UILabel *recipeName = (UILabel *)[self.view viewWithTag:1];
    recipeName.text = _magicRecipeObj.title;
    
    UILabel *recipeDescription = (UILabel *)[self.view viewWithTag:3];
    recipeDescription.text = _magicRecipeObj.ingredients;
    
    UIImageView *recipeImageView = (UIImageView *)[self.view viewWithTag:2];
    
    if (_magicRecipeObj.image) {
        recipeImageView.image = _magicRecipeObj.image;
    } else {
        recipeImageView.image = [UIImage imageNamed:@"History"];
        
        NSURL *imageURL = [NSURL URLWithString:_magicRecipeObj.imageUrl];
        
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            UIImage *img = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                recipeImageView.image = img;
                _magicRecipeObj.image = img;
            });
        });
    }
    
    UIWebView *recipeWebView = (UIWebView *)[self.view viewWithTag:4];
    NSURL *url = [NSURL URLWithString:_magicRecipeObj.webLink];
    [recipeWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
