package com.kr.mouse_ble;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothHidDevice;
import android.bluetooth.BluetoothHidDeviceAppQosSettings;
import android.bluetooth.BluetoothHidDeviceAppSdpSettings;
import android.bluetooth.BluetoothProfile;
import android.os.Build;
import android.util.Log;

import androidx.annotation.RequiresApi;

import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.Executors;

public class ServiceListenerBle {

    private BluetoothHidDevice hidDevice;
    private final BluetoothHidDeviceAppSdpSettings sdp;
    private final BluetoothHidDeviceAppQosSettings qos;
    private final BluetoothDevice device;
    private final MainActivity mainActivity;
    private Integer count = 0;
    BluetoothProfile.ServiceListener listener;

    public ServiceListenerBle(BluetoothHidDevice hidDevice, BluetoothHidDeviceAppSdpSettings sdp, BluetoothHidDeviceAppQosSettings qos, BluetoothDevice device, MainActivity mainActivity) {
        this.hidDevice = hidDevice;
        this.sdp = sdp;
        this.qos = qos;
        this.device = device;
        this.mainActivity = mainActivity;
    }

    @SuppressLint("NewApi")
    private final BluetoothHidDevice.Callback callback = new BluetoothHidDevice.Callback() {
        @Override
        public void onAppStatusChanged(BluetoothDevice pluggedDevice, boolean registered) {
            super.onAppStatusChanged(pluggedDevice, registered);
        }

        @SuppressLint("MissingPermission")
        @Override
        public void onConnectionStateChanged(BluetoothDevice device, int state) {
            super.onConnectionStateChanged(device, state);

            switch (state) {
                case BluetoothProfile.STATE_CONNECTING:
                    Log.d("ble State: ", "CONNECTING-" + device.getName());
                    break;
                case BluetoothProfile.STATE_CONNECTED:
                    Log.d("ble State: ", "CONNECTED-" + device.getName());
                    break;
                case BluetoothProfile.STATE_DISCONNECTING:
                    Log.d("ble State: ", "DISCONNECTING-" + device.getName());
                    break;
                case BluetoothProfile.STATE_DISCONNECTED:
                    Log.d("ble State: ", "DISCONNECTED-" + device.getName());
                    break;
            }

        }
    };

    public void restartProxy() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            mainActivity.setProxy(getListener());
        }
    }


    BluetoothProfile.ServiceListener getListener() {
        return new BluetoothProfile.ServiceListener() {
            @RequiresApi(api = Build.VERSION_CODES.S)
            @SuppressLint("MissingPermission")
            @Override
            public void onServiceConnected(int i, BluetoothProfile profile) {
                if (i == BluetoothProfile.HID_DEVICE) {
                    hidDevice = (BluetoothHidDevice) profile;
                    mainActivity.setHidDevice(hidDevice);
                }
                boolean isRegist = hidDevice.registerApp(sdp, null, qos, Runnable::run, callback);
                boolean isConn = hidDevice.connect(device);

                if (!isConn && count < 2) {
                    count++;
                    restartProxy();
                    return;
                }
                mainActivity.connRes();
            }

            @Override
            public void onServiceDisconnected(int i) {

            }
        };
    }


}
