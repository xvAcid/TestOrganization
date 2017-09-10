//
//  MainModel.h
//  TestOrganization
//
//  Created by xvAcid on 09/09/2017.
//
//

#import <Foundation/Foundation.h>

@interface MainModel : NSObject

@property (nonatomic, copy) NSArray *vizitData;

- (void) loadOrganizationList;

@end
