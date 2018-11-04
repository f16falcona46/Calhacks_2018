package com.here.name.example.calhacksapp;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        // get button
        Button connect = findViewById(R.id.button);
        // switches to second activity when clicked
        connect.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                GoToSecondActivity();
            }
        });
    }

    // method to switch activities
    private void GoToSecondActivity() {
        Intent intent = new Intent(this, SecondActivity.class);
        intent.putExtra("response", getString(R.string.response));
        startActivity(intent);
    }
}
