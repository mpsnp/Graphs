//
//  GGraphView.h
//  Graphs
//
//  Created by George on 08/01/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGraph;
@class GEdge;
@class GVertex;

typedef enum : NSUInteger {
    GGraphSelectionVertex,
    GGraphSelectionEdge
} GGraphSelectionType;

@interface GGraphView : UIControl
@property (nonatomic, weak) GGraph *graph;
@property (nonatomic) IBInspectable double pointSize;
@property (nonatomic) IBInspectable double lineWidth;
@property (nonatomic) IBInspectable double arrowLength;
@property (nonatomic, strong) IBInspectable UIColor *lineColor;
@property (nonatomic, strong) IBInspectable UIColor *fillColor;
@property (nonatomic) GEdge *selectedEdge;
@property (nonatomic) GVertex *selectedVertex;

@property (nonatomic) GGraphSelectionType selectionType;

- (CGRect)rectForEdge:(GEdge *)edge;
@end
