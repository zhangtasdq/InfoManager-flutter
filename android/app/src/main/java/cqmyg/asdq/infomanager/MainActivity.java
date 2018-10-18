package cqmyg.asdq.infomanager;

import android.os.Bundle;

import java.util.ArrayList;

import cqmyg.asdq.infomanager.service.HardwareService;
import cqmyg.asdq.infomanager.service.OneDriveService;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

public class MainActivity extends FlutterActivity {
    private static final String ONE_DRIVE_CHANNEL = "cqmyg.asdq.infomanager.onedrive";
    private static final String HARDWARE_CHANNEL = "cqmyg.asdq.infomanager.hardware";

    private OneDriveService oneDriveService = null;
    private HardwareService hardwareService = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);


        new MethodChannel(getFlutterView(), ONE_DRIVE_CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, Result result) {
                        OneDriveService service = getOneDriveService();

                        String clientId = methodCall.argument("clientId");
                        String fileName = methodCall.argument("fileName");

                        ArrayList<String> scopeList = methodCall.argument("scope");

                        String[] scope = scopeList.toArray(new String[scopeList.size()]);

                        if (methodCall.method.equals("isFileExists")) {
                            service.isFileExists(fileName, clientId, scope,MainActivity.this, result);
                        } else if (methodCall.method.equals("saveFile")) {
                            String content = methodCall.argument("content");
                            service.saveFile(fileName, content, clientId, scope, MainActivity.this, result);
                        } else if (methodCall.method.equals("downloadFile")) {
                            service.downloadFile(fileName, clientId, scope, MainActivity.this, result);
                        } else {
                            result.notImplemented();
                        }
                    }
                }
        );

        new MethodChannel(getFlutterView(), HARDWARE_CHANNEL).setMethodCallHandler(new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, Result result) {
                HardwareService hardwareService = getHardwareService();

                if (methodCall.method.equals("isSupportFingerPrint")) {
                    boolean isSupport = hardwareService.isSupportFingerPrint(MainActivity.this);

                    result.success(isSupport);
                }
            }
        });
    }

    private OneDriveService getOneDriveService() {
        if (oneDriveService == null) {
            oneDriveService = new OneDriveService();
        }
        return oneDriveService;
    }

    private HardwareService getHardwareService() {
        if (hardwareService == null) {
            hardwareService = new HardwareService();
        }
        return hardwareService;
    }
}
