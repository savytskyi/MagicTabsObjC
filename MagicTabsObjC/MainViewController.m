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
