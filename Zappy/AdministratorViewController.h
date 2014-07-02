//
//  AdministratorViewController.h
//  Zappy
//
//  Created by Charles Fournier on 30/06/2014.
//
//

#import "ViewController.h"

@interface AdministratorViewController : ViewController <NSStreamDelegate, UIAlertViewDelegate>
{
    NSInputStream   *inputStream;
    NSOutputStream  *outputStream;
    NSString        *connectAddress;
    NSInteger       connectPort;
}

@property(nonatomic) NSString *connectAddress;
@property(nonatomic) NSInteger connectPort;

@property(nonatomic, retain) NSInputStream  *inputStream;
@property(nonatomic, retain) NSOutputStream *outputStream;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIImageView *fondImage;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)send:(id)sender;

@end
