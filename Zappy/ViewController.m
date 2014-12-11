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
{
    UIActivityIndicatorView *indicator;
    NSMutableData *receivedData;
    NSString     *prevLogin;
}

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
    if ([[segue identifier]isEqualToString:@"AdministratorScreen"])
    {
        AdministratorViewController *avc = [segue destinationViewController];
        
        if ([self.addressField.text isEqualToString:@""])
            avc.connectAddress = @"127.0.0.1";
        else
            avc.connectAddress = self.addressField.text;
        if ([self.portField.text isEqualToString:@""])
            avc.connectPort = 4242;
        else
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

#pragma mark - IP Finder

- (IBAction)findIP:(id)sender {
    [self getIPFromLogin];
}

- (void)getIPFromLogin
{
    NSString *login = self.loginField.text;
    
    if ([login isEqualToString:@""] || [login isEqualToString:prevLogin])
        return;
    
    prevLogin = login;
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0, 0, 40, 40);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [indicator startAnimating];
    

    NSString *post=@"login=LOGIN&password=PASSWORD";
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    NSString *show = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", show);
    
    receivedData = [NSMutableData dataWithCapacity:0];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://intra.epitech.eu/user/%@/", login]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    __unused NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"Response : %@", responseString);
    NSRange range = [responseString rangeOfString:@"10.16.253."];
    range.length = 13;
    
    NSString *tmp = [responseString substringWithRange:range];
    NSLog(@"Ip : %@", tmp);
    self.addressField.text = tmp;
    [indicator stopAnimating];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}


@end
