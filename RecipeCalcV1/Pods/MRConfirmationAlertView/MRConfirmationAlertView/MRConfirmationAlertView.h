//
//  MRConfirmationAlertView.h
//
//  Created by Matthew Ricketson on 12/2/11.
//  Copyright (c) 2011 Matthew Ricketson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MRConfirmationAlertViewCompletion)(BOOL confirmed);


/**
 `MRConfirmationAlertView` is a convenience subclass of `UIAlertView` that quickly and simply presents information to a user and optionally asks for their confirmation.
 */
@interface MRConfirmationAlertView : UIAlertView

///---------------------
/// @name Initialization
///---------------------

/**
 Creates a new `MRConfirmationAlertView` instance with a title, message, and confirmation button.
 
 @discussion
 This constructor creates an alert view with only a confirmation button, not a cancelation button. To present with a cancelation button, use `+confirmationAlertViewWithTitle:message:completion:`. For complete control of the appearance of the alert view, use `+confirmationAlertViewWithTitle:message:cancelButton:confirmButton:completion:`.
 
 @param title The title of alert view.
 @param message The message of the alert view.
 
 @return A new `MRConfirmationAlertView` instance.
 
 @see +confirmationAlertViewWithTitle:message:completion:
 @see +confirmationAlertViewWithTitle:message:cancelButton:confirmButton:completion:
 */
+ (instancetype)confirmationAlertViewWithTitle:(NSString *)title message:(NSString *)message;

/**
 Creates a new `MRConfirmationAlertView` instance with a title, message, confirmation button, and cancelation button.
 
 @discussion
 This constructor creates an alert view with a confirmation and cancelation button. To present without a cancelation button, use `+confirmationAlertViewWithTitle:message:`. For complete control of the appearance of the alert view, use `+confirmationAlertViewWithTitle:message:cancelButton:confirmButton:completion:`.
 
 @param title The title of alert view.
 @param message The message of the alert view.
 @param completion The completion block called when the user taps on either the confirmation or cancelation buttons.
 
 @return A new `MRConfirmationAlertView` instance.
 
 @see +confirmationAlertViewWithTitle:message:
 @see +confirmationAlertViewWithTitle:message:completion:
 */
+ (instancetype)confirmationAlertViewWithTitle:(NSString *)title message:(NSString *)message completion:(MRConfirmationAlertViewCompletion)completion;

/**
 Creates a new `MRConfirmationAlertView` instance with a title, message, confirmation button, and cancelation button.
 
 @param title The title of alert view.
 @param message The message of the alert view.
 @param cancelButton The title used for the cancelation button. If nil, then no cancelation button is presented.
 @param confirmButton The title used for the confirmation button. If nil, then no confirmation button is presented.
 @param completion The completion block called when the user taps on either the confirmation or cancelation buttons.
 
 @return A new `MRConfirmationAlertView` instance.
 
 @see +confirmationAlertViewWithTitle:message:
 @see +confirmationAlertViewWithTitle:message:completion:
 */
+ (instancetype)confirmationAlertViewWithTitle:(NSString *)title
									   message:(NSString *)message
								  cancelButton:(NSString *)cancelButtonTitle
								 confirmButton:(NSString *)confirmButtonTitle
									completion:(MRConfirmationAlertViewCompletion)completion;


///---------------------------------------------------
/// @name Showing Confirmation Alert Views Immediately
///---------------------------------------------------

/**
 Creates and then presents a new `MRConfirmationAlertView` instance with a title, message, and confirmation button.
 
 @discussion
 See `+confirmationAlertViewWithTitle:message:` for details.
 
 @param title The title of alert view.
 @param message The message of the alert view.
 
 @return A new `MRConfirmationAlertView` instance that has been presented.
 
 @see +confirmationAlertViewWithTitle:message:
 */
+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message;

/**
 Creates and then presents a new `MRConfirmationAlertView` instance with a title, message, confirmation button, and cancelation button.
 
 @discussion
 See `+confirmationAlertViewWithTitle:message:completion:` for details.
 
 @param title The title of alert view.
 @param message The message of the alert view.
 @param completion The completion block called when the user taps on either the confirmation or cancelation buttons.
 
 @return A new `MRConfirmationAlertView` instance that has been presented.
 
 @see +confirmationAlertViewWithTitle:message:completion:
 */
+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message completion:(MRConfirmationAlertViewCompletion)completion;

/**
 Creates and then presents a new `MRConfirmationAlertView` instance with a title, message, confirmation button, and cancelation button.
 
 @discussion
 See `+confirmationAlertViewWithTitle:message:cancelButton:confirmButton:completion:` for details.
 
 @param title The title of alert view.
 @param message The message of the alert view.
 @param cancelButton The title used for the cancelation button. If nil, then no cancelation button is presented.
 @param confirmButton The title used for the confirmation button. If nil, then no confirmation button is presented.
 @param completion The completion block called when the user taps on either the confirmation or cancelation buttons.
 
 @return A new `MRConfirmationAlertView` instance that has been presented.
 
 @see +confirmationAlertViewWithTitle:message:cancelButton:confirmButton:completion:
 */
+ (instancetype)showWithTitle:(NSString *)title
					  message:(NSString *)message
				 cancelButton:(NSString *)cancelButtonTitle
				confirmButton:(NSString *)confirmButtonTitle
				   completion:(MRConfirmationAlertViewCompletion)completion;

@end
