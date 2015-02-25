//
//  G3MachinesViewController.m
//  Graphs
//
//  Created by George on 04/02/15.
//  Copyright (c) 2015 SMediaLink. All rights reserved.
//

#import "G3MachinesViewController.h"
#import "GGraphView.h"
#import "GGraph+_Machines.h"

@interface G3MachinesViewController ()

@property (weak, nonatomic) IBOutlet UITextField *fieldA;
@property (weak, nonatomic) IBOutlet UITextField *fieldB;
@property (weak, nonatomic) IBOutlet UITextField *fieldC;
@property (weak, nonatomic) IBOutlet GGraphView *graphView;
@property (weak, nonatomic) IBOutlet UILabel *labelResult;
@property (nonatomic) GGraph *graph;

@end

@implementation G3MachinesViewController

- (void)setGraph:(GGraph *)graph
{
    _graph = graph;
    self.graphView.graph = graph;
}

- (IBAction)compute:(id)sender
{
    NSArray *aStrings = [self.fieldA.text componentsSeparatedByString:@" "];
    NSMutableArray *aNums = [NSMutableArray arrayWithCapacity:aStrings.count];
    for (NSString *str in aStrings)
        [aNums addObject:[NSNumber numberWithInteger:[str integerValue]]];
    
    NSArray *bStrings = [self.fieldB.text componentsSeparatedByString:@" "];
    NSMutableArray *bNums = [NSMutableArray arrayWithCapacity:bStrings.count];
    for (NSString *str in bStrings)
        [bNums addObject:[NSNumber numberWithInteger:[str integerValue]]];
    
    NSArray *cStrings = [self.fieldC.text componentsSeparatedByString:@" "];
    NSMutableArray *cNums = [NSMutableArray arrayWithCapacity:cStrings.count];
    for (NSString *str in cStrings)
        [cNums addObject:[NSNumber numberWithInteger:[str integerValue]]];
    
    self.graph = [GGraph buildGraphWithA:aNums b:bNums c:cNums];
    G3MachinesVertex *vertex = [self.graph findBest3Leaf];
    self.labelResult.text = [[[vertex delta] stringValue] stringByAppendingString:@" : "];
    NSMutableArray *indexes = [NSMutableArray array];
    while (vertex.parent != vertex)
    {
        NSInteger index = [vertex.index integerValue] + 1;
        [indexes insertObject:[NSString stringWithFormat:@"%i", index] atIndex:0];
        vertex = vertex.parent;
    }
    self.labelResult.text = [self.labelResult.text stringByAppendingString:[indexes componentsJoinedByString:@", "]];
    [self.view endEditing:YES];
}

@end
