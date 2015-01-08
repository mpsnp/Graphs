//
//  ViewController.m
//  Graphs
//
//  Created by George on 08/01/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "ViewController.h"
#import "GGraphView.h"
#import "GGraph.h"

@interface ViewController ()
@property (nonatomic, strong) GGraph *graph;
@property (nonatomic, strong) GGraph *spanningTree;
@property (weak, nonatomic) IBOutlet GGraphView *spanningTreeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"7.7" ofType:@"json"]];
    self.graph = [GGraph graphWithData:data];
    
    GGraphView *view = (GGraphView *)self.view;
    view.graph = self.graph;
    self.spanningTree = [self.graph spanningTreeMinimal:YES];
}

- (IBAction)topGraphChanged:(id)sender
{
    [self.view setNeedsDisplay];
}

- (void)setSpanningTree:(GGraph *)spanningTree
{
    _spanningTree = spanningTree;
    self.spanningTreeView.graph = self.spanningTree;
}

- (IBAction)switchType:(UISegmentedControl *)sender
{
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.spanningTree = [self.graph spanningTreeMinimal:YES];
            break;
        case 1:
            self.spanningTree = [self.graph spanningTreeMinimal:NO];
            break;
    }
}

@end
