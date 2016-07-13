//
//  MRConfirmationView.m
//
//  Created by Matthew Ricketson on 12/2/11.
//  Copyright (c) 2011 Matthew Ricketson. All rights reserved.
//

#import "MRConfirmationAlertView.h"

#define DEFAULT_CANCEL_TITLE	@"Cancel"
#define DEFAULT_CONFIRM_TITLE	@"OK"


@interface MRConfirmationAlertView () <UIAlertViewDelegate>

@property (nonatomic, copy) MRConfirmationAlertViewCompletion completion;

@end


@implementation MRConfirmationAlertView

#pragma mark - Initialization

+ (instancetype)confirmationAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
	return [self confirmationAlertViewWithTitle:title message:message cancelButton:nil confirmButton:DEFAULT_CONFIRM_TITLE completion:nil];
}

+ (instancetype)confirmationAlertViewWithTitle:(NSString *)title message:(NSString *)message completion:(MRConfirmationAlertViewCompletion)completion
{
	return [self confirmationAlertViewWithTitle:title message:message cancelButton:DEFAULT_CANCEL_TITLE confirmButton:DEFAULT_CONFIRM_TITLE completion:completion];
}

+ (instancetype)confirmationAlertViewWithTitle:(NSString *)title
									   message:(NSString *)message
								  cancelButton:(NSString *)cancelButtonTitle
								 confirmButton:(NSString *)confirmButtonTitle
									completion:(MRConfirmationAlertViewCompletion)completion
{
	return [[self alloc] initWithTitle:title message:message cancelButton:cancelButtonTitle confirmButton:confirmButtonTitle completion:completion];
}


- (instancetype)initWithTitle:(NSString *)title
					  message:(NSString *)message
				 cancelButton:(NSString *)cancelButtonTitle
				confirmButton:(NSString *)confirmButtonTitle
				   completion:(MRConfirmationAlertViewCompletion)completion
{
	self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:confirmButtonTitle, nil];
	if (self) {
		_completion = [completion copy];
	}
	return self;
}


#pragma mark - Convenience Shortcuts

+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message
{
	MRConfirmationAlertView *confirmationView = [self confirmationAlertViewWithTitle:title message:message];
	[confirmationView show];
	return confirmationView;
}

+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message completion:(MRConfirmationAlertViewCompletion)completion
{
	MRConfirmationAlertView *confirmationView = [self confirmationAlertViewWithTitle:title message:message completion:completion];
	[confirmationView show];
	return confirmationView;
}

+ (instancetype)showWithTitle:(NSString *)title
					  message:(NSString *)message
				 cancelButton:(NSString *)cancelButtonTitle
				confirmButton:(NSString *)confirmButtonTitle
				   completion:(MRConfirmationAlertViewCompletion)completion
{
	MRConfirmationAlertView *confirmationView = [self confirmationAlertViewWithTitle:title
																			 message:message
																		cancelButton:cancelButtonTitle
																	   confirmButton:confirmButtonTitle
																		  completion:completion];
	[confirmationView show];
	return confirmationView;
}


#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (self.completion) {
		self.completion((buttonIndex != alertView.cancelButtonIndex));
	}
}

@end
