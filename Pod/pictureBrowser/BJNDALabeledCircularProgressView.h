//
//  BJNDALabeledCircularProgressView.h
//  DACircularProgressExample
//
//  Created by Josh Sklar on 4/8/14.
//  Copyright (c) 2014 Shout Messenger. All rights reserved.
//

#import "BJNDACircularProgressView.h"

/**
 @class BJNDALabeledCircularProgressView
 
 @brief Subclass of BJNDACircularProgressView that adds a UILabel.
 */
@interface BJNDALabeledCircularProgressView : BJNDACircularProgressView

/**
 UILabel placed right on the BJNDACircularProgressView.
 */
@property (strong, nonatomic) UILabel *progressLabel;

@end
