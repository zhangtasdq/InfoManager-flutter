package cqmyg.asdq.infomanager.service;

import android.app.Activity;
import android.os.AsyncTask;

import com.onedrive.sdk.authentication.MSAAuthenticator;
import com.onedrive.sdk.concurrency.ICallback;
import com.onedrive.sdk.concurrency.IProgressCallback;
import com.onedrive.sdk.core.ClientException;
import com.onedrive.sdk.core.DefaultClientConfig;
import com.onedrive.sdk.core.IClientConfig;
import com.onedrive.sdk.extensions.IOneDriveClient;
import com.onedrive.sdk.extensions.ISearchCollectionPage;
import com.onedrive.sdk.extensions.Item;
import com.onedrive.sdk.extensions.OneDriveClient;
import com.onedrive.sdk.logger.LoggerLevel;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

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
                            callback.error("OneDriveError", "get file error", ex);
                            ex.printStackTrace();
                        }
                    });
            }
            @Override
            public void failure(ClientException ex) {
                callback.error("OneDriveError", "auth error", ex);
                ex.printStackTrace();
            }
        });
    }

    public void saveFile(final String fileName, final String content, String clientId,
                         String[] oneDriveScope, Activity activity, final Result callback) {
        final IProgressCallback<Item> saveCallback = new IProgressCallback<Item>() {
            @Override
            public void progress(long current, long max) {
            }

            @Override
            public void success(Item item) {
                callback.success(true);
            }

            @Override
            public void failure(ClientException ex) {
                callback.error("OneDriveError", ex.getMessage(), ex);
                ex.printStackTrace();
            }
        };

        this.getOneDriveClient(clientId, oneDriveScope, activity, new ICallback<Void>() {
            @Override
            public void success(Void aVoid) {
                IOneDriveClient client = OneDriveService.this.oneDriveClient;
                byte[] contentByte = content.getBytes();

                client.getDrive().
                        getSpecial("approot").
                        getChildren().
                        byId(fileName).
                        getContent().
                        buildRequest().
                        put(contentByte, saveCallback);
            }

            @Override
            public void failure(ClientException ex) {
                callback.error("OneDriveError", ex.getMessage(), ex);
                ex.printStackTrace();
            }
        });
    }

    public void downloadFile(final String fileName, String clientId, String[] oneDriveScope,
                             Activity activity, final Result callback) {
        this.getOneDriveClient(clientId, oneDriveScope, activity, new ICallback<Void>() {
            @Override
            public void success(Void aVoid) {
                AsyncTask<Void, Void, Void> task = new DownloadTask(OneDriveService.this.oneDriveClient, fileName, callback);

                task.execute();
            }

            @Override
            public void failure(ClientException ex) {
                callback.error("OneDriveError", ex.getMessage(), ex);
                ex.printStackTrace();
            }
        });
    }

    private static class DownloadTask extends AsyncTask<Void, Void, Void> {
        IOneDriveClient client;
        String fileName;
        Result callback;

        DownloadTask(IOneDriveClient client, String fileName, Result callback) {
            this.client = client;
            this.fileName = fileName;
            this.callback = callback;
        }

        @Override
        protected Void doInBackground(Void... voids) {
            try {
                final InputStream inputStream = this.client.getDrive().
                        getSpecial("approot").
                        getChildren().
                        byId(fileName).
                        getContent().
                        buildRequest().
                        get();

                byte[] buffer = new byte[1024];
                int len = 0;
                ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

                while((len = inputStream.read(buffer)) != -1) {
                    byteArrayOutputStream.write(buffer, 0, len);
                }

                inputStream.close();
                byteArrayOutputStream.close();

                String data = byteArrayOutputStream.toString();
                callback.success(data);
            } catch (IOException e) {
                callback.error("OneDriveError", e.getMessage(), e);
                e.printStackTrace();
            }
            return null;
        }
    }

}
