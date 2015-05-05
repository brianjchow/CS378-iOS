#import "LoadViewController.h"

#import "ConnectionManager.h"
#import "Constants.h"

@interface LoadViewController ()

@property (strong, nonatomic) IBOutlet UILabel *loadingLabel;

@property (nonatomic, strong) UIImageView *animationImageView;

@property (strong, nonatomic) UIImage *navigationBarBackgroundImage;
@property (strong, nonatomic) UIImage *navigationBarShadowImage;

@end

static NSString *const LOAD_VIEW_SEGUE_ID = @"loadViewSegue";
static NSString *const LOAD_VIEW_TO_FIND_ROOM_SEGUE_ID = @"findRoomNowSegue";
static NSString *const LOADING_IMAGE_NAME = @"backgroundinitial";

@implementation LoadViewController

- (void) segue_to_main_screen {
    [self performSegueWithIdentifier : LOAD_VIEW_TO_FIND_ROOM_SEGUE_ID sender : self];
}

- (void) finish_loading_and_segue {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.animationImageView stopAnimating];
        [self presentNavigationBar];
        [self segue_to_main_screen];
    });
}

- (void) alertView : (UIAlertView *) alertView clickedButtonAtIndex : (NSInteger) buttonIndex {
    NSLog(@"Clicked alert button index %ld", buttonIndex);
    
    if (buttonIndex == 1) {
        NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
        [user_defaults setValue : [NSNumber numberWithBool : NO] forKey : SHOW_WIFI_WWAN_WARNING];
        [user_defaults synchronize];
    }
    
    [self finish_loading_and_segue];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundImage];
    [self setLoadingAnimation];
    [self.view bringSubviewToFront : self.loadingLabel];
    [self.animationImageView startAnimating];
    [self hideNavigationBar];
    
    __block UIAlertView *warning_dialog = [[UIAlertView alloc]
                                           initWithTitle : @"Warning"
                                           message : @"For best accuracy, please enable WiFi and/or WWAN and restart the app."
                                           delegate : self
                                           cancelButtonTitle : @"OK"
                                           otherButtonTitles: @"Don't show again", nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [Constants init];
        
        bool has_cxn = [ConnectionManager has_wifi] || [ConnectionManager has_wwan];
        if (has_cxn) {
//            [warning_dialog show];
            [self finish_loading_and_segue];
        }
        else {
            bool should_show_warning = [[[NSUserDefaults standardUserDefaults] valueForKey : SHOW_WIFI_WWAN_WARNING] boolValue];
            if (should_show_warning) {
                [warning_dialog show];
            }
            else {
                [self finish_loading_and_segue];
            }
        }
        
        if (_DEBUG) {
            NSLog(@"Wifi/mobile cxn detected: %@", BOOL_STRS[has_cxn]);
        }
        
    });
    
    
    
    
    
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        [Constants init];
//    });
    
//    [self segue_to_main_screen];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName : @"Main.Storyboard" bundle : nil];
//    UIViewController *view_obj = [storyboard instantiateViewControllerWithIdentifier : @"FindRoomNowViewController"];
//    
//    [self.navigationController pushViewController : view_obj animated : YES];
    
    
    //    [self.animationImageView stopAnimating];
    //    [self performSegueWithIdentifier:@"drawerView" sender:self];
    
    
    
    
    
    
}

- (void) hideNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage : [UIImage new] forBarMetrics : UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent : YES];
    [self.navigationController.navigationBar setShadowImage : [UIImage new]];
    [self.navigationController setNavigationBarHidden : YES animated : YES];
}

- (void) presentNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage : self.navigationBarBackgroundImage forBarMetrics : UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent : YES];
    [self.navigationController.navigationBar setShadowImage : self.navigationBarShadowImage];
    [self.navigationController setNavigationBarHidden : NO animated : YES];
}

//http://stackoverflow.com/questions/23739767/how-to-centre-the-background-image-in-a-uiview-without-streching-it
- (void)setBackgroundImage {
    self.navigationBarBackgroundImage = [self.navigationController.navigationBar backgroundImageForBarMetrics : UIBarMetricsDefault];
    self.navigationBarShadowImage = self.navigationController.navigationBar.shadowImage;
    
    UIImage *backgroundImage = [UIImage imageNamed:LOADING_IMAGE_NAME];
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGRect imagePosition = CGRectMake((self.view.bounds.size.width / 2)  - (backgroundImage.size.width / 2),
                                      (self.view.bounds.size.height / 2) - (backgroundImage.size.height / 2),
                                      backgroundImage.size.width,
                                      backgroundImage.size.height);
    
    [backgroundImage drawInRect:imagePosition];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:image];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:image];
//    backgroundView.contentMode = UIViewContentModeScaleAspectFit; // UIViewContentModeScaleToFill; // UIViewContentModeScaleAspectFill;
//    backgroundView.autoresizingMask =
//    ( UIViewAutoresizingFlexibleBottomMargin
//     | UIViewAutoresizingFlexibleHeight
//     | UIViewAutoresizingFlexibleLeftMargin
//     | UIViewAutoresizingFlexibleRightMargin
//     | UIViewAutoresizingFlexibleTopMargin
//     | UIViewAutoresizingFlexibleWidth );
    [self.view addSubview:backgroundView];
}

//http://www.appcoda.com/ios-programming-animation-uiimageview/
- (void)setLoadingAnimation {
    NSArray *imageNames = @[@"frame_000_200p_transparent", @"frame_001_200p_transparent", @"frame_002_200p_transparent", @"frame_003_200p_transparent"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    // Normal Animation
    self.animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 95, 126, 193)];
    
    self.animationImageView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    self.animationImageView.animationImages = images;
    self.animationImageView.animationDuration = 0.5;
    [self.view addSubview:self.animationImageView];
}


@end