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
#import "GEdgeEditViewController.h"
#import <WEPopoverController.h>

@interface ViewController () <WEPopoverControllerDelegate>
@property (nonatomic, strong) GGraph *graph;
@property (nonatomic, strong) GGraph *spanningTree;
@property (weak, nonatomic) IBOutlet UISegmentedControl *treeType;
@property (weak, nonatomic) IBOutlet GGraphView *spanningTreeView;
@property (nonatomic) WEPopoverController *popOver;
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
    [self.spanningTreeView setNeedsDisplay];
}

- (void)setSpanningTree:(GGraph *)spanningTree
{
    _spanningTree = spanningTree;
    self.spanningTreeView.graph = self.spanningTree;
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController
{
    [self topGraphChanged:self];
    [self setSpanningTree:[self.graph spanningTreeMinimal:self.treeType.selectedSegmentIndex == 0]];
}

- (IBAction)changing:(GGraphView *)sender
{
    GEdgeEditViewController *editor = [self.storyboard instantiateViewControllerWithIdentifier:@"PopOver"];
    editor.edgeForEdit = sender.selectedEdge;
    if (editor)
    {
        self.popOver = [[WEPopoverController alloc] initWithContentViewController:editor];
        self.popOver.delegate = self;
        self.popOver.popoverContentSize = CGSizeMake(200, 50);
        [self.popOver presentPopoverFromRect:[sender rectForEdge:sender.selectedEdge] inView:self.spanningTreeView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
