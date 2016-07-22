MRConfirmationAlertView
=======================

**A block-based, lightweight `UIAlertView` subclass for requesting user confirmation.**

[`UIAlertView`](https://developer.apple.com/library/ios/documentation/uikit/reference/UIAlertView_Class/UIAlertView/UIAlertView.html) is a great way to quickly present information to the user and get a response, without having to write much code. It is especially useful early in development as a placeholder for more sophisticated user interface elements to be built down the road. However, 99% of situations where I use `UIAlertView` boil down to two use cases:

1. Let the user know something has happened, and then tap "OK" to dismiss.
2. Ask the user permission to do something, and then proceed based on whether they tapped "OK" or "cancel".

`MRConfirmationAlertView` is a convenience subclass of `UIAlertView` that optimizes for these two use cases and requires as little code as possible. It is *not* intended as a complete replacement for `UIAlertView`.

## Usage

Let's check out those use cases again, this time with some code examples:

1. Let the user know something has happened, and then tap "OK" to dismiss.

```objective-c
[MRConfirmationAlertView showWithTitle:@"Hello" message:@"Something happened. Just letting you know."];
```

2. Ask the user permission to do something, and then proceed based on whether they tapped "OK" or "cancel".

```objective-c
[MRConfirmationAlertView showWithTitle:@"Hello" message:@"Do I have permission to do X?" completion:^(BOOL confirmed) {
    if (confirmed) {
        // Proceed with task
    } else {
        // Nevermind
    }
}];
```

By default, the cancel and confirm buttons say "Cancel" and "OK" respectively, since in most cases this is all you need. However, if you want to customize the buttons, or anything else, use the extended constructor:

```objective-c
[MRConfirmationAlertView showWithTitle:@"Hello" message:@"How are you today?" cancelButton:@"Terrible" confirmButton:@"Great!" completion:^(BOOL confirmed) {
    if (confirmed) {
        [MRConfirmationAlertView showWithTitle:@"Glad to hear it!" message:nil];
    } else {
        [MRConfirmationAlertView showWithTitle:@"Oh no!" message:nil];
    }
}];
```

Check out the documentation in `MRConfirmationAlertView.h` for full details.

## License

`MRConfirmationAlertView` is available under the MIT license. See the LICENSE file for more info.
