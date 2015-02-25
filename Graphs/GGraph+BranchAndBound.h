//
//  GGraph+BranchAndBound.h
//  Graphs
//
//  Created by George on 02/02/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GGraph.h"
#import "GVertexPayloaded.h"

@interface GTeta : NSObject
@property (nonatomic) NSUInteger i;
@property (nonatomic) NSUInteger j;
@property (nonatomic) double value;
+ (GTeta *)tetaWithI:(NSUInteger)i j:(NSUInteger)j andValue:(double)value;
@end

@interface GPayload : NSObject
@property (nonatomic) NSMutableArray *c;
@property (nonatomic) NSMutableArray *tetas;
@property (nonatomic) GTeta *bestTeta;
@property (nonatomic) double value;
@property (nonatomic) NSMutableArray *hi;
@property (nonatomic) NSMutableArray *hj;
@property (nonatomic) NSMutableArray *ignoredI;
@property (nonatomic) NSMutableArray *ignoredJ;

+ (GPayload *)payloadWithGraph:(GGraph *)graph;
+ (GPayload *)payloadWithPayload:(GPayload *)payload;
- (GVertexPayloaded *)makeVertexPayloaded;
- (BOOL)canBranch;
- (GPayload *)leftPayload;
- (GPayload *)rightPayload;
- (void)calculate;
- (double)sum;
@end

@interface GGraph (BranchAndBound)
- (GGraph *)branchAndBoud;
@end
