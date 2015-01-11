//
//  GFloydViewController.m
//  Graphs
//
//  Created by George on 09/01/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GFloydViewController.h"
#import "GOrientedGraph.h"
#import <GMGridView/GMGridView.h>

@interface GFloydViewController () <GMGridViewDataSource>
@property (nonatomic, strong) GMGridView *view;
@property (nonatomic) GOrientedGraph *graph;
@property (nonatomic) NSArray *matrix;
@end

@implementation GFloydViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"8.7" ofType:@"json"]];
    self.graph = [GOrientedGraph orientedGraphWithGraph:[GOrientedGraph graphWithData:data]];
    
    self.matrix = [self.graph floyd];
    [self.view reloadData];
    [self.view setItemSpacing:0];
    [self.view setMinEdgeInsets:UIEdgeInsetsZero];
}

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [self.matrix count] * [self.matrix count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(gridView.bounds.size.width / [self.matrix count], (gridView.bounds.size.height - 64) / [self.matrix count]);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    if (!cell)
        cell = [[GMGridViewCell alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.frame];
    label.text = [self.matrix[index % [self.matrix count]][index / [self.matrix count]] stringValue];
    if ([label.text isEqualToString:@"100000"])
        label.text = @"";
    cell.contentView = label;
    return cell;
}

@end
