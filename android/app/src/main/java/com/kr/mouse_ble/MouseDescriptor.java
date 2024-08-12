package com.kr.mouse_ble;

public class MouseDescriptor {
    public static final byte[] descriptor = new byte[]{

            //  Mouse
            (byte) 0x05, (byte) 0x01, // Usage Page (Generic Desktop)
            (byte) 0x09, (byte) 0x02, // Usage (Mouse)
            (byte) 0xA1, (byte) 0x01, // Collection (Application)
            (byte) 0x09, (byte) 0x01, //    Usage (Pointer)
            (byte) 0xA1, (byte) 0x00, //    Collection (Physical)
            (byte) 0x05, (byte) 0x09, //       Usage Page (Buttons)
            (byte) 0x19, (byte) 0x01, //       Usage minimum (1)
            (byte) 0x29, (byte) 0x03, //       Usage maximum (3)
            (byte) 0x15, (byte) 0x00, //       Logical minimum (0)
            (byte) 0x25, (byte) 0x01, //       Logical maximum (1)
            (byte) 0x75, (byte) 0x01, //       Report size (1)
            (byte) 0x95, (byte) 0x03, //       Report count (3)
            (byte) 0x81, (byte) 0x02, //       Input (Data, Variable, Absolute)
            (byte) 0x75, (byte) 0x05, //       Report size (5)
            (byte) 0x95, (byte) 0x01, //       Report count (1)
            (byte) 0x81, (byte) 0x01, //       Input (constant)                 ; 5 bit padding
            (byte) 0x05, (byte) 0x01, //       Usage page (Generic Desktop)
            (byte) 0x09, (byte) 0x30, //       Usage (X)
            (byte) 0x09, (byte) 0x31, //       Usage (Y)
            (byte) 0x09, (byte) 0x38, //       Usage (Wheel)
            (byte) 0x15, (byte) 0x81, //       Logical minimum (-127)
            (byte) 0x25, (byte) 0x7F, //       Logical maximum (127)
            (byte) 0x75, (byte) 0x08, //       Report size (8)
            (byte) 0x95, (byte) 0x03, //       Report count (3)
            (byte) 0x81, (byte) 0x06, //       Input (Data, Variable, Relative)
            (byte) 0xC0,              //    End Collection
            (byte) 0xC0,              // End Collection
    };
}
