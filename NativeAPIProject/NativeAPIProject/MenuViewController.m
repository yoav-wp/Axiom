//
//  MenuViewController.m
//  scrollViewTest
//
//  Created by Nir Gaiger on 8/8/16.
//  Copyright © 2016 Design Webpals. All rights reserved.
//

#import "MenuViewController.h"
#import "NavigationManager.h"

@implementation MenuViewController{
    NavigationManager *_nav;
}

@synthesize firstArray,secondArray;
@synthesize firstForTable,secondForTable;


- (void)viewDidLoad
{
    [super viewDidLoad];
    _nav = [[NavigationManager alloc]  init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = [paths objectAtIndex:0];
    NSURL *destinationURL = [NSURL fileURLWithPath:[documentDirectoryPath stringByAppendingPathComponent:@"menu.plist"]];
    
    NSDictionary *dTmp=[[NSDictionary alloc] initWithContentsOfFile:[destinationURL path]];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.firstArray=[dTmp valueForKey:@"Objects"];
    
    self.firstForTable=[[NSMutableArray alloc] init] ;
    [self.firstForTable addObjectsFromArray:self.firstArray];
    
//    self.secondForTable=[[NSMutableArray alloc] init] ;
//    [self.secondForTable addObjectsFromArray:self.secondArray];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}



// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = [self.firstForTable count];
            break;
        case 1:
            rows = [self.secondForTable count];
            break;
    }
    return rows;
}


-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0;
}




- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *testo;
    switch (section) {
        case 0:
            testo = @"";
            break;
        case 1:
            testo = @"Second Section";
            break;
            
    }
    
    return testo;
}





// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    if(indexPath.section==0)
    {
        int lvl = [[[self.firstForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue];
        
        if(lvl == 0){
            cell.backgroundColor = [UIColor colorWithWhite:0.65 alpha:1.0];
        }
        if(lvl == 1){
            cell.backgroundColor = [UIColor colorWithWhite:0.71 alpha:1.0];
        }
        if(lvl == 2){
            cell.backgroundColor = [UIColor colorWithWhite:0.78 alpha:1.0];
        }
        if(lvl == 3){
            cell.backgroundColor = [UIColor colorWithWhite:0.84 alpha:1.0];
        }
        if(lvl == 4){
            cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        }
        
        
        cell.textLabel.text=[[self.firstForTable objectAtIndex:indexPath.row] valueForKey:@"name"];
        [cell setIndentationLevel:[[[self.firstForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
        
    }else
    {
        cell.textLabel.text=[[self.secondForTable objectAtIndex:indexPath.row] valueForKey:@"name"];
        [cell setIndentationLevel:[[[self.secondForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        NSDictionary *d=[self.firstForTable objectAtIndex:indexPath.row];
        if([d valueForKey:@"Objects"]) {
            NSArray *ar=[d valueForKey:@"Objects"];
            
            BOOL isAlreadyInserted=NO;
            
            for(NSDictionary *dInner in ar ){
                NSInteger index=[self.firstForTable indexOfObjectIdenticalTo:dInner];
                isAlreadyInserted=(index>0 && index!=NSIntegerMax);
                if(isAlreadyInserted) break;
            }
            
            if(isAlreadyInserted) {
                [self miniMizeFirstsRows:ar];
            } else {
                NSUInteger count=indexPath.row+1;
                NSMutableArray *arCells=[NSMutableArray array];
                for(NSDictionary *dInner in ar ) {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                    [self.firstForTable insertObject:dInner atIndex:count++];
                }
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
            }
        }else
        {
            NSString *destLink = [d valueForKey:@"page_link2"];
            [_nav navigateWithItemID:-42 WithURL:destLink WithURLsDict:nil WithSourceVC:self];
        }
    }
    
    
    
    if (indexPath.section==1) {
        
        NSDictionary *d=[self.secondForTable objectAtIndex:indexPath.row];
        if([d valueForKey:@"Objects"]) {
            NSArray *ar=[d valueForKey:@"Objects"];
            
            BOOL isAlreadyInserted=NO;
            
            for(NSDictionary *dInner in ar ){
                NSInteger index=[self.secondForTable indexOfObjectIdenticalTo:dInner];
                isAlreadyInserted=(index>0 && index!=NSIntegerMax);
                if(isAlreadyInserted) break;
            }
            
            if(isAlreadyInserted) {
                [self miniMizeSecondsRows:ar];
            } else {
                NSUInteger count=indexPath.row+1;
                NSMutableArray *arCells=[NSMutableArray array];
                for(NSDictionary *dInner in ar ) {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:1]];
                    [self.secondForTable insertObject:dInner atIndex:count++];
                }
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
            }
        }else
        {
            NSLog(@"Leave Element:::%@ %@|",[d valueForKey:@"name"],[d valueForKey:@"book"]);
        }
    }
    
    
}

-(void)miniMizeFirstsRows:(NSArray*)ar{
    
    for(NSDictionary *dInner in ar ) {
        NSUInteger indexToRemove=[self.firstForTable indexOfObjectIdenticalTo:dInner];
        NSArray *arInner=[dInner valueForKey:@"Objects"];
        if(arInner && [arInner count]>0){
            [self miniMizeFirstsRows:arInner];
        }
        
        if([self.firstForTable indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
            [self.firstForTable removeObjectIdenticalTo:dInner];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}


-(void)miniMizeSecondsRows:(NSArray*)ar{
    
    for(NSDictionary *dInner in ar ) {
        NSUInteger indexToRemove=[self.secondForTable indexOfObjectIdenticalTo:dInner];
        NSArray *arInner=[dInner valueForKey:@"Objects"];
        if(arInner && [arInner count]>0){
            [self miniMizeSecondsRows:arInner];
        }
        
        if([self.secondForTable indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
            [self.secondForTable removeObjectIdenticalTo:dInner];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:1]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}



@end
