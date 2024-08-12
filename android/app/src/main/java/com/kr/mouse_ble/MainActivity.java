package com.kr.mouse_ble;

import android.Manifest;
import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothHidDevice;
import android.bluetooth.BluetoothHidDeviceAppQosSettings;
import android.bluetooth.BluetoothHidDeviceAppSdpSettings;
import android.bluetooth.BluetoothProfile;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;
import android.view.KeyEvent;

import androidx.annotation.MainThread;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.util.*;

import static android.view.KeyEvent.KEYCODE_VOLUME_DOWN;
import static android.view.KeyEvent.KEYCODE_VOLUME_UP;

@RequiresApi(api = Build.VERSION_CODES.S)
public class MainActivity extends FlutterActivity {

    private BluetoothHidDevice hidDevice;
    private final BluetoothAdapter proxyadapter = BluetoothAdapter.getDefaultAdapter();

    BluetoothProfile.ServiceListener listener;

    private BluetoothDevice device;

    private Set<BluetoothDevice> devices;

    private MethodChannel.Result connRes;
    private final BluetoothHidDeviceAppSdpSettings sdp = new BluetoothHidDeviceAppSdpSettings(
            STATICS.HID.NAME,
            STATICS.HID.DESCIPTION,
            STATICS.HID.PROVIDER,
            BluetoothHidDevice.SUBCLASS1_COMBO,
            MouseDescriptor.descriptor
    );

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KEYCODE_VOLUME_UP) {
            mouse(0.0, 0.0, 0.0, 5.0);
            return true;
        } else if (keyCode == KEYCODE_VOLUME_DOWN) {
            mouse(0.0, 0.0, 0.0, -5.0);
            return true;
        }
//        return super.onKeyDown(keyCode, event);
        return false;
    }

    private final BluetoothHidDeviceAppQosSettings qos = new BluetoothHidDeviceAppQosSettings(
            BluetoothHidDeviceAppQosSettings.SERVICE_BEST_EFFORT,
            800,
            9,
            0,
            11250,
            BluetoothHidDeviceAppQosSettings.MAX
    );


    @Override
    @MainThread
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STATICS.CHANNEL.MAIN)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case STATICS.CHANNEL.GETBONDEDDEVICES:
                            getBondedDevices(result);
                            break;
                        case STATICS.CHANNEL.CONN:
                            conn(call, result);
                            break;
                        case STATICS.CHANNEL.RE_CONN:
                            reConn(call, result);
                            break;
                        case STATICS.CHANNEL.DIS_CONN:
                            Log.d("CHANNEL", STATICS.CHANNEL.DIS_CONN);
                            disConn(call, result);
                            break;
                        case STATICS.CHANNEL.MOUSE:
                            Map<String, Double> value1 = (Map<String, Double>) call.arguments;
                            mouse(value1.get("c"), value1.get("x"), value1.get("y"), value1.get("s"));
                            break;
                        default:
                            result.notImplemented();
                    }
                });
    }

    private void mouse(Double c, Double dx, Double dy, Double ds) {

        if ((ActivityCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN) != PackageManager.PERMISSION_GRANTED)
                || (ActivityCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED)) {
            requestPermissions(
                    new String[]{Manifest.permission.BLUETOOTH,
                            Manifest.permission.BLUETOOTH_SCAN,
                            Manifest.permission.BLUETOOTH_ADVERTISE,
                            Manifest.permission.BLUETOOTH_CONNECT},
                    1
            );
            return;
        }

        final int[] x = {(int) Math.round(dx)};
        final int[] y = {(int) Math.round(dy)};
        final int[] s = {(int) Math.round(ds)};

        mouseData[0] = (byte) (int) Math.round(c);
        mouseData[1] = (byte) -x[0];
        mouseData[2] = (byte) y[0];
        mouseData[3] = (byte) s[0];
        for (BluetoothDevice btDev : hidDevice.getConnectedDevices()) {
            hidDevice.sendReport(
                    btDev,
                    0,
                    mouseData
            );
        }
    }

    public void connRes() {
        connRes.success("ok");
    }

    private final byte[] mouseData = "BXYW".getBytes();

    private void conn(MethodCall call, MethodChannel.Result result) {

        connRes = result;

        Map<String, String> deviceMap = (Map<String, String>) call.arguments;

        String addr = deviceMap.get("address");
        for (BluetoothDevice bluetoothDevice : devices) {
            if (bluetoothDevice.getAddress().equals(addr)) {
                device = bluetoothDevice;
                break;
            }
        }

        ServiceListenerBle ble = new ServiceListenerBle(hidDevice, sdp, qos, device, this);
        listener = ble.getListener();
        proxyadapter.getProfileProxy(this, listener, BluetoothProfile.HID_DEVICE);
    }

    private void reConn(MethodCall call, MethodChannel.Result result) {
        boolean isActive = (boolean) call.arguments;

        Log.d("isActive", "" + isActive);
        if (!isActive) return;

        ServiceListenerBle ble = new ServiceListenerBle(hidDevice, sdp, qos, device, this);
        listener = ble.getListener();
        proxyadapter.getProfileProxy(this, listener, BluetoothProfile.HID_DEVICE);
    }

    @SuppressLint({"MissingPermission", "HardwareIds"})
    private void disConn(MethodCall call, MethodChannel.Result result) {
        Log.d("proxyadapter", "" + proxyadapter.getAddress());

        try {
            proxyadapter.closeProfileProxy(BluetoothProfile.HID_DEVICE, hidDevice);
            hidDevice.disconnect(device);
        } catch (Exception e) {
            Log.d("disConnError", Objects.requireNonNull(e.getMessage()));
        }

    }

    public void setProxy(BluetoothProfile.ServiceListener listener) {
        proxyadapter.getProfileProxy(this, listener, BluetoothProfile.HID_DEVICE);
    }

    public void setHidDevice(BluetoothHidDevice hidDevice) {
        this.hidDevice = hidDevice;
    }


    private void getBondedDevices(MethodChannel.Result result) {

        if ((ActivityCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN) != PackageManager.PERMISSION_GRANTED)
                || (ActivityCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED)) {
            requestPermissions(
                    new String[]{Manifest.permission.BLUETOOTH,
                            Manifest.permission.BLUETOOTH_SCAN,
                            Manifest.permission.BLUETOOTH_ADVERTISE,
                            Manifest.permission.BLUETOOTH_CONNECT},
                    1
            );
            return;
        }

        List<Map<String, String>> bondedDevices = new ArrayList<>();
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {

            BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
            Set<BluetoothDevice> bondedDevicesSet = bluetoothAdapter.getBondedDevices();
            devices = bondedDevicesSet;

            for (BluetoothDevice device : bondedDevicesSet) {
                Map<String, String> hashMap = new HashMap<String, String>() {{
                    put(STATICS.DEVICE.NAME, device.getName());
                    put(STATICS.DEVICE.ADDRESS, device.getAddress());
                    put(STATICS.DEVICE.ALIAS, device.getAlias());
                }};
                bondedDevices.add(hashMap);
            }
        }
        result.success(bondedDevices);
    }


}
