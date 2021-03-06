package {

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.InvokeEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.utils.setTimeout;

public class Main extends Sprite {

    private static const DEVELOPER_KEY:String = "2MUJ9GP6pVoMU4c76jqiuA";//"your_developer_key";
    private static const APP_ID:String = "201420144";//"your_app_id";
    private static const USER_ID:String = "orenorensdfasdfasdf";//"your_user_id";

    private static var appsFlyer:AppsFlyerInterface;

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, invokeHandler)
    }

    private function invokeHandler(event:InvokeEvent):void {
        if(event.arguments && event.arguments.length) {
            log("\n!!!!!!!!!!!!!!! " + " invokeHandler " + event.reason + "\n arguments: " + event.arguments[0]);
        }
    }
    private var logField:TextField;

    public function createButton(label:String):Sprite {
        var s:Sprite = new Sprite();

        s.graphics.lineStyle(1, 0x0000FF);
        s.graphics.beginFill(0x222222, 1);
        s.graphics.drawRoundRect(0, 0, stage.stageWidth * 0.17, stage.stageHeight * 0.05, 7, 7);
        s.graphics.endFill();

        var t:TextField = new TextField();
        t.text = label;

        var tf:TextFormat = t.defaultTextFormat;
        tf.size = int(stage.stageWidth / 42);
        tf.font = "Helvetica";
        tf.align = TextFormatAlign.CENTER;
        t.setTextFormat(tf);

        t.textColor = 0xFFFFFF;
        t.selectable = false;
        t.mouseEnabled = false;
        t.width = s.width * 0.95;
        t.height = s.height;
        t.x = (s.width * 0.020);
        t.y = (s.height * 0.5) - (t.textHeight * 0.5);

        s.addChild(t);

        return s;
    }

    private function log(s:String):void {
        logField.appendText(s);
    }

    private function createUI():void {
        logField = new TextField();
        var tf:TextFormat = logField.defaultTextFormat;
        tf.size = int(stage.stageWidth / 42);
        tf.align = TextFormatAlign.CENTER;
        logField.setTextFormat(tf);
        logField.y = 80;

        logField.textColor = 0x000000;
        logField.selectable = false;
        logField.mouseEnabled = false;
        logField.width = stage.stageWidth - 20;
        logField.height = stage.stageHeight - 20;
        logField.x = 10;
        logField.y = 10;
        addChild(logField);

        var b:Sprite = createButton("Test");
        b.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            sendJSON();
            getConversionData();
            setTimeout(function():void {
                log("\nAdvertiserId: " + appsFlyer.getAdvertiserId());
                log("\nAdvertiserId enabled: " + appsFlyer.getAdvertiserIdEnabled());
            }, 1000)
        });
        addChild(b);
    }

    private function sendJSON():void {
        var param:String = "Deposit";
        var value:String = '{"amount":10, "FTDLevel":"-"}';
        appsFlyer.trackEvent(param, value);
        log("\n-- Call sendTrackingWithValues: '" + param + "' with value '" + value + "' --");
    }

    private function getConversionData():void {
        appsFlyer.getConversionData();
        log("\n-- Call getConversionData --");
    }

    private function onAddedToStage(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        createUI();

        appsFlyer = new AppsFlyerInterface();

        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_DATA_LOADED, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.CURRENT_ATTRIBUTION_DATA_LOADED, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_FAILED, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.ATTRIBUTION_FAILURE, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.APP_OPEN_ATTRIBUTION, eventHandler);

        appsFlyer.setDebug(true);
        appsFlyer.setDeveloperKey(DEVELOPER_KEY, APP_ID); // first param is developer key and second (NA for Android)is Apple app id.
        appsFlyer.setGCMProjectID("11234");
        appsFlyer.trackAppLaunch();
        appsFlyer.registerConversionListener();
        appsFlyer.setAppUserId(USER_ID);
        appsFlyer.setCurrency("EUR");
        appsFlyer.setCollectAndroidID(true);
        appsFlyer.setCollectIMEI(true);
        log("ANE initialized! \nDeveloper key: " + DEVELOPER_KEY + "\nApple AppID: " + APP_ID);
        log("\nApp user id set to: " + USER_ID);
        log("\nAppsFlyer UID: " + appsFlyer.getAppsFlyerUID());
    }

    private function eventHandler(event:AppsFlyerEvent):void {
        log("\n-- Event: " + event.type + "; \nData: " + event.data + " \n");
    }
}
}
