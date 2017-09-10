//
//  MainViewModel.h
//  TestOrganization
//
//  Created by xvAcid on 10/09/2017.
//
//

#import <Foundation/Foundation.h>

@interface MainViewModel : NSObject
- (instancetype) init;
- (void) requestData;

@property(nonatomic, strong) NSArray *organizationList;
@end
