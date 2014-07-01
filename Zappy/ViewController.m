//
//  ViewController.m
//  Zappy
//
//  Created by Charles Fournier on 30/06/2014.
//
//

#import "ViewController.h"
#import "AdministratorViewController.h"
#import "PlayerViewController.h"

@interface ViewController ()
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"AdministratorScreen"] || [[segue identifier] isEqualToString:@"PlayerScreen"])
    {
        AdministratorViewController *avc = [segue destinationViewController];
        avc.connectAddress = self.addressField.text;
        avc.connectPort = self.portField.text.intValue;
    }
    
    if ([[segue identifier] isEqualToString:@"PlayerScreen"])
    {
        PlayerViewController *pvc = [segue destinationViewController];
        if ([self.addressField.text isEqualToString:@""])
            pvc.connectAddress = @"127.0.0.1";
        else
            pvc.connectAddress = self.addressField.text;
        if ([self.portField.text isEqualToString:@""])
            pvc.connectPort = 4242;
        else
            pvc.connectPort = self.portField.text.intValue;
    }
}

- (IBAction)ConnectAdmin:(id)sender {
    NSLog(@"Switching view");
}

- (IBAction)ConnectPlayer:(id)sender {
}
@end