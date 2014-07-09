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

@synthesize connectAddress, connectPort, inputStream, outputStream, inputField, sendButton, fondImage, textView;

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
    
    sendButton.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self initNetworkCommunication];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.view endEditing:YES];
}


#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = inputField.frame;
        CGRect  fb = sendButton.frame;
        CGRect fi = fondImage.frame;
        CGRect ft = textView.frame;
        f.origin.y = 380.0f;
        fb.origin.y = 380.0f;
        fi.origin.y = 372.0f;
        ft.size.height = 340.0f;
        inputField.frame = f;
        sendButton.frame = fb;
        fondImage.frame = fi;
        textView.frame = ft;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = inputField.frame;
        CGRect  fb = sendButton.frame;
        CGRect fi = fondImage.frame;
        CGRect ft = textView.frame;
        fb.origin.y = 729.0f;
        f.origin.y = 729.0f;
        fi.origin.y = 721.0f;
        ft.size.height =  690.0f;
        inputField.frame = f;
        sendButton.frame = fb;
        fondImage.frame = fi;
        textView.frame = ft;
    }];
}

- (void)initNetworkCommunication
{
    NSLog(@"%@:%li", self.connectAddress, (long)self.connectPort);
    
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
 
    
    [self messageSend:@"ADMIN"];
}

- (void)checkExpression:(NSString *)msg
{

}

- (void)addToTextView:(NSString *)sender withMsg:(NSString *)text
{
    if ([textView.text isEqualToString:@""])
        textView.text = [NSString stringWithFormat:@"\n%@%@", sender, text];
    else
        textView.text = [NSString stringWithFormat:@"%@%@%@", textView.text, sender, text];
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
                [self addToTextView:@"Server~>\n" withMsg:output];
            }
        }
    }
}

- (void)messageSend:(NSString *)msg
{
    if ([msg isEqualToString:@""])
        return;
    NSString *response = [NSString stringWithFormat:@"%@\n", msg];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    [self addToTextView:@"Admin~>" withMsg:response];
    inputField.text = @"";
    NSLog(@"Message sent : %@", response);
}

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

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Ok"])
        [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Network Delegate

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

#pragma mark - Action Function

- (IBAction)send:(id)sender {
    [self messageSend:inputField.text];
}
@end
