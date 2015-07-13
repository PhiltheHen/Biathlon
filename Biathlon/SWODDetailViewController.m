//
//  SWODDetailViewController.m
//  Biathlon
//
//  Created by Philip Henson on 6/15/14.
//  Copyright (c) 2014 Philip Henson. All rights reserved.
//

#import "SWODDetailViewController.h"

@interface SWODDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *detailName;
@property (strong, nonatomic) IBOutlet UILabel *detailDescription;

@end

@implementation SWODDetailViewController

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
    
    self.detailName.text = self.workout.name;
    self.detailDescription.text = self.workout.description;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
