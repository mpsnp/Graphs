//
//  GEdge.h
//  Graphs
//
//  Created by George on 08/01/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GVertex;

@interface GEdge : NSObject
@property (nonatomic) NSNumber *weight;
@property (nonatomic) NSNumber *flow;
@property (nonatomic) UIColor *color;
@property (nonatomic, weak) GVertex *v1;
@property (nonatomic, weak) GVertex *v2;
@property (nonatomic) id payload;

+ (instancetype)edgeWithVertex:(GVertex *)v1 andVertex:(GVertex *)v2;
- (void)addFlow:(NSNumber *)flow fromVertex:(GVertex *)vertex;
- (GVertex *)neighborVertex:(GVertex *)v;
- (double)flowDifferenceFromVertex:(GVertex *)vertex;
@end
