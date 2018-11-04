package com.here.name.example.calhacksapp;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import org.w3c.dom.Text;

public class SecondActivity extends AppCompatActivity implements SensorEventListener {

    TextView field;
    TextView id;
    TextView dummy;

    private SensorManager mSensorManager;
    private Sensor mSensor;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_second);
        field = findViewById(R.id.editText2);
        getRequest("https://jasonli.us/cgi-bin/webapp.cgi?action=add_sensor");

        // sensor
        mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        mSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);

        // open and close windows
    }

    @Override
    protected void onResume() {
        super.onResume();

        if (mSensor != null){
            mSensorManager.registerListener(this, mSensor, mSensorManager.SENSOR_DELAY_NORMAL);

        } else {
            Toast.makeText(this, "Not supported!", Toast.LENGTH_SHORT).show();
            finish();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();

        mSensorManager.unregisterListener(this);

    }

    // sends a get request and returns a code
    public void getRequest(String link) {
        id = findViewById(R.id.editText);
        // Instantiate the RequestQueue
        RequestQueue queue = Volley.newRequestQueue(this);
        // Request a string response from the provided URL.
        StringRequest stringRequest = new StringRequest(Request.Method.GET, link,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        // Display the response string.
                        id.setText(response);
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                System.out.print("Error.");
            }
        });

        // Add the request to the RequestQueue.
        queue.add(stringRequest);
    }


    public void doorbell(String link) {
        dummy = findViewById(R.id.editText3);
        // Instantiate the RequestQueue
        RequestQueue queue = Volley.newRequestQueue(this);
        // Request a string response from the provided URL.
        StringRequest stringRequest = new StringRequest(Request.Method.GET, link,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        // Display the response string.
                        dummy.setText(response);
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                System.out.print("Error.");
            }
        });

        // Add the request to the RequestQueue.
        queue.add(stringRequest);
    }

    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {

        float azimuth = Math.round(sensorEvent.values[0]);
        float pitch = Math.round(sensorEvent.values[1]);
        float roll = Math.round(sensorEvent.values[2]);

        double tesla = Math.sqrt((azimuth * azimuth) + (pitch * pitch) + (roll * roll));

        String text = "Magnetic field strength: " + String.valueOf(tesla);
        field.setText(text);

        String id_string = id.getText().toString();
        if (tesla > 3000) {
            String link = "https://jasonli.us/cgi-bin/webapp.cgi?action=door_close&id=" + id_string;
            doorbell(link);
        }

        else {
            String link = "https://jasonli.us/cgi-bin/webapp.cgi?action=door_open&id=" + id_string;
            doorbell(link);
        }

    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int i) {

    }
}
