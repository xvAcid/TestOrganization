//
//  MainViewController.m
//  TestOrganization
//
//  Created by xvAcid on 09/09/2017.
//
//

#import "MainViewController.h"
#import "MainViewModel.h"
#import "StructDefs.h"
#import "OrganizationCell.h"
#import "PointAnnotation.h"
#import "MBProgressHUD/MBProgressHUD.h"

@interface MainViewController ()
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MainViewModel *mainViewModel;

-(void) updateOrganization:(NSNotification*) notification;
-(void) addAnnotationToMap:(NSInteger) row withSection:(NSInteger) section;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainViewModel          = [MainViewModel new];
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    self.mapView.delegate       = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateOrganization:)
                                                 name:@"mainViewModel:updateOrganizations"
                                               object:nil];
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewWillAppear:(BOOL)animated {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.mainViewModel requestData];
}

#pragma mark - UITableViewDataSource
-(void) updateOrganization:(NSNotification*) notification {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.section;
    
    if (index < [self.mainViewModel.organizationList count]) {
        OrganizationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrganizationCell" forIndexPath:indexPath];
        if (cell) {
            Vizit *organizationObject = [self.mainViewModel.organizationList objectAtIndex:index];
            [cell setupCell:organizationObject.title withDescription:organizationObject.organization.title];
            [self addAnnotationToMap:indexPath.row withSection:indexPath.section];
            return cell;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 30.0f;
    return 10.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.mainViewModel.organizationList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.section;
    if (index < [self.mainViewModel.organizationList count]) {
        NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"index == %i", index];
        NSArray *filterArray    = [self.mapView.annotations filteredArrayUsingPredicate:predicate];
        
        if ([filterArray count] > 0) {
            PointAnnotation *selectedAnnotation = [filterArray objectAtIndex:0];
            [self.mapView selectAnnotation:selectedAnnotation animated:YES];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

#pragma mark - MKMapKit
-(void) addAnnotationToMap:(NSInteger) row withSection:(NSInteger) section {
    Vizit *organizationObject = [self.mainViewModel.organizationList objectAtIndex:section];
    
    CLLocationCoordinate2D location;
    location.latitude   = organizationObject.organization.latitude;
    location.longitude  = organizationObject.organization.longitude;

    if (section == 0) {
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 5000, 5000);
        [self.mapView setRegion:viewRegion animated:YES];
    }
    
    PointAnnotation *annotation = [PointAnnotation new];
    annotation.coordinate       = location;
    annotation.title            = organizationObject.title;
    annotation.subtitle         = organizationObject.organization.title;
    annotation.row              = row;
    annotation.section          = section;
    annotation.index            = organizationObject.index;
    [_mapView addAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view {
    PointAnnotation *annotation = (PointAnnotation*)view.annotation;
    
    for (Vizit *object in self.mainViewModel.organizationList) {
        if (annotation.index == object.index) {
            view.pinTintColor       = [UIColor greenColor];
            NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:annotation.row inSection:annotation.section];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKPinAnnotationView *)view {
    PointAnnotation *annotation = (PointAnnotation*)view.annotation;
    view.pinTintColor           = [UIColor redColor];
    NSIndexPath *indexPath      = [NSIndexPath indexPathForRow:annotation.row inSection:annotation.section];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) prefersStatusBarHidden {
    return YES;
}

@end
