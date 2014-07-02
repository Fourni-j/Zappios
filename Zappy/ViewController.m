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

@synthesize adminButton, playerButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    adminButton.layer.cornerRadius = 45;
    playerButton.layer.cornerRadius = 45;
    
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

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -340.0f;  //set the -35.0f to your required value
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Passing data with segue

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
        
        if ([self.teamField.text isEqualToString:@""])
            pvc.connectTeam = @"team1";
        else
            pvc.connectTeam = self.teamField.text;
    }
}

#pragma mark - connection button

- (IBAction)ConnectAdmin:(id)sender {
    [self.view endEditing:YES];
    
}

- (IBAction)ConnectPlayer:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - Windows caracteristics

- (BOOL)prefersStatusBarHidden
{
    return true;
}

@end