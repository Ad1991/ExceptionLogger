//
//  ViewController.m
//  ExceptionLoggerDemo
//
//  Created by Adarsh Kumar Rai on 21/02/18.
//  Copyright © 2018 Personal. All rights reserved.
//

#import "ViewController.h"
#import "ExceptionLogger.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lastexceptionDetail;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [ELExceptionLogger installExceptionLogger];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)generateException:(UIButton *)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select Exception" message:@"Choose the kind of exception" preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Array index out of bound" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [@[] objectAtIndex:1];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Add nil to dictionary" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *nilString;
        __unused id a = @{@"Key": nilString};
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)showLastException:(UIButton *)sender {
    NSString *exceptionDetails = [ELExceptionLogger lastExceptionDetails];
    if (exceptionDetails.length > 0) {
        self.lastexceptionDetail.text = exceptionDetails;
    } else {
        self.lastexceptionDetail.text = @"No exception detail found";
    }
}
@end
