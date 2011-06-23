/*
 *  CGPointUtils.h
 *  QuestApp
 *
 *  Created by Siddharth Gami on 4/19/11.
 *  Copyright 2011 USC. All rights reserved.
 *
 */

#import <CoreGraphics/CoreGraphics.h>

CGFloat distanceBetweenPoints (CGPoint first, CGPoint second);
CGFloat angleBetweenPoints(CGPoint first, CGPoint second);
CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint lin2End);