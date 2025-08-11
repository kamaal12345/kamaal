import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.ProcessBuilder.Redirect;

public class VulnerableRepoCloner {

    // VULNERABILITY 1: Hardcoded credentials.
    // Storing sensitive information like a password directly in the code is a major security risk.
    private static final String GITHUB_USERNAME = "your_github_user";
    private static final String GITHUB_PASSWORD = "your_hardcoded_password"; // SonarQube will flag this

    public static void main(String[] args) {
        
        // VULNERABILITY 2: Command injection.
        // The program takes user input directly and injects it into a system command without any sanitization.
        // A malicious user could enter a value like "my-repo.git; rm -rf /" to execute arbitrary commands.
        String repoName = "vulnerable-repo"; // Simulating user input for the repository name.

        // For a real-world scenario, this would come from a user or external source.
        // Example: String repoName = new java.util.Scanner(System.in).nextLine();

        // The 'git clone' command is constructed with user-provided data.
        String gitUrl = "https://" + GITHUB_USERNAME + ":" + GITHUB_PASSWORD + "@github.com/" + GITHUB_USERNAME + "/" + repoName + ".git";
        String[] command = {"git", "clone", gitUrl};

        try {
            ProcessBuilder processBuilder = new ProcessBuilder(command);
            processBuilder.redirectErrorStream(true);
            Process process = processBuilder.start();

            // VULNERABILITY 3: Insecure Temporary File Creation
            // This is a placeholder for a vulnerability where a sensitive file is created in a non-secure directory.
            // SonarQube would flag this.
            java.io.File tempFile = java.io.File.createTempFile("temp-api-key", ".txt");
            java.io.FileWriter writer = new java.io.FileWriter(tempFile);
            writer.write("api-key-12345");
            writer.close();
            // In a real scenario, this file might not be cleaned up.

            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }

            int exitCode = process.waitFor();
            System.out.println("Exited with code: " + exitCode);

            // VULNERABILITY 4: Unclosed resource (reader)
            // The BufferedReader is not explicitly closed in a 'finally' block, which could lead to a resource leak.
            // A more robust application would handle this with a try-with-resources statement or a finally block.

        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }
}
