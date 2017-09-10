//
//  PointAnnotation.h
//  TestOrganization
//
//  Created by xvAcid on 10/09/2017.
//
//

#import <MapKit/MapKit.h>

@interface PointAnnotation : MKPointAnnotation
@property (nonatomic, readwrite) NSInteger row;
@property (nonatomic, readwrite) NSInteger section;
@property (nonatomic, readwrite) int index;

-(instancetype) init;
@end
