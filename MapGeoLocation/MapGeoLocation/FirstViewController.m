//
//  FirstViewController.m
//  MapGeoLocation
//
//  Created by Lokesh Subramani on 5/24/14.
//  Copyright (c) 2014 CMPE277. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
