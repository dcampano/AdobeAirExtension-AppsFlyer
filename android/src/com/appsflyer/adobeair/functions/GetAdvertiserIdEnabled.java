package com.appsflyer.adobeair.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerProperties;
import com.appsflyer.ServerParameters;

public class GetAdvertiserIdEnabled implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        FREObject result = null;
        try {
            result = FREObject.newObject(AppsFlyerProperties.getInstance().getBoolean(ServerParameters.ADVERTISING_ID_ENABLED_PARAM, false));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
