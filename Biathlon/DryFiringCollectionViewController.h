//
//  DryFiringCollectionViewController.h
//  Biathlon
//
//  Created by Philip Henson on 6/15/14.
//  Copyright (c) 2014 Philip Henson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DryFiringCollectionViewCell.h"
#import "DryFiringDetailViewController.h"

@interface DryFiringCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *dryFiringImages;

@end
