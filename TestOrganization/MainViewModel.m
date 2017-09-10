//
//  MainViewModel.m
//  TestOrganization
//
//  Created by xvAcid on 10/09/2017.
//
//

#import "MainViewModel.h"
#import "MainModel.h"

@interface MainViewModel()

@property (nonatomic, strong) MainModel *model;

-(void) updateLoadedModel:(NSNotification*) notification;

@end

@implementation MainViewModel

- (instancetype) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.model = [MainModel new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLoadedModel:)
                                                 name:@"mainModel:loadedData"
                                               object:nil];
    return self;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) requestData {
    [self.model loadOrganizationList];
}

-(void) updateLoadedModel:(NSNotification*) notification {
    NSArray *loadedData     = (NSArray*)[notification object];
    self.organizationList   = [loadedData copy];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mainViewModel:updateOrganizations" object:nil];
}

@end
