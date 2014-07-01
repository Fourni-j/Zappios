//
//  PlayerViewController.h
//  Zappy
//
//  Created by Charles Fournier on 30/06/2014.
//
//

#import "ViewController.h"

@interface PlayerViewController : ViewController <NSStreamDelegate, UIAlertViewDelegate>
{
    NSInputStream   *inputStream;
    NSOutputStream  *outputStream;
    NSString        *connectAddress;
    NSInteger       connectPort;
    NSMutableArray  *messages;
}

@property (nonatomic, retain) NSInputStream     *inputStream;
@property (nonatomic, retain) NSOutputStream    *outputStream;

@property(nonatomic, strong) NSString *connectAddress;
@property(nonatomic) NSInteger connectPort;
@property(nonatomic, retain) NSMutableArray *message;

@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UIButton *linemateTakeButton;
@property (weak, nonatomic) IBOutlet UIButton *deraumereTakeButton;
@property (weak, nonatomic) IBOutlet UIButton *siburTakeButton;
@property (weak, nonatomic) IBOutlet UIButton *mendianeTakeButton;
@property (weak, nonatomic) IBOutlet UIButton *phirasTakeButton;
@property (weak, nonatomic) IBOutlet UIButton *thystameTakeButton;

@property (weak, nonatomic) IBOutlet UIButton *foodLayButton;
@property (weak, nonatomic) IBOutlet UIButton *linemateLayButton;
@property (weak, nonatomic) IBOutlet UIButton *deraumereLayButton;
@property (weak, nonatomic) IBOutlet UIButton *siburLayButton;
@property (weak, nonatomic) IBOutlet UIButton *mendianeLayButton;
@property (weak, nonatomic) IBOutlet UIButton *phirasLayButton;
@property (weak, nonatomic) IBOutlet UIButton *thystameLayButton;

@property (weak, nonatomic) IBOutlet UILabel *layLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeLabel;

- (IBAction)avance:(UIButton *)sender;
- (IBAction)turnLeft:(id)sender;
- (IBAction)turnRight:(id)sender;
- (IBAction)incantation:(id)sender;

- (IBAction)prendNourriture:(id)sender;
- (IBAction)prendLinemate:(id)sender;
- (IBAction)prendDeraumere:(id)sender;
- (IBAction)prendSibur:(id)sender;
- (IBAction)prendMendiane:(id)sender;
- (IBAction)prendPhiras:(id)sender;
- (IBAction)prendThystane:(id)sender;

- (IBAction)poseNourriture:(id)sender;
- (IBAction)poseLinemate:(id)sender;
- (IBAction)poseDeraumere:(id)sender;
- (IBAction)poseSibur:(id)sender;
- (IBAction)poseMendiane:(id)sender;
- (IBAction)posePhiras:(id)sender;
- (IBAction)poseThystane:(id)sender;


@end
