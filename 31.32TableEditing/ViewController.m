//
//  ViewController.m
//  31.32TableEditing
//
//  Created by Admin on 13.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ViewController.h"
#import "NVStudent.h"
#import "NVGroup.h"
@interface ViewController ()
@property (strong,nonatomic) NSMutableArray *arrayOfGroups;
@end

@implementation ViewController

-(void) loadView {
    [super loadView];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
     self.tableView=tableView;
    
    //edge insets
    //UIEdgeInsets inset=UIEdgeInsetsMake(20, 0, 0, 0);
    //tableView.contentInset=inset;
    //tableView.scrollIndicatorInsets=inset;
    
     [self.view addSubview:tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.arrayOfGroups=[[NSMutableArray alloc]init];
    NSMutableArray *tempArrayStudents=[NSMutableArray array];
    //adding data
    
    for (NSInteger i=0; i<arc4random_uniform(10); i++) {
        NVGroup *group=[[NVGroup alloc]init];
        group.nameOfGroup=[NSString stringWithFormat:@"Group #%ld",i];
        
        for (NSInteger j=0; j<arc4random_uniform(10); j++) {
            NVStudent *student=[[NVStudent alloc]initRandomStudent];
            [tempArrayStudents addObject:student];
        }
        
        group.students=[NSArray arrayWithArray:tempArrayStudents];
        [self.arrayOfGroups addObject:group];
    }
    
    //end of adding data
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //UINavigationItem* item=[[UINavigationItem alloc]initWithTitle:@"Students"];
    UIBarButtonItem* buttonEdit=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEdit:)];
    [self.navigationItem setRightBarButtonItem:buttonEdit];
    self.navigationItem.title=@"Students";
    UIBarButtonItem* buttonAddSection=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddSection:)];
    self.navigationItem.leftBarButtonItem=buttonAddSection;
    
}

#pragma mark - action
- (void) actionEdit:(UIBarButtonItem*) button{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    UIBarButtonSystemItem buttonType=UIBarButtonSystemItemEdit;
    if (self.tableView.isEditing) {
        buttonType=UIBarButtonSystemItemDone;
    }
    UIBarButtonItem* buttonDone=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:buttonType target:self action:@selector(actionEdit:)];
    [self.navigationItem setRightBarButtonItem:buttonDone];
    
}
- (void) actionAddSection:(UIBarButtonItem*) button {
    NVGroup* newGroup=[[NVGroup alloc]init];
    
    [self.arrayOfGroups insertObject:newGroup atIndex:0];
    //[self.arrayOfGroups addObject:newGroup];
    [self.tableView beginUpdates];
    NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:0/*[self.arrayOfGroups count]-1*/];
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
    /*
    NSRange range=NSMakeRange(0, [self.arrayOfGroups count]);
    indexSet=[NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    */
    [self.tableView endUpdates];
    [self.tableView reloadData];
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -helpMethods
-(NVStudent*) studentInGroupByIndexPath:(NSIndexPath*)indexPath {
    NVGroup *group=[self.arrayOfGroups objectAtIndex:indexPath.section];
    NVStudent* student=nil;
    if ([group.students count]/* >=1 */) {
        student=[group.students objectAtIndex:indexPath.row-1];
    }
    return student;
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return ([self.arrayOfGroups count]/*is empty?*/ ? [self.arrayOfGroups count] : 1);
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"Group #%ld",section];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row>=1;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row>=1;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    if (destinationIndexPath.section==sourceIndexPath.section) {
        //NVStudent* currentStudent=[self studentInGroupByIndexPath:sourceIndexPath];
        NVGroup* currentGroup=[self.arrayOfGroups objectAtIndex:sourceIndexPath.section];
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:currentGroup.students];
        /*
        [tempArray removeObject:currentStudent];
        [tempArray insertObject:currentStudent atIndex:destinationIndexPath.row];
        */
        [tempArray exchangeObjectAtIndex:sourceIndexPath.row-1 withObjectAtIndex:destinationIndexPath.row-1];
        currentGroup.students=tempArray;
        
    } else {
        NVStudent* currentStudent=[self studentInGroupByIndexPath:sourceIndexPath];
        NVGroup* sourceGroup=[self.arrayOfGroups objectAtIndex:sourceIndexPath.section];
        NSMutableArray *tempSourceArray=[NSMutableArray arrayWithArray:sourceGroup.students];
        
        NVGroup* destinationGroup=[self.arrayOfGroups objectAtIndex:destinationIndexPath.section];
        NSMutableArray *tempDestinationArray=[NSMutableArray arrayWithArray:destinationGroup.students];
        
        [tempSourceArray removeObject:currentStudent];
        [tempDestinationArray insertObject:currentStudent atIndex:destinationIndexPath.row-1];
        sourceGroup.students=tempSourceArray;
        destinationGroup.students=tempDestinationArray;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NVGroup *group=nil;
    if ([self.arrayOfGroups count]){
        group=[self.arrayOfGroups objectAtIndex:section];
    }
    
    return [group.students count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* studentIdentifier=@"studentCell";
    static NSString* addStudentIdentifier=@"addStudentCell";
    UITableViewCell *cell=nil;
    
    if (indexPath.row==0) {
        cell=[tableView dequeueReusableCellWithIdentifier:addStudentIdentifier];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addStudentIdentifier];
            cell.textLabel.textColor=[UIColor magentaColor];
            cell.textLabel.text=@"Tap to add student";
        }
        
    } else {
        cell=[tableView dequeueReusableCellWithIdentifier:studentIdentifier];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:studentIdentifier];
        }
        NVGroup *group=[self.arrayOfGroups objectAtIndex:indexPath.section];
        if ([group.students count]/* >=1 */) {
            NVStudent* student=[self studentInGroupByIndexPath:indexPath];
            cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",student.firstname,student.lastname];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2f",student.average];
            if (student.average<3.0f) {
                cell.detailTextLabel.textColor=[UIColor redColor];
            } else {
                cell.detailTextLabel.textColor=[UIColor greenColor];
            }
        }
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NVStudent* student=[self studentInGroupByIndexPath:indexPath];
        NVGroup *group=[self.arrayOfGroups objectAtIndex:indexPath.section];
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:group.students];
        [tempArray removeObject:student];
        group.students=tempArray;
        [self.tableView beginUpdates];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
    }
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.frame=CGRectMake(0-CGRectGetWidth(cell.frame), CGRectGetMinY(cell.frame), CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame));

    [UIView animateWithDuration:0.3 delay:0.1 options:0 animations:^{
        cell.backgroundColor=[UIColor blueColor];
        cell.frame=CGRectMake(0,CGRectGetMinY(cell.frame), CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame));
        
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
            cell.backgroundColor=[UIColor clearColor];
        } completion:nil];
    }];
    
}
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    if (proposedDestinationIndexPath.row==0) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        NVGroup* currentGroup=[self.arrayOfGroups objectAtIndex:indexPath.section];
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:currentGroup.students] ;
        NVStudent* newStudent=[[NVStudent alloc]initRandomStudent];
        [tempArray addObject:newStudent];
        currentGroup.students=tempArray;
        [tableView beginUpdates];
        NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:[currentGroup.students count] inSection:indexPath.section];
        
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
    }
}
/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
 */
@end
