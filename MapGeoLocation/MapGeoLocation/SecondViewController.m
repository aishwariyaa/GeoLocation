//
//  SecondViewController.m
//  MapGeoLocation
//
//  Created by Lokesh Subramani on 5/24/14.
//  Copyright (c) 2014 CMPE277. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
        [super viewDidLoad];
    
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
    
}
- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}
- (IBAction)getLocation:(id)sender
{
_locationManager = [[CLLocationManager alloc] init];
_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
_locationManager.delegate = self;
[_locationManager startUpdatingLocation];
_startLocation = nil;
}




#pragma mark -
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    NSString *addressString =
    [NSString stringWithFormat:
     @"%@ %@ %@",
     _address.text,
     _city.text,
     _zip.text];
    
    CLLocationDistance distanceBetween = [newLocation
                        distanceFromLocation:addressString];
    [self.locationManager stopUpdatingLocation];
   
}

-(void)locationManager:(CLLocationManager *)manager 
      didFailWithError:(NSError *)error
{
}

- (IBAction)getDirections:(id)sender {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    NSString *addressString =
    [NSString stringWithFormat:
     @"%@ %@ %@",
     _address.text,
     _city.text,
     _zip.text];
    
    [geocoder
     geocodeAddressString:addressString
     completionHandler:^(NSArray *placemarks,
                         NSError *error) {
         
         if (error) {
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         
         if (placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark = placemarks[0];
             
             CLLocation *location = placemark.location;
             _coords = location.coordinate;
             
             [self showMap];
         }
     }];
}

-(void)showMap
{
    NSDictionary *address = @{
                              (NSString *)kABPersonAddressStreetKey: _address.text,
                              (NSString *)kABPersonAddressCityKey: _city.text,
                              (NSString *)kABPersonAddressZIPKey: _zip.text
                              };
    
    MKPlacemark *place = [[MKPlacemark alloc]
                          initWithCoordinate:_coords
                          addressDictionary:address];
    
    MKMapItem *mapItem =
    [[MKMapItem alloc]initWithPlacemark:place];
    
    NSDictionary *options = @{
                              MKLaunchOptionsDirectionsModeKey:
                                  MKLaunchOptionsDirectionsModeDriving
                              };
    
    [mapItem openInMapsWithLaunchOptions:options];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
