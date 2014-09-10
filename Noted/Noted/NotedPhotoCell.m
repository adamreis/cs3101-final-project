//
//  NotedPhotoCell.m
//  Noted
//
//  Created by Adam Reis on 5/7/14.
//  Copyright (c) 2014 Adam Reis. All rights reserved.
//

#import "NotedPhotoCell.h"

@implementation NotedPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.image = [[UIImageView alloc] init];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
