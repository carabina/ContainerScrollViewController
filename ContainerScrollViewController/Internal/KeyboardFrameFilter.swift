//
//  KeyboardFrameFilter.swift
//  ContainerScrollViewController
//
//  Created by Drew Olbrich on 12/26/18.
//  Copyright © 2018 Drew Olbrich. All rights reserved.
//

import UIKit

/// An object that applies a temporal filter to keyboard's frame (later used to
/// control ContainerScrollViewController additional safe area inset), filtering out
/// rapid sequences of adjustments to avoid animation artifacts.
///
/// When a text field becomes the first responder, UIKit presents the keyboard. If
/// the user taps on another text field, changing the first responder, UIKit may
/// adjust the keyboard's height if an input accessory view is specified. Often,
/// these changes will generate a sequence of `keyboardWillShow` notifications, each
/// with different keyboard heights.
///
/// As an extreme example, if the user populates a text field by tapping on an
/// AutoFill input accessory view, and this action causes a password text field to
/// automatically become the first responder, one `keyboardWillHide` notifications
/// and two `keyboardWillShow` notifications will be posted within the span of 0.1
/// seconds.
///
/// If `KeyboardObserver` were to respond to each of these notifications
/// individually, this would cause awkward discontinuities in our scroll view
/// animation that accompanies changes to the keyboard's height.
///
/// To work around this issue, `KeyboardFrameFilter` filters out sequences of
/// notifications that occur within a small time window, acting only on the final
/// assigned keyboard frame in the sequence.
class KeyboardFrameFilter {

    /// The delay before a change to `keyboardFrame` will result in a corresponding
    /// change to `presentationKeyboardFrame`.
    var delay: TimeInterval = 0.15

    /// The delegate that is called when `presentationKeyboardFrame` changes.
    private weak var delegate: KeyboardFrameFilterDelegate?

    /// The additional keyboard frame that `KeyboardObserver` applies to the scroll view
    /// to account for the keyboard. When this value changes, the delegate's
    /// `keyboardAdjustmentFilter(_:didChangeKeyboardFrame:)` is called after a short
    /// delay. Repeated changes to `keyboardFrame` that occur within this period are
    /// collapsed, resulting in a single delegate call.
    var keyboardFrame: CGRect? {
        didSet {
            if keyboardFrame != oldValue {
                startTimer()
            }
        }
    }

    /// The final keyboard frame that should be presented to the user, after temporal
    /// filtering has been applied. This is the value reported by the last
    /// `keyboardAdjustmentFilter(_:didChangeKeyboardFrame:)` delegate call.
    public private(set) var presentationKeyboardFrame: CGRect? {
        didSet {
            self.delegate?.keyboardAdjustmentFilter(self, didChangeKeyboardFrame: self.presentationKeyboardFrame)
        }
    }

    /// The timer used to apply the temporal filter.
    private var timer: Timer?

    init(delegate: KeyboardFrameFilterDelegate) {
        self.delegate = delegate
    }

    deinit {
        cancel()
    }

    func cancel() {
        timer?.invalidate()
    }

    func flush() {
        timer?.fire()
    }

    /// Starts the timer that filters changes to the scroll view's keyboard frame.
    private func startTimer() {
        cancel()

        let timer = Timer(timeInterval: delay, repeats: false, block: { [weak self] (timer: Timer) in
            guard let self = self else {
                return
            }
            self.timer = nil
            self.presentationKeyboardFrame = self.keyboardFrame
        })

        self.timer = timer

        // We use RunLoop.Mode.common instead of the default run loop mode, because
        // otherwise the timer will not fire while the scroll view is scrolling, which will
        // be the case when the user swipes to dismiss the keyboard when the scroll view's
        // keyboardDismissMode is set to interactive, in which case the keyboard frame will
        // be adjusted by KeyboardObserver only after an extended delay.
        RunLoop.current.add(timer, forMode: .common)
    }

}
