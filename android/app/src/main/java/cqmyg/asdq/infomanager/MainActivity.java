package cqmyg.asdq.infomanager;

import android.os.Bundle;

import java.util.ArrayList;

import cqmyg.asdq.infomanager.service.OneDriveService;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "cqmyg.asdq.infomanager.onedrive";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);


        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, Result result) {
                        OneDriveService service = new OneDriveService();
                        String clientId = methodCall.argument("clientId");
                        ArrayList<String> scopeList = methodCall.argument("scope");

                        String[] scope = scopeList.toArray(new String[scopeList.size()]);

                        if (methodCall.method.equals("isFileExists")) {
                            String fileName = methodCall.argument("fileName");

                            service.isFileExists(fileName, clientId, scope,MainActivity.this, result);
                        } else {
                            result.notImplemented();
                        }
                    }
                }
        );
    }
}
