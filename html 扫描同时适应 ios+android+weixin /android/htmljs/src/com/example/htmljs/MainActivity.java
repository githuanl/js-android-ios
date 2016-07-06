package com.example.htmljs;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.webkit.WebView;
import android.widget.Toast;

public class MainActivity extends Activity {

	private WebView contentWebView = null;

	@SuppressLint({ "JavascriptInterface", "SetJavaScriptEnabled" })
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		contentWebView = (WebView) findViewById(R.id.webview);
		// 启用javascript
		contentWebView.getSettings().setJavaScriptEnabled(true);
		// contentWebView.loadUrl("file:///android_asset/wst.html");
		contentWebView.loadUrl("http://192.168.0.118:8080/test/wst.html?"+Math.random());
		contentWebView.addJavascriptInterface(this, "request");
	}

	public void startFunction() {
		AlertDialog.Builder ab = new AlertDialog.Builder(MainActivity.this);
		ab.setTitle("提示");
		ab.setMessage("通过js 调用了 java 中的方法");
		ab.setPositiveButton("确定", new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				dialog.dismiss();
			}
		});
		ab.create().show();
	}

	public void openScan() {
		Toast.makeText(this, "js调用了java函数", Toast.LENGTH_SHORT).show();
		Intent intent = new Intent(this,MipcaActivityCapture.class);
		startActivityForResult(intent, 0);
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (resultCode == 0) {
			return;
		}
		contentWebView.loadUrl("javascript:javaCallJsWithArgs('"+data.getStringExtra("result")+"')");
	}
}
