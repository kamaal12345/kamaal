package

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import android.util.Log

// This file contains a deliberate security vulnerability for demonstration purposes.

class MainActivity : AppCompatActivity() {

    // SonarQube will flag this immediately. Hardcoding secrets is a major security risk.
    // An attacker could decompile the application and easily extract this API key.
    // The correct approach is to store secrets securely, such as in a local properties file
    // that is excluded from version control or using a dedicated key management system.
    private val API_KEY = "my_super_secret_api_key_12345"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Using the hardcoded key in a simulated network request
        Log.d("VulnerableApp", "Attempting to connect with API Key: $API_KEY")

        // In a real application, this would be a network call
        makeNetworkRequest(API_KEY)
    }

    private fun makeNetworkRequest(apiKey: String) {
        // This function would normally perform some action
        // using the provided API key.
        Log.d("VulnerableApp", "Simulating network request with key: $apiKey")
    }

    private fun anotherFunction() {
        // Another common vulnerability is hardcoding credentials
        // directly in a function, which is also easily detected.
        val username = "admin"
        val password = "password123" // SonarQube will flag this as a hardcoded password.

        Log.d("VulnerableApp", "Checking credentials for user: $username")
        checkLogin(username, password)
    }

    private fun checkLogin(user: String, pass: String) {
        // Dummy login check
    }
}
