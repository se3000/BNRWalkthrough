#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WhereAmIViewController : UIViewController  <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@end
