//
//  HomeViewController.m
//  XYQSinaTabbar
//
//  Created by mac on 16/1/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewCell.h"
#import "HomeControllerModel.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSArray arrayWithArray:[self informaion]];
    
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"CELLID";
    HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HomeViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    HomeControllerModel *model = self.dataArray[indexPath.row];
    [cell layoutCellList:model];
    
    cell.videoDownload.tag = indexPath.row;
    [cell.videoDownload addTarget:self action:@selector(downLoadVideo:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_WIDTH/2.0 + 100;
}


#pragma mark -- UITableViewDelegate



- (NSMutableArray *)informaion{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Discover" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray * array1 = [[NSMutableArray alloc] init];
    if (array.count > 0) {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HomeControllerModel *model = [[HomeControllerModel alloc] initWithDic:obj];
            [array1 addObject:model];
        }];
    }
    return array1;
}

- (void)downLoadVideo:(UIButton *)sender{
    
    
    HomeControllerModel *model = self.dataArray[sender.tag];
    NSString *downLoadString = model.downLoadString;
    NSLog(@"%@",downLoadString);
    
    
    
}

@end
