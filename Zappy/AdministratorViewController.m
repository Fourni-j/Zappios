//
//  AdministratorViewController.m
//  Zappy
//
//  Created by Charles Fournier on 30/06/2014.
//
//

#import "AdministratorViewController.h"

@interface AdministratorViewController ()

@end

@implementation AdministratorViewController

@synthesize connectAddress, connectPort, inputStream, outputStream;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Administrator Connect to %@:%li", self.connectAddress, (long)self.connectPort);
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{

}

@end
