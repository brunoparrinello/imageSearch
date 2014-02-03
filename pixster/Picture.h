//
//  Picture.h
//  pixster
//
//  Created by Bruno Parrinello on 2/2/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Picture : NSObject

@property (nonatomic, strong) NSURL *pictureURL;
@property (nonatomic, strong) NSString *pictureTitle;

@end
