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
    UIEdgeInsets inset=UIEdgeInsetsMake(20, 0, 0, 0);
    tableView.contentInset=inset;
    tableView.scrollIndicatorInsets=inset;
    
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


#pragma mark -UITableViewDelegate

@end
