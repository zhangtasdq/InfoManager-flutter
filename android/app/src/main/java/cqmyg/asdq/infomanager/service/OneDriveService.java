package cqmyg.asdq.infomanager.service;

import android.app.Activity;

import com.onedrive.sdk.authentication.MSAAuthenticator;
import com.onedrive.sdk.concurrency.ICallback;
import com.onedrive.sdk.core.ClientException;
import com.onedrive.sdk.core.DefaultClientConfig;
import com.onedrive.sdk.core.IClientConfig;
import com.onedrive.sdk.extensions.IOneDriveClient;
import com.onedrive.sdk.extensions.ISearchCollectionPage;
import com.onedrive.sdk.extensions.OneDriveClient;
import com.onedrive.sdk.logger.LoggerLevel;

import io.flutter.plugin.common.MethodChannel.Result;

public class OneDriveService {
    private IOneDriveClient oneDriveClient = null;

    private IClientConfig createConfig(final String clientId, final String[] scope) {
        final MSAAuthenticator authenticator = new MSAAuthenticator() {
            @Override
            public String getClientId() {
                return clientId;
            }

            @Override
            public String[] getScopes() {
                return scope;
            }
        };

        final IClientConfig config = DefaultClientConfig.createWithAuthenticator(authenticator);
        config.getLogger().setLoggingLevel(LoggerLevel.Debug);

        return config;
    }

       private void getOneDriveClient(String clientId, String[] scopes, Activity activity, final ICallback<Void> callback) {
        if (this.oneDriveClient == null) {
            final ICallback<IOneDriveClient> authCallback = new ICallback<IOneDriveClient>() {
                @Override
                public void success(IOneDriveClient iOneDriveClient) {
                    oneDriveClient = iOneDriveClient;
                    callback.success(null);
                }

                @Override
                public void failure(ClientException ex) {
                    callback.failure(ex);
                }
            };

            new OneDriveClient.
                    Builder().
                    fromConfig(this.createConfig(clientId, scopes)).
                    loginAndBuildClient(activity, authCallback);
        } else {
            callback.success(null);
        }
    }


    public void isFileExists(final String fileName, String clientId, String[] oneDriveScope, Activity activity, final Result callback) {
        this.getOneDriveClient(clientId, oneDriveScope, activity, new ICallback<Void>() {
            @Override
            public void success(Void aVoid) {
                IOneDriveClient client = OneDriveService.this.oneDriveClient;

                client.getDrive().
                    getSpecial("approot").
                    getSearch(fileName).
                    buildRequest().
                    get(new ICallback<ISearchCollectionPage>() {
                        @Override
                        public void success(ISearchCollectionPage iSearchCollectionPage) {
                            boolean isFileExists = !iSearchCollectionPage.getCurrentPage().isEmpty();


                            callback.success(isFileExists);
                        }

                        @Override
                        public void failure(ClientException ex) {
                            callback.error("onedriveError", "get file error", ex);
                            ex.printStackTrace();
                        }
                    });
            }
            @Override
            public void failure(ClientException ex) {
                callback.error("onedriveError", "auth error", ex);
                ex.printStackTrace();
            }
        });
    }
}
