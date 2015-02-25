//
//  GGraph+_Machines.h
//  Graphs
//
//  Created by George on 04/02/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GGraph.h"

@interface G3MachinesVertex : GVertex
@property (nonatomic) NSNumber *A;
@property (nonatomic) NSNumber *B;
@property (nonatomic) NSNumber *C;
@property (nonatomic) NSNumber *dA;
@property (nonatomic) NSNumber *dB;
@property (nonatomic) NSNumber *dC;
@property (nonatomic) NSNumber *delta;
@property (nonatomic) NSNumber *index;
@property (nonatomic) NSMutableSet *freeIndexes;
@property (nonatomic) G3MachinesVertex *parent;
+ (G3MachinesVertex *)vertexWith:(NSNumber *)a b:(NSNumber *)b c:(NSNumber *)c;
- (void)findDeltaWith:(NSArray *)a b:(NSArray *)b c:(NSArray *)c;
@end

@interface GGraph (_Machines)
+ (GGraph *)buildGraphWithA:(NSArray *)a b:(NSArray *)b c:(NSArray *)c;
- (G3MachinesVertex *)findBest3Leaf;
@end
