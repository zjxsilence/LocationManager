# LocationManager
现在很多app，包括社交、电商、团购等应用都引入了地图和定位的功能，这两个功能早已经不再是地图应用和导航应用所特有的。之前在添加定位功能的时候，对CoreLocation这里进行了一下封装，使用起来还是蛮方便的，今天把他分享给大家，希望能对大家有所帮助。

主要方法如下:
```
// 定位
[GPSManager getGPSLocation:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
NSLog(@"纬度: %lf, 纬度: %lf", latitude, longitude);
}];

// 停止定位
[GPSManager stop];

// 正向地理编码(根据地址名获取经纬度)
[GPSManager getGPSLocationWithAddress:self.address ?: @"" closure:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
NSLog(@"纬度: %lf, 纬度: %lf", latitude, longitude);
}];

// 逆向地理编码(根据经纬度获取地理位置)
[GPSManager getPlacemarkWithCoordinate2D:CLLocationCoordinate2DMake(self.lat, self.lng) closure:^(Placemark *placemark) {
NSLog(@"地址：%@%@%@%@%@", placemark.country, placemark.province, placemark.city, placemark.county, placemark.address)
}];

// 单次定位(在定位回调之后结束定位即可)
[GPSManager getGPSLocation:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {            
NSLog(@"纬度: %lf, 纬度: %lf", latitude, longitude);
[GPSManager stop];
}];
```

如果你需要后台定位，在"GPSManager.m"文件中少做改动即可，具体已经在该文件中注释，如下：
```
- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
        
        // 兼容iOS8.0版本
        /* Info.plist里面加上2项中的一项
         NSLocationAlwaysUsageDescription      String YES
         NSLocationWhenInUseUsageDescription   String YES
         */
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            // iOS8.0以上，使用应用程序期间允许访问位置数据
            [_locationManager requestWhenInUseAuthorization];
            // iOS8.0以上，始终允许访问位置信息
//            [_locationManager requestAlwaysAuthorization];
        }
        
        _geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}
```

不要忘了设置info.plist文件欧.

Demo样式如下图:


![WeChat_1469694465.jpeg](http://upload-images.jianshu.io/upload_images/1481785-a69fb8884a58f6a9.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


如果您喜欢这个库的话，请给个star奥，谢谢大家!!!