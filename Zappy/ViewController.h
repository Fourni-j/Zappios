//
//  ViewController.h
//  Zappy
//
//  Created by Charles Fournier on 30/06/2014.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *portField;
@property (weak, nonatomic) IBOutlet UITextField *teamField;

@property (weak, nonatomic) IBOutlet UIButton *adminButton;
@property (weak, nonatomic) IBOutlet UIButton *playerButton;

- (IBAction)ConnectAdmin:(id)sender;
- (IBAction)ConnectPlayer:(id)sender;

@end
