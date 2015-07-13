//
//  BLEDeviceTableViewCell.m
//  Biathlon
//
//  Created by Philip Henson on 7/27/14.
//  Copyright (c) 2014 Philip Henson. All rights reserved.
//

#import "BLEDeviceTableViewCell.h"

@implementation BLEDeviceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
