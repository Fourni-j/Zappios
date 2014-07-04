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
    NSMutableArray *stuff;
    NSMutableArray *stuffRequis;
    int level;
}

@end

@implementation PlayerViewController

@synthesize outputStream, inputStream;
@synthesize connectAddress, connectTeam;
@synthesize connectPort;
@synthesize foodButton, linemateLayButton, linemateTakeButton, foodLayButton, deraumereLayButton, deraumereTakeButton, siburLayButton, siburTakeButton, mendianeLayButton, mendianeTakeButton, phirasLayButton, phirasTakeButton, thystameLayButton, thystameTakeButton;
@synthesize foodLabel, linemateLabel, deraumereLabel, siburLabel, mendianeLabel, phirasLabel, thystameLabel, levelLabel;
@synthesize needDeraumere, needLinemate, needMendiane, needPhiras, needSibur, needThystame, needPlayer;

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
    {
        [self messageSend:connectTeam];
        [self messageSend:@"inventaire"];
    }
    
    else if ([msg isEqualToString:@"mort\n"])
        [self popPlayerEventAlert:@"Mort"];
    
    if ([msg hasPrefix:@"{nourriture"])
    {
        msg = [msg stringByReplacingOccurrencesOfString:@"{" withString:@""];
        msg = [msg stringByReplacingOccurrencesOfString:@"}" withString:@""];
        msg = [msg stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        @try {
            NSMutableArray *inventaire = [[msg componentsSeparatedByString:@", "] mutableCopy];
            for (int i = 0; i < [inventaire count]; i++)
            {
                NSRange range = [inventaire[i] rangeOfString:@" "];
                inventaire[i] = [inventaire[i] substringFromIndex:range.location + 1];
                [stuff addObject:inventaire[i]];
            }
            stuff = inventaire;
            [self updateStuff];
        }
        @catch (NSException *exception) {
            NSLog(@"Server synthax error");
        }

    }
    else if ([msg hasPrefix:@"niveau actuel : "])
    {
        NSRange range = [msg rangeOfString:@": "];
        msg = [msg substringFromIndex:range.location + 2];
        level = msg.intValue;
        [self updateLevel];
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

- (void)updateLevel
{
    levelLabel.text = [NSString stringWithFormat:@"%i", level];
    
    NSString *tmp = stuffRequis[level - 1];
    NSArray *array = [tmp componentsSeparatedByString:@" "];
    needPlayer.text = array[0];
    needLinemate.text = array[1];
    needDeraumere.text = array[2];
    needSibur.text = array[3];
    needMendiane.text = array[4];
    needPhiras.text = array[5];
    needThystame.text = array[6];
}

- (void) updateStuff
{
    foodLabel.text = stuff[0];
    linemateLabel.text = stuff[1];
    deraumereLabel.text = stuff[2];
    siburLabel.text = stuff[3];
    mendianeLabel.text = stuff[4];
    phirasLabel.text = stuff[5];
    thystameLabel.text = stuff[6];
    [stuff removeAllObjects];
}

#pragma mark - Action buttons

- (IBAction)avance:(UIButton *)sender {
    [self messageSend:@"avance"];
    [self messageSend:@"inventaire"];
}

- (IBAction)turnLeft:(id)sender {
    [self messageSend:@"gauche"];
}

- (IBAction)turnRight:(id)sender {
    [self messageSend:@"droite"];
}

- (IBAction)incantation:(id)sender {
    [self messageSend:@"incantation"];
    [self messageSend:@"inventaire"];
}

- (IBAction)prendNourriture:(id)sender {
    [self messageSend:@"prend nourriture"];
    [self messageSend:@"inventaire"];
}

- (IBAction)prendLinemate:(id)sender {
    [self messageSend:@"prend linemate"];
    [self messageSend:@"inventaire"];
}

- (IBAction)prendSibur:(id)sender {
    [self messageSend:@"prend sibur"];
    [self messageSend:@"inventaire"];
}

- (IBAction)prendMendiane:(id)sender {
    [self messageSend:@"prend mendiane"];
    [self messageSend:@"inventaire"];
}

- (IBAction)prendPhiras:(id)sender {
    [self messageSend:@"prend phiras"];
    [self messageSend:@"inventaire"];
}

- (IBAction)prendThystane:(id)sender {
    [self messageSend:@"prend thystame"];
    [self messageSend:@"inventaire"];
}

- (IBAction)poseNourriture:(id)sender {
    [self messageSend:@"pose nourritue"];
    [self messageSend:@"inventaire"];
}

- (IBAction)poseLinemate:(id)sender {
    [self messageSend:@"pose linemate"];
    [self messageSend:@"inventaire"];
}

- (IBAction)poseDeraumere:(id)sender {
    [self messageSend:@"pose deraumere"];
    [self messageSend:@"inventaire"];
}

- (IBAction)poseSibur:(id)sender {
    [self messageSend:@"pose sibur"];
    [self messageSend:@"inventaire"];
}

- (IBAction)poseMendiane:(id)sender {
    [self messageSend:@"pose mendiane"];
    [self messageSend:@"inventaire"];
}

- (IBAction)posePhiras:(id)sender {
    [self messageSend:@"pose phiras"];
    [self messageSend:@"inventaire"];
}

- (IBAction)poseThystane:(id)sender {
    [self messageSend:@"pose thystame"];
    [self messageSend:@"inventaire"];
}

- (IBAction)prendDeraumere:(id)sender {
    [self messageSend:@"prend deraumere"];
    [self messageSend:@"inventaire"];
}

#pragma mark - Managing view

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    foodLabel.layer.cornerRadius = 45;
    linemateLabel.layer.cornerRadius = 45;
    deraumereLabel.layer.cornerRadius = 45;
    siburLabel.layer.cornerRadius = 45;
    mendianeLabel.layer.cornerRadius = 45;
    phirasLabel.layer.cornerRadius = 45;
    thystameLabel.layer.cornerRadius = 45;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    for (int i = 0; i < 8; i++)
        [stuff addObject:@"0"];
  
    NSString *level1 = @"1 1 0 0 0 0 0";
    NSString *level2 = @"2 1 1 1 0 0 0";
    NSString *level3 = @"2 2 0 1 0 2 0";
    NSString *level4 = @"4 1 1 2 0 1 0";
    NSString *level5 = @"4 1 2 1 3 0 0";
    NSString *level6 = @"6 1 2 3 0 1 0";
    NSString *level7 = @"6 2 2 2 2 2 1";
    NSString *level8 = @"0 0 0 0 0 0 0";
    stuffRequis = [[NSMutableArray alloc] init];
    [stuffRequis addObject:level1];
    [stuffRequis addObject:level2];
    [stuffRequis addObject:level3];
    [stuffRequis addObject:level4];
    [stuffRequis addObject:level5];
    [stuffRequis addObject:level6];
    [stuffRequis addObject:level7];
    [stuffRequis addObject:level8];
    
    level = 1;
    
    NSString *tmp = stuffRequis[level - 1];
    NSArray *array = [tmp componentsSeparatedByString:@" "];
    NSLog(@"Requis : %@", stuffRequis);
    needPlayer.text = array[0];
    needLinemate.text = array[1];
    needDeraumere.text = array[2];
    needSibur.text = array[3];
    needMendiane.text = array[4];
    needPhiras.text = array[5];
    needThystame.text = array[6];

    
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
