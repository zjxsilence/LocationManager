//
//  ViewController.m
//  LocationManager
//
//  Created by 雷亮 on 16/6/29.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "ViewController.h"
#import "GPSManager.h"

#define WeakSelf(self)\
__weak typeof(self) weakSelf = self;

#define Format(...) [NSString stringWithFormat:__VA_ARGS__]

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, copy) NSString *address;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.textView.editable = NO;
    
    self.dataArray = @[@"开始定位",
                       @"停止定位",
                       @"地理编码(根据地址获取经纬度)",
                       @"反地理编码(根据经纬度获取地址)",
                       @"单次定位"];
}

#pragma mark -
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark - Using Example
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WeakSelf(self)
    if (indexPath.row == 0) {
        [GPSManager getGPSLocation:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
            weakSelf.lat = latitude;
            weakSelf.lng = longitude;
            weakSelf.textView.text = Format(@"纬度：%lf, 经度：%lf", latitude, longitude);
        }];
    } else if (indexPath.row == 1) {
        [GPSManager stop];
        self.textView.text = @"您已停止定位";
    } else if (indexPath.row == 2) {
        if (self.address.length > 0) { } else {
            self.textView.text = @"参数为空，请先进行定位并执行反向地理编码";
        }
        [GPSManager getGPSLocationWithAddress:self.address ?: @"" closure:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
            
            weakSelf.textView.text = Format(@"地理编码、根据地址获取经纬度\n纬度: %lf, 经度: %lf", latitude, longitude);
        }];
    } else if (indexPath.row == 3) {
        if (self.lat == 0 && self.lng == 0) {
            self.textView.text = @"参数为空，请先进行定位";
        }
        [GPSManager getPlacemarkWithCoordinate2D:CLLocationCoordinate2DMake(self.lat, self.lng) closure:^(Placemark *placemark) {
            weakSelf.textView.text = Format(@"反向地理编码、根据经纬度获取地理名称\n%@%@%@%@%@", placemark.country, placemark.province, placemark.city, placemark.county, placemark.address);
            weakSelf.address = Format(@"%@%@%@%@%@", placemark.country, placemark.province, placemark.city, placemark.county, placemark.address);
        }];
    } else if (indexPath.row == 4) {
        [GPSManager getGPSLocation:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
            weakSelf.lat = latitude;
            weakSelf.lng = longitude;
            weakSelf.textView.text = Format(@"单次定位\n纬度：%lf, 经度：%lf", latitude, longitude);
            
            [GPSManager stop];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
