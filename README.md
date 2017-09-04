# thesis_project
Project for my Capstone Subject using Java Spark Framework and Freemaker with MongoDB

Note:

This is just a school project, so expect a student quality codes.
The functionality is very basic, but you could clone the repository and alter the code to fit your needs.

Java SDK: Version 8
URL1: http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-windows-x64.exe
URL2: http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

IDE: IntelliJ by JetBrains
URL: https://www.jetbrains.com/idea/

Database: MongoDB
URL: https://www.mongodb.com/download-center?jmp=nav#community



Steps:

1. Download(zip) or clone thesis_project

2. For downloaded zip, extract to any folder.

3. Open or Run IntelliJ

4. When IntelliJ is running, Open the project folder (thesis_project).
   a. Let IntelliJ download all the project dependencies using pom.xml (Maven)

5. Run MongoDB Server (run command "mongod"), just make sure MongoDB is properly installed and configured.
   a. Don't forget to create c:\data\db folder or directory

6. Configure IntelliJ to Run your Java Application.
   a. Run menu -> Edit Configurations
   b. Select 'Application' from the choices
   c. On 'Configuration' tab (Right side of dialog box), select the 'Main Class' and enter 'com.thesis.project.controllers.ProjectController'

7. Click 'Apply', then 'OK' buttons

8a. Run menu -> Run (SHIFT + F10 for windows)

8b. On the project folder in DOS, run the batch file runLocalServer.bat.
    Ex.:  c:\projects\thesis_project\runLocalServer.bat OR
          c:\projects\thesis_project\runLocalServer

9. Access the URL (http://localhost:8082) on your favorite browser.
   
