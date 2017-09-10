//
//  MainModel.m
//  TestOrganization
//
//  Created by xvAcid on 09/09/2017.
//
//

#import "MainModel.h"
#import "AFNetworking/AFNetworking.h"
#import "StructDefs.h"

@interface MainModel()
@property (nonatomic, strong) NSArray *vizitArray;
@property (nonatomic, strong) NSArray *organizationArray;

-(void) requestDataByUrl: (NSString*) url Callback:(CompleteCallback) callback;
-(void) prepareData;
@end

@implementation MainModel

-(void) requestDataByUrl: (NSString*) url Callback:(CompleteCallback) callback {
    if (url.length > 0) {
        NSURLSessionConfiguration *configuration    = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager                = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURLRequest *request       = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLSessionDataTask *task  = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response,
                                                                                               id  _Nullable responseObject,
                                                                                               NSError * _Nullable error) {
            if (callback) {
                callback(!error ? responseObject : [NSArray array]);
            }
        }];
        
        [task resume];
    }
}

- (void) loadOrganizationList {
    dispatch_group_t group = dispatch_group_create();
    [self requestDataByUrl:@"http://demo3526062.mockable.io/getVisitsListTest" Callback:^(NSArray *responseData) {
        self.vizitArray = [responseData copy];
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    
    [self requestDataByUrl:@"http://demo3526062.mockable.io/getOrganizationListTest" Callback:^(NSArray *responseData) {
        self.organizationArray = [responseData copy];
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self prepareData];
    });
}

-(void) prepareData {
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:self.vizitArray.count];
    
    int index = 0;
    for (id object in self.vizitArray) {
        Vizit *vizit                = [Vizit new];
        NSString *stringId          = [object objectForKey:@"organizationId"];
        vizit.id                    = [stringId intValue];
        vizit.index                 = index++;
        vizit.title                 = [object objectForKey:@"title"];
        
        NSPredicate *predicate      = [NSPredicate predicateWithFormat:@"organizationId == %@", stringId];
        NSArray *findOrganization   = [self.organizationArray filteredArrayUsingPredicate:predicate];
        
        if ([findOrganization count] > 0) {
            id organizationDictionary       = [findOrganization objectAtIndex:0];
            vizit.organization              = [Organization new];
            vizit.organization.title        = [organizationDictionary objectForKey:@"title"];
            vizit.organization.latitude     = [[organizationDictionary objectForKey:@"latitude"] floatValue];
            vizit.organization.longitude    = [[organizationDictionary objectForKey:@"longitude"] floatValue];
        }

        [data addObject:vizit];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mainModel:loadedData" object:data];
    
    self.vizitArray = nil;
    self.organizationArray = nil;
}

@end
