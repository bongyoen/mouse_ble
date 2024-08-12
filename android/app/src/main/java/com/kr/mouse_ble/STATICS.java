package com.kr.mouse_ble;

public class STATICS {

    public static class DEVICE {
        public final static String NAME = "name";
        public final static String ADDRESS = "address";
        public final static String ALIAS = "alias";
    }

    public static class HID {
        public final static String NAME = "BTHid";
        public final static String DESCIPTION = "BTMouse";
        public final static String PROVIDER = "Android";
    }

    public static class CHANNEL {
        public final static String MAIN = "com.example.bonded_devices";
        public final static String CONN = "conn";
        public final static String RE_CONN = "reConn";
        public final static String DIS_CONN = "disConn";
        public final static String GETBONDEDDEVICES = "getBondedDevices";
        public final static String MOUSE = "mouse";
    }


}

