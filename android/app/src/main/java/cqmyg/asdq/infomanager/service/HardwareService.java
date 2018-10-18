package cqmyg.asdq.infomanager.service;

import android.app.Activity;
import android.content.Context;
import android.hardware.fingerprint.FingerprintManager;
import android.os.Build;

public class HardwareService {
    public boolean isSupportFingerPrint(Activity activity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            FingerprintManager fingerprintManager = (FingerprintManager) activity.getSystemService(Context.FINGERPRINT_SERVICE);

            if (!fingerprintManager.isHardwareDetected() || !fingerprintManager.hasEnrolledFingerprints()){
                return false;
            }
            return true;
        }
        return false;
    }
}
