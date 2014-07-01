//
//  PlayerViewController.m
//  Zappy
//
//  Created by Charles Fournier on 30/06/2014.
//
//

#import "PlayerViewController.h"

@interface PlayerViewController ()
{
    BOOL deraumere;
    BOOL sibur;
    BOOL food;
}

@end

@implementation PlayerViewController

@synthesize outputStream, inputStream;
@synthesize connectAddress;
@synthesize connectPort;
@synthesize foodButton, linemateLayButton, linemateTakeButton, foodLayButton, deraumereLayButton, deraumereTakeButton, siburLayButton, siburTakeButton, mendianeLayButton, mendianeTakeButton, phirasLayButton, phirasTakeButton, thystameLayButton, thystameTakeButton;

@synthesize layLabel, takeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetAttribute
{
    deraumere = NO;
    sibur = NO;
    food = NO;
}

#pragma mark - AlertView initialisation

- (void)popDisconnectAlert:(NSString *)msg
{
    [inputStream setDelegate:nil];
    [outputStream setDelegate:nil];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:msg message:@"Check if the server is up" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [av show];
}

- (void)popPlayerEventAlert:(NSString *)msg
{
    [inputStream setDelegate:nil];
    [outputStream setDelegate:nil];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:msg message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [av show];
}

#pragma mark - Parsing functions

- (void)checkExpression:(NSString *)msg
{
    if ([msg isEqualToString:@"BIENVENUE\n"])
        [self messageSend:@"team1"];
    else if ([msg isEqualToString:@"mort\n"])
        [self popPlayerEventAlert:@"Mort"];
    
    if ([msg hasPrefix:@"{nourriture"])
    {
        
    }
}



#pragma mark - Network functions

- (void)initNetworkCommunication
{
    CFReadStreamRef     readStream;
    CFWriteStreamRef    writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.connectAddress, (int)self.connectPort, &readStream, &writeStream);
    
    inputStream = (__bridge_transfer NSInputStream *)readStream;
    outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
}

- (void)messageReceived
{
    uint8_t buffer[1024];
    int len;
    
    while ([inputStream hasBytesAvailable])
    {
        len = (int)[inputStream read:buffer maxLength:sizeof(buffer)];
        if (len > 0)
        {
            NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
            if (nil != output)
            {
                NSLog(@"server said: %@", output);
                [self checkExpression:output];
            }
        }
    }
}

- (void)messageSend:(NSString *)msg
{
    NSString *response = [NSString stringWithFormat:@"%@\n", msg];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    NSLog(@"Message sent : %@", response);
}


#pragma mark - Action buttons

- (IBAction)avance:(UIButton *)sender {
    [self messageSend:@"avance"];
    [self messageSend:@"voir"];
}

- (IBAction)turnLeft:(id)sender {
    [self messageSend:@"gauche"];
}

- (IBAction)turnRight:(id)sender {
    [self messageSend:@"droite"];
}

- (IBAction)incantation:(id)sender {
    [self messageSend:@"incantation"];
}

- (IBAction)prendNourriture:(id)sender {
    [self messageSend:@"prend nourriture"];
}

- (IBAction)prendLinemate:(id)sender {
    [self messageSend:@"prend linemate"];
}

- (IBAction)prendSibur:(id)sender {
    [self messageSend:@"prend sibur"];
}

- (IBAction)prendMendiane:(id)sender {
    [self messageSend:@"prend mendiane"];
}

- (IBAction)prendPhiras:(id)sender {
    [self messageSend:@"prend phiras"];
}

- (IBAction)prendThystane:(id)sender {
    [self messageSend:@"prend thystame"];
}

- (IBAction)poseNourriture:(id)sender {
    [self messageSend:@"pose nourritue"];
}

- (IBAction)poseLinemate:(id)sender {
    [self messageSend:@"pose linemate"];
}

- (IBAction)poseDeraumere:(id)sender {
    [self messageSend:@"pose deraumere"];
}

- (IBAction)poseSibur:(id)sender {
    [self messageSend:@"pose sibur"];
}

- (IBAction)poseMendiane:(id)sender {
    [self messageSend:@"pose mendiane"];
}

- (IBAction)posePhiras:(id)sender {
    [self messageSend:@"pose phiras"];
}

- (IBAction)poseThystane:(id)sender {
    [self messageSend:@"pose thystame"];
}

- (IBAction)prendDeraumere:(id)sender {
    [self messageSend:@"prend deraumere"];
}

#pragma mark - Managing view

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetAttribute];
    foodButton.layer.cornerRadius = 45;
    foodLayButton.layer.cornerRadius = 45;
    linemateTakeButton.layer.cornerRadius = 45;
    linemateLayButton.layer.cornerRadius = 45;
    deraumereTakeButton.layer.cornerRadius = 45;
    deraumereLayButton.layer.cornerRadius = 45;
    siburTakeButton.layer.cornerRadius = 45;
    siburLayButton.layer.cornerRadius = 45;
    mendianeTakeButton.layer.cornerRadius = 45;
    mendianeLayButton.layer.cornerRadius = 45;
    phirasTakeButton.layer.cornerRadius = 45;
    phirasLayButton.layer.cornerRadius = 45;
    thystameTakeButton.layer.cornerRadius = 45;
    thystameLayButton.layer.cornerRadius = 45;
    layLabel.layer.cornerRadius = 40;
    takeLabel.layer.cornerRadius = 40;
}


- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Player connect to %@:%li", self.connectAddress, (long)self.connectPort);
    [self initNetworkCommunication];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"Closing connection");
    [inputStream close];
    [outputStream close];
}


#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Ok"])
        [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - NSStream Delegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    
    switch (eventCode) {
        case NSStreamEventErrorOccurred :
            NSLog(@"Can't connect to host");
            [self popDisconnectAlert:@"Can't reach host"];
            break;
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream successfully open !");
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"Error encountered");
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [self popDisconnectAlert:@"Connection lost"];
            aStream = nil;
        case NSStreamEventHasBytesAvailable:
            if (aStream == inputStream)
                [self messageReceived];
            break;
        default:
            break;
    }
}


@end
