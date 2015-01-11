//
//  GOrientedGraph.h
//  Graphs
//
//  Created by George on 09/01/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GGraph.h"

@interface GOrientedGraph : GGraph

- (GOrientedGraph *)minimalPathTreeStartingFromVertex:(GVertex *)start;
- (NSArray *)floyd;

+ (GOrientedGraph *)orientedGraphWithGraph:(GGraph *)graph;

@end
