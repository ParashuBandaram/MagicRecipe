//
//  ViewController.m
//  Magic_Recipe
//
//  Created by Parshuram Bandaram on 06/01/16.
//  Copyright (c) 2016 Magic Recipe. All rights reserved.
//

#import "ViewController.h"
#import "ConnectionManager.h"
#import "MagicRecipe.h"
#import "DetailViewController.h"

@interface ViewController () {
    NSString *ingredients;
    NSInteger page;
    BOOL isPagingEnable;
}
@property (weak, nonatomic) IBOutlet UITableView *recipeTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *recipeSearchBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Magic Recipe";
    
    self.recipeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _recipeSearchBar.layer.borderWidth = 1;
    _recipeSearchBar.layer.borderColor = [_recipeSearchBar.backgroundColor CGColor];
    
    page = 0;
    isPagingEnable = YES;
    
    // magicRecipes initialization
    _magicRecipes = [NSMutableArray array];
    
    // get Magic Recipies from server
    [self getMagicRecipesServer];
    
    [self setupTableViewFooter];
    
}

- (void) getMagicRecipesServer {
    
    
    //http://www.recipepuppy.com/api/?i=onions,garlic&q=omelet&p=3
    
    ingredients = _recipeSearchBar.text;
    page += 1;
    
    NSString *indMessage = self.magicRecipes.count? @"" : @"Recipes Loading";
    
    NSString *magicRecipeisURL = [NSString stringWithFormat:@"%@i=%@&q=&p=%ld", appDomainURL, ingredients, (long)page];
    [ConnectionManager sendRequestWithURLString:magicRecipeisURL indicatorMessage:indMessage requestDictionary:nil completionHandler:^(NSDictionary *responseDictionary, NSError *error) {
        
        //NSLog(@"### MAGIC RECIPIES: %@", responseDictionary);
        
        NSArray *magicRecipesTemp = [responseDictionary valueForKey:@"results"];
        
        for (NSDictionary *recipe in magicRecipesTemp) {
        
            MagicRecipe *magicRecipeObj = [[MagicRecipe alloc] init];
            magicRecipeObj.title = recipe[@"title"];
            magicRecipeObj.ingredients = recipe[@"ingredients"];
            magicRecipeObj.webLink = recipe[@"href"];
            magicRecipeObj.imageUrl = recipe[@"thumbnail"];
            magicRecipeObj.image = nil;
            
            [_magicRecipes addObject:magicRecipeObj];
        }
        
        //NSLog(@"### MAGIC RECIPIES: %@", _magicRecipes);
        NSLog(@"### MAGIC RECIPIES count: %lu", (unsigned long)_magicRecipes.count);
        
        if (!magicRecipesTemp.count) {
            isPagingEnable = NO;
        }
        
        [self setupTableViewFooter];
        [_recipeTableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.magicRecipes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier = @"MagicRecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    //cell.textLabel.text = @"Test";

    MagicRecipe *magicRecipeObj = self.magicRecipes[indexPath.row];
    
    UILabel *recipeName = (UILabel *)[cell viewWithTag:1];
    recipeName.text = magicRecipeObj.title;
    
    UILabel *recipeDescription = (UILabel *)[cell viewWithTag:3];
    recipeDescription.text = magicRecipeObj.ingredients;
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:2];
    
    if (magicRecipeObj.image) {
        recipeImageView.image = magicRecipeObj.image;
    } else {
        recipeImageView.image = [UIImage imageNamed:@"History"];
        
        NSURL *imageURL = [NSURL URLWithString:magicRecipeObj.imageUrl];
        
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            UIImage *img = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                recipeImageView.image = img;
                magicRecipeObj.image = img;
            });
        });
    }
    
    return  cell;
}

- (void)setupTableViewFooter
{
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    // Header view for my main view
    tableFooterView.backgroundColor = [UIColor whiteColor];
    
    if (self.magicRecipes.count) {
        UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake((tableFooterView.frame.size.width / 2) - 15, tableFooterView.frame.size.height / 2, 30, 30)];
        progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [tableFooterView addSubview: progress];
        [progress startAnimating];
    } else {
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.textColor = [UIColor lightGrayColor];
        //statusLabel.text = @"No recipes found!";
        statusLabel.text = isPagingEnable? @"Recipes loading in process..." : @"No recipes found!";

        [tableFooterView addSubview:statusLabel];
    }
    
    UIEdgeInsets contentInset = _recipeTableView.contentInset;
    //        contentInset.bottom = 50.0f; // **the height of the footer**
    contentInset.bottom = tableFooterView.frame.size.height;; // **the height of the footer**
    _recipeTableView.contentInset = contentInset;
    _recipeTableView.tableFooterView = tableFooterView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height - 5)
    {
        if (isPagingEnable) {
            
            NSLog(@"scollview end level!!!");
            [self setupTableViewFooter];
            [self performSelector:@selector(getMagicRecipesServer)];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.recipeTableView.alpha = 1;
    [_recipeSearchBar resignFirstResponder];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecipeDetailViewController"];
    detailViewController.magicRecipeObj = self.magicRecipes[indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

# pragma mark - Searchbar delegates

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
   
    self.recipeTableView.alpha = 0.7;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //NSLog(@"Text change - %@",searchText);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
    [searchBar resignFirstResponder];
    self.recipeTableView.alpha = 1;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    
    [searchBar resignFirstResponder];
    
    if(searchBar.text.length) {
        //Remove all objects first.
        [self.magicRecipes removeAllObjects];
        
        page = 0;
        [self getMagicRecipesServer];
    }
    self.recipeTableView.alpha = 1;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        self.recipeTableView.alpha = 1;
        [_recipeSearchBar resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
