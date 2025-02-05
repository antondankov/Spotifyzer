
import Toybox.Communications;

//! Handles the completion of communication operations
class CommListener extends Communications.ConnectionListener {
    //! Constructor
    public function initialize() {
        Communications.ConnectionListener.initialize();
    }

    //! Handle a communications operation completing
    public function onComplete() as Void {
        // System.println("Transmit Complete");
    }

    //! Handle a communications operation erroring
    public function onError() as Void {
        // System.println("Transmit Failed");
    }
}