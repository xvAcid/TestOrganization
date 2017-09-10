//
//  PointAnnotation.m
//  TestOrganization
//
//  Created by xvAcid on 10/09/2017.
//
//

#import "PointAnnotation.h"

@implementation PointAnnotation

-(instancetype) init {
    self = [super init];
    if (!self)
        return nil;
    
    self.row        = 0;
    self.section    = 0;
    self.index      = 0;
    return self;
}
@end
