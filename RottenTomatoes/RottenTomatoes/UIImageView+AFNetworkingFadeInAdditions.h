//
//  UIImageView+AFNetworkingFadeInAdditions.h
//  RottenTomatoes
//
//  Created by Aditya Jayaraman on 2/7/15.
//  Copyright (c) 2015 Aditya Jayaraman. All rights reserved.
//

#ifndef RottenTomatoes_UIImageView_AFNetworkingFadeInAdditions_h
#define RottenTomatoes_UIImageView_AFNetworkingFadeInAdditions_h


#import <AFNetworking.h>

@interface UIImageView (AFNetworkingFadeInAdditions)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage fadeInWithDuration:(CGFloat)duration;

@end

#endif
