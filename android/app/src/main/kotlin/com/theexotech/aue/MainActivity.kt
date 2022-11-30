package com.theexotech.aue

import android.app.Activity
import android.content.Intent
import android.widget.Toast
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import io.github.ponnamkarthik.toast.fluttertoast.FlutterToastPlugin
import payment.sdk.android.PaymentClient
import payment.sdk.android.cardpayment.CardPaymentData
import payment.sdk.android.cardpayment.CardPaymentRequest

class MainActivity : FlutterActivity() {

    private val paymentClient: PaymentClient = PaymentClient(this, "")

    private var resultString: String = ""

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Companion.PAYMENT_CHANNEL)
                .setMethodCallHandler { call, result ->
                    if (call.method == "initiatePayment") {
                        val a: String? = call.argument("paymentAuthLink")!!
                        val b: String? = call.argument("code")!!
                        paymentClient.launchCardPayment(
                                request = CardPaymentRequest.builder()
                                        .gatewayUrl(a!!)
                                        .code(b!!)
                                        .build(),
                                requestCode = 0)
                        result.success(resultString)
                    } else {
                        result.notImplemented()
                    }
                }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 0) {
            when (resultCode) {
                Activity.RESULT_OK -> {
                    val cardPaymentData = CardPaymentData.getFromIntent(data!!)
                    when (cardPaymentData.code) {
                        CardPaymentData.STATUS_PAYMENT_AUTHORIZED,
                        CardPaymentData.STATUS_PAYMENT_CAPTURED -> this.resultString = "Payment Captured"
                        CardPaymentData.STATUS_PAYMENT_FAILED -> this.resultString = "Payment Failed"
                        CardPaymentData.STATUS_GENERIC_ERROR -> this.resultString = "Generic Error (${cardPaymentData.reason})"
                    }
                }
                Activity.RESULT_CANCELED -> {
                    this.resultString = "Payment Canceled"
                }
            }
        }
    }

    companion object {
        private const val PAYMENT_CHANNEL: String = "aue.flutter/payment"
    }

}
