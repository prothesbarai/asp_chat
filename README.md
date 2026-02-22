# asp_chat

ASP Chat Application

## Getting Started

# Deep Linking Guide
#### Deep linking এর মাধ্যমে ব্যবহারকারী সরাসরি কোনো URL বা লিঙ্ক থেকে অ্যাপের নির্দিষ্ট পেজে পৌঁছাতে পারে। এটি চ্যাট অ্যাপে খুবই গুরুত্বপূর্ণ, যেমন: নির্দিষ্ট চ্যাট রুমে সরাসরি যাওয়া।
- - - Setup For Android :
- - - নেভিগেট করুন android/app/src/main/AndroidManifest.xml
- - - <activity>ট্যাগের ভিতরে নিম্নলিখিত মেটাডেটা ট্যাগ এবং ইনটেন্ট ফিল্টার যোগ করুন
```xml
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="http" android:host="example.com" />
        <data android:scheme="https" />
    </intent-filter>
```