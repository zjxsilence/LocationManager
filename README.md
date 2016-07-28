# LocationManager
系统定位封装，block回调，超级好用.

	/// 开始定位
	WeakSelf(self)
	[GPSManager getGPSLocation:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
  	  weakSelf.lat = latitude;
    	weakSelf.lng = longitude;
    	NSLog(@"latitude: (%lf), longitude: (%lf)", latitude, longitude);
	}];

	/// 停止定位
	[GPSManager stop];

	/// 根据经纬度获取当前位置的地理名称，例：中国浙江省宁波市宁海县某某街道
	WeakSelf(self)
	[GPSManager getPlacemarkWithCoordinate2D:CLLocationCoordinate2DMake(self.lat, self.lng) closure:^(Placemark *placemark) {
  	  weakSelf.address = Format(@"%@%@%@%@%@", placemark.country, placemark.province, placemark.city, placemark.county, placemark.address);
	    NSLog(@"address : %@", weakSelf.address);
	}];

	/// 根据地理位置名称获取经纬度
	[GPSManager getGPSLocationWithAddress:self.address ?: @"" closure:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
  	  NSLog(@"latitude: (%lf), longitude: (%lf)", latitude, longitude);
	}];

