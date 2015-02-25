//
//  GGraph.h
//  Graphs
//
//  Created by George on 08/01/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVertex.h"
#import "GEdge.h"

@interface GGraph : NSObject
@property (nonatomic, strong) NSMutableArray *vertexes;
@property (nonatomic, strong) NSMutableArray *edges;
@property (nonatomic, strong) id info;

- (void)addVertex:(GVertex *)vertex;
- (void)addEdge:(GEdge *)edge;
- (GGraph *)spanningTreeMinimal:(BOOL)minimal;
- (NSArray *)findLeafs;
- (void)layoutTree;

+ (GGraph *)graphWithData:(NSData *)data;
@end
