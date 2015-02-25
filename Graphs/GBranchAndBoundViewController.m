//
//  GBranchAndBoundViewController.m
//  Graphs
//
//  Created by George on 02/02/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "GBranchAndBoundViewController.h"
#import "GGraphView.h"
#import "GOrientedGraph.h"
#import "GEdgeEditViewController.h"
#import "GGraph+BranchAndBound.h"
#import "GTreeViewController.h"
#import <WEPopoverController.h>

@interface GBranchAndBoundViewController () <WEPopoverControllerDelegate>
@property (nonatomic, strong) GGraph *graph;
@property (nonatomic, strong) GGraph *branchGraph;
@property (weak, nonatomic) IBOutlet GGraphView *branchGraphView;
@property (nonatomic) WEPopoverController *popOver;
@end

@implementation GBranchAndBoundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2.7" ofType:@"json"]];
    self.graph = [GOrientedGraph orientedGraphWithGraph:[GGraph graphWithData:data]];
    
    GGraphView *view = (GGraphView *)self.view;
    view.graph = self.graph;
    [self setBranchGraph:[self.graph branchAndBoud]];
}

- (void)setBranchGraph:(GGraph *)minimalGraph
{
    _branchGraph = minimalGraph;
    self.branchGraphView.graph = _branchGraph;
}

- (IBAction)changing:(GGraphView *)sender
{
    if (sender.selectionType == GGraphSelectionEdge)
    {
        GEdgeEditViewController *editor = [self.storyboard instantiateViewControllerWithIdentifier:@"PopOver"];
        editor.edgeForEdit = sender.selectedEdge;
        if (editor)
        {
            self.popOver = [[WEPopoverController alloc] initWithContentViewController:editor];
            self.popOver.delegate = self;
            self.popOver.popoverContentSize = CGSizeMake(200, 50);
            [self.popOver presentPopoverFromRect:[sender rectForEdge:sender.selectedEdge] inView:self.branchGraphView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"ShowTree" sender:self];
    }
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController
{
    [self topGraphChanged:self];
    [self setBranchGraph:[self.graph branchAndBoud]];
}

- (IBAction)topGraphChanged:(id)sender
{
    [self.view setNeedsDisplay];
    [self.branchGraphView setNeedsDisplay];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowTree"])
    {
        GTreeViewController *dest = segue.destinationViewController;
        dest.graph = self.branchGraph.info;
    }
}

@end
