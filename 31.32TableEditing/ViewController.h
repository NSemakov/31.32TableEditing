//
//  ViewController.h
//  31.32TableEditing
//
//  Created by Admin on 13.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak,nonatomic) UITableView *tableView;


@end

