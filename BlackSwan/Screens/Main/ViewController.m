//
//  ViewController.m
//  BlackSwan
//
//  Created by Safian Szabolcs on 08/03/15.
//  Copyright (c) 2015 safian. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "NetworkManager.h"
#import "RSSManager.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *getNewCatButton;
@property (nonatomic, strong) NSArray *rssdata;

@end

#define imageFrame (CGRect){0,0,self.view.bounds.size.width,150}

@implementation ViewController

#pragma mark - Title

- (NSString *)title {return @"NSHipster RSS";};

#pragma mark - ViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    [self dowloadNewCatImage:nil];
    [[RSSManager sharedInstance] dowloadRSSItems:^(NSArray *rssItems) {
        self.rssdata = rssItems;
        if (self.rssdata.count) {
            [self.tableView reloadData];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Sub View Loads

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:imageFrame];
        _tableView.tableHeaderView.clipsToBounds = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView.tableHeaderView addSubview:self.imageView];
        [_tableView.tableHeaderView addSubview:self.getNewCatButton];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
    }
    return _imageView;
}

-(UIButton *)getNewCatButton
{
    if (!_getNewCatButton) {
        _getNewCatButton = [[UIButton alloc] initWithFrame:(CGRect){self.imageView.bounds.size.width - 130,self.imageView.bounds.size.height-40,120,30}];
        [_getNewCatButton setTitle:@"New cat" forState:UIControlStateNormal];
        _getNewCatButton.layer.borderColor = [UIColor redColor].CGColor;
        _getNewCatButton.layer.borderWidth = 1.0;
        _getNewCatButton.layer.cornerRadius = _getNewCatButton.frame.size.height /2;
        _getNewCatButton.backgroundColor = [UIColor lightGrayColor];
        [_getNewCatButton addTarget:self action:@selector(dowloadNewCatImage:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _getNewCatButton;
}

#pragma mark - Actions
//Cat imgate action
- (void)dowloadNewCatImage:(id)sender {
    
    [[NetworkManager sharedInstance] dowloadRandomCatImageCompletion:^(UIImage *image) {
        if (image) {
            self.imageView.image = image;
        }
    }];
}


#pragma mark - TableView Delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }cell.textLabel.text = [[self.rssdata objectAtIndex:indexPath.row] objectForKey: @"title"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rssdata.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailVc.urlString = [[self.rssdata objectAtIndex:indexPath.row] objectForKey: @"link"];
    [self.navigationController pushViewController:detailVc animated:YES];
    detailVc.title = [[self.rssdata objectAtIndex:indexPath.row] objectForKey: @"title"];
}

#pragma mark - Scroll Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.imageView && scrollView.contentOffset.y < 0) {
        CGRect frame = imageFrame;
        frame.size.height = imageFrame.size.height - scrollView.contentOffset.y;
        frame.origin.y = MIN(0, scrollView.contentOffset.y);
        self.imageView.frame = frame;
    }
}

@end
