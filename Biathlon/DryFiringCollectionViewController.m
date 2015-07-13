//
//  DryFiringCollectionViewController.m
//  Biathlon
//
//  Created by Philip Henson on 6/15/14.
//  Copyright (c) 2014 Philip Henson. All rights reserved.
//

#import "DryFiringCollectionViewController.h"

@interface DryFiringCollectionViewController ()

@end

@implementation DryFiringCollectionViewController

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
    
    _dryFiringImages = [@[@"holdingSpiral.png",
                        @"noRhythm.png",
                        @"precision.png",
                          @"StandardMix.png",
                          @"StandingLowerEntry.png"] mutableCopy];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return _dryFiringImages.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DryFiringCollectionViewCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"targetCell"
                                    forIndexPath:indexPath];
    
    UIImage *image;
    
    image = [UIImage imageNamed:_dryFiringImages[indexPath.row]];
    
    myCell.imageView.image = image;
    
    return myCell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        DryFiringDetailViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        destViewController.detailImageName = _dryFiringImages[indexPath.row];
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}


@end
