#import "WhereAmIViewController.h"
#import "BNRMapPoint.h"

NSString * const WhereAmIMapTypePrefKey = @"WhereAmIMapTypePreference";

@implementation WhereAmIViewController

+ (void)initialize {
    NSDictionary *defaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] 
                                                         forKey:WhereAmIMapTypePrefKey];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:(NSBundle *)nibBundleOrNil];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    
    if (t < -180) {
        return;
    }
    
    [self foundLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

- (void)viewDidLoad
{
    [worldView setShowsUserLocation:YES];
    
    NSInteger mapTypeValue = [[NSUserDefaults standardUserDefaults] integerForKey:WhereAmIMapTypePrefKey];
    [mapTypeControl setSelectedSegmentIndex:mapTypeValue];
    [self changeMapType:mapTypeControl];
}

- (void)dealloc
{
    [locationManager setDelegate:nil];
}

- (void)mapView:(MKMapView *)mapView 
    didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [worldView setRegion:region animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self findLocation];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)findLocation
{
    [locationManager startUpdatingLocation];
    [activityIndicator startAnimating];
    [locationTitleField setHidden:YES];
}

- (void)foundLocation:(CLLocation *)loc
{
    CLLocationCoordinate2D coord = [loc coordinate];
    BNRMapPoint *mp = [[BNRMapPoint alloc] initWithCoordinate:coord 
                                                        title:[locationTitleField text]];
    [worldView addAnnotation:mp];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [worldView setRegion:region animated:YES];
    
    [locationTitleField setText:@""];
    [activityIndicator stopAnimating];
    [locationTitleField setHidden:NO];
    [locationManager stopUpdatingLocation];
}

- (IBAction)changeMapType:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:[sender selectedSegmentIndex] 
                                               forKey:WhereAmIMapTypePrefKey];
    
    switch ([sender selectedSegmentIndex]) {
        case 0: {
            worldView.mapType = MKMapTypeStandard;
        } break;
        case 1: {
            worldView.mapType = MKMapTypeSatellite;
        } break;
        case 2: {
            worldView.mapType = MKMapTypeHybrid;
        } break;
    }
}

@end