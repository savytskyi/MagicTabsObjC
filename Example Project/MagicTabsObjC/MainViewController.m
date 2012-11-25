//
//  MainViewController.m
//  MagicTabsObjC
//
//  Created by Cyril Savitsky on 11/22/12.
//  Copyright (c) 2012 Synobi. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //first tab width (smallest tab
        CGFloat tabWidth = [[self view] frame].size.width * 0.9f;
        
        //difference between each tab width
        CGFloat tabWidthSpacer = 7;
        CGFloat pointX = ([[self view] frame].size.width - tabWidth) / 2;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        // adding logo label
        UILabel *magicViewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, [[self view] frame].size.width, 30)];
        [magicViewsLabel setTextAlignment:NSTextAlignmentCenter];
        [magicViewsLabel setText:@"Magic Tabs"];
        [magicViewsLabel setFont:[UIFont fontWithName:@"Helvetica" size:24]];
        [magicViewsLabel setBackgroundColor:[UIColor clearColor]];
        [magicViewsLabel setTextColor:[UIColor whiteColor]];
        [[self view] addSubview:magicViewsLabel];
        
        [[self view] setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
        
        int tabZ = 0;
        MagicView *magicView1 = [[MagicView alloc] initWithFrame:CGRectMake(pointX - (tabWidthSpacer * 0.5f) * tabZ, 200, tabWidth + tabWidthSpacer * tabZ, screenHeight)];
        [magicView1 setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
        [magicView1 setZIndex:tabZ];
        [magicView1 setViewTitle:@"First"];
        [[self view] addSubview:magicView1];
        
        tabZ = 1;
        MagicView *magicView2 = [[MagicView alloc] initWithFrame:CGRectMake(pointX - (tabWidthSpacer * 0.5f) * tabZ, 250, tabWidth + tabWidthSpacer * tabZ, screenHeight)];
        [magicView2 setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
        [magicView2 setZIndex:tabZ];
        [magicView2 setViewTitle:@"Second"];
        [[self view] addSubview:magicView2];
        
        tabZ = 2;
        MagicView *magicView3 = [[MagicView alloc] initWithFrame:CGRectMake(pointX - (tabWidthSpacer * 0.5f) * tabZ, 300, tabWidth + tabWidthSpacer * tabZ, screenHeight)];
        [magicView3 setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
        [magicView3 setZIndex:tabZ];
        [magicView3 setViewTitle:@"Third"];
        [[self view] addSubview:magicView3];
        

        // adding coontent to magic views
        
        // first magic tab's content
        CGRect magicFrame = CGRectMake(0, 0, [magicView1 frame].size.width, [magicView1 frame].size.height);
        UIView *magicContent1 = [[UIView alloc] initWithFrame:magicFrame];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, [magicView1 frame].size.width, 20)];
        [label setText:@"Content View!"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label sizeToFit];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 25, 200, 25)];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        
        [magicContent1 addSubview:label];
        [magicContent1 addSubview:textField];
        [magicView1 setContentView:magicContent1];
        
        //second magic tab's content
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(50, 100)];
        
        magicFrame = CGRectMake(5, 5, [magicView2 frame].size.width - 10, [magicView2 frame].size.height);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:magicFrame collectionViewLayout:layout];
        [collectionView setDataSource:self];
        [collectionView setDelegate:self];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionReuseID"];
        [magicView2 setContentView:collectionView];
        
        //third magic tab's content
        
        magicFrame = CGRectMake(0, 0, [magicView3 frame].size.width, [magicView3 frame].size.height);
        UITableView *tableView = [[UITableView alloc] initWithFrame:magicFrame];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellReuseID"];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [magicView3 setContentView:tableView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *data = [NSArray arrayWithObjects:@"first", @"second", @"third", @"fourth", @"fifth", nil];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionReuseID" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setText:[data objectAtIndex:[indexPath row]]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label sizeToFit];
    [label setCenter:CGPointMake([cell frame].size.width * 0.5f, [cell frame].size.height * 0.5f)];
    [[cell contentView] addSubview:label];
    
    [cell setBackgroundColor:[UIColor underPageBackgroundColor]];
    
    return cell;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70, 50);
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *data = [NSArray arrayWithObjects:@"first", @"second", @"third", @"fourth", @"fifth", nil];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellReuseID" forIndexPath:indexPath];
    [[cell textLabel] setText:[data objectAtIndex:[indexPath row]]];
    return cell;
}

@end
