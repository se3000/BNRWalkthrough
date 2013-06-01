#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface WhereAmIViewController : UIViewController  <CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    
    IBOutlet MKMapView *worldView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITextField *locationTitleField;
    __weak IBOutlet UISegmentedControl *mapTypeControl;
}

- (void)findLocation;
- (void)foundLocation:(CLLocation *)loc;
- (IBAction)changeMapType:(id)sender;

@end