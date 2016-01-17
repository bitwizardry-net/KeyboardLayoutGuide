# KeyboardLayoutGuide

Did you ever wonder why the bottom layout guide is never moved to refelct the new bottom of the view when the iOS keyboard is shown? Or at least why isn't there a separate keyboard layout guide? Same here.

There are several other solutions out there which handle this problem by putting your views in a scroll view or by modifying the frame of the root view. 

This solution is more fine granular and works well with interface builder and storyboards. You just add the keyboard layout guide view (KBLGV) to your existing view and then make constraints between your views and the KBLGV. The KBLGV animates up and down together with your connected views during iOS keyboard events.

If you add the KBLGV prorammatically to your view, then all needed constraints to put the KBLGV at the bottom of your view are added automatically. If you want to use it inside interface builder, then you have to add the left-right-bottom constraints and a 0px height constraint on your own.

