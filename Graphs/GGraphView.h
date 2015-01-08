//
//  GGraphView.h
//  Graphs
//
//  Created by George on 08/01/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGraph;

@interface GGraphView : UIControl
@property (nonatomic, weak) GGraph *graph;
@property (nonatomic) IBInspectable double pointSize;
@property (nonatomic) IBInspectable double lineWidth;
@property (nonatomic, strong) IBInspectable UIColor *lineColor;
@property (nonatomic, strong) IBInspectable UIColor *fillColor;
@end
