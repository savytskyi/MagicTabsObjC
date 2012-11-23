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
        CGFloat tabWidthSpacer = 6;
        CGFloat pointX = ([[self view] frame].size.width - tabWidth) / 2;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        NSLog(@"%f, %f, %f %f", tabWidth, tabWidthSpacer, pointX, screenHeight);
        
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
        //[magicView1 setCenter:CGPointMake([[self view] frame].size.width * 0.5f, [magicView1 center].y)];
        [magicView1 setZIndex:tabZ];
        [magicView1 setViewTitle:@"First"];
        [[self view] addSubview:magicView1];
        
        tabZ = 1;
        MagicView *magicView2 = [[MagicView alloc] initWithFrame:CGRectMake(pointX - (tabWidthSpacer * 0.5f) * tabZ, 250, tabWidth + tabWidthSpacer * tabZ, screenHeight)];
        [magicView2 setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
        //[magicView2 setCenter:CGPointMake([[self view] frame].size.width * 0.5f, [magicView2 center].y)];
        [magicView2 setZIndex:tabZ];
        [magicView2 setViewTitle:@"Second"];
        [[self view] addSubview:magicView2];
        
        tabZ = 2;
        MagicView *magicView3 = [[MagicView alloc] initWithFrame:CGRectMake(pointX - (tabWidthSpacer * 0.5f) * tabZ, 300, tabWidth + tabWidthSpacer * tabZ, screenHeight)];
        [magicView3 setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
        //[magicView3 setCenter:CGPointMake([[self view] frame].size.width * 0.5f, [magicView3 center].y)];
        [magicView3 setZIndex:tabZ];
        [magicView3 setViewTitle:@"Third"];
        [[self view] addSubview:magicView3];
        

        // adding coontent to magic views
        
        // first magic tab's content
        CGRect magicFrame = [magicView1 frame];
        magicFrame.origin.y -= 44;
        magicFrame.size.height -= 44;
        UIView *magicContent1 = [[UIView alloc] initWithFrame:magicFrame];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, [magicView1 frame].size.width, 20)];
        [label setText:@"Content View!"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label sizeToFit];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 25, 200, 25)];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        
        [magicContent1 addSubview:label];
        [magicContent1 addSubview:textField];
        // TODO: try to add content view twice. method in a magicView looks strange
        [magicView1 setContentView:magicContent1];
        
        //second magic tab's content
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(50, 100)];
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 50, [magicView2 frame].size.width - 5, 100) collectionViewLayout:layout];
        [collectionView setDataSource:self];
        [collectionView setDelegate:self];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionReuseID"];
        [magicView2 setContentView:collectionView];
        
        //third magic tab's content
        magicFrame = [magicView3 frame];
        magicFrame.origin.y -= 44;
        magicFrame.size.height -= 44;
        
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
    [[cell contentView] addSubview:label];
    
    [cell setBackgroundColor:[UIColor blueColor]];
    
    return cell;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 50);
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
