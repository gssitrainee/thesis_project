package com.thesis.project.controller;


import com.mongodb.*;
import com.mongodb.client.MongoDatabase;
import com.thesis.project.dao.*;
import com.thesis.project.util.FreeMarkerTemplateEngine;
import com.thesis.project.util.ResourceUtilities;
import org.apache.commons.lang3.StringEscapeUtils;
import org.bson.Document;
import spark.ModelAndView;

import javax.servlet.http.Cookie;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static spark.Spark.get;
import static spark.Spark.post;


public class ProjectController implements Mapper{

    private final CourseDAO courseDAO;
    private final CourseEnrollmentDAO courseEnrollmentDAO;
    private final PostDAO postDAO;
    private final UserDAO userDAO;
    private final SessionDAO sessionDAO;

    public ProjectController(String mongoURIString) throws IOException {
        final MongoClient mongoClient = new MongoClient(new MongoClientURI(mongoURIString));
        final MongoDatabase projectDatabase = mongoClient.getDatabase("db_capstone");

        courseDAO = new CourseDAO(projectDatabase);
        courseEnrollmentDAO = new CourseEnrollmentDAO(projectDatabase);
        postDAO = new PostDAO(projectDatabase);
        userDAO = new UserDAO(projectDatabase);
        sessionDAO = new SessionDAO(projectDatabase);

        setupEndPoints();
    }

    @Override
    public void setupEndPoints() {

        get("/", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();

            Document user = null;
            String sessionId = ResourceUtilities.getSessionCookie(request);
            String username = sessionDAO.findUserNameBySessionId(sessionId);
            attributes.put("sessionId", sessionId);
            attributes.put("showSignUp", true);

            String statusMsg = ResourceUtilities.getFlashMessage(request, "status_msg");

            if(null!=statusMsg && !"".equals(statusMsg))
                attributes.put("statusMsg", statusMsg);

            if(null!=username){
                attributes.put("username", username);
                user = userDAO.getUserInfo(username);
                if(null!=user){
                    String displayName = user.getString("firstName") + " " + user.getString("lastName");
                    attributes.put("hdrLink", "");
                    attributes.put("hdrLabel", "Welcome " + displayName);
                    attributes.put("userType", user.getString("userType"));
                    attributes.put("displayName", displayName);
                    if("T".equals(user.getString("userType"))){
                        List<Document> userClasses = courseDAO.getAllClassesByTeacher(username);
                        attributes.put("userClasses", userClasses);

                        List<Document> forApproval = courseEnrollmentDAO.getCourseRegistrationListForTeacher(username);
                        if(null!=forApproval && 0 < forApproval.size()) attributes.put("forApproval", forApproval);
                    }
                    else if("S".equals(user.getString("userType"))){
                        //TODO: Add List of Class enrolled.
                        //TODO: Add List of Active Quizzes not taken.
                    }
                }
            }

            return new ModelAndView(attributes, "home.ftl");
        }, new FreeMarkerTemplateEngine());


        get("signup", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();

            attributes.put("showSignUp", false);
            attributes.put("hdrLink", "login");
            attributes.put("hdrLabel", "Already a user?");

            // initialize values for the form.
            attributes.put("username", "");
            attributes.put("password", "");
            attributes.put("email", "");
            attributes.put("password_error", "");
            attributes.put("username_error", "");
            attributes.put("email_error", "");
            attributes.put("verify_error", "");
            attributes.put("userType_error", "");

            return new ModelAndView(attributes, "signup.ftl");
        }, new FreeMarkerTemplateEngine());


        // handle the signup post
        post("/signup", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();
            attributes.put("message", "Hello World!");

            String email = request.queryParams("email");
            String username = request.queryParams("username");
            String password = request.queryParams("password");
            String firstName = request.queryParams("firstName");
            String lastName = request.queryParams("lastName");
            String verify = request.queryParams("verify");
            String userType = request.queryParams("userType");

            attributes.put("username", StringEscapeUtils.escapeHtml4(username));
            attributes.put("email", StringEscapeUtils.escapeHtml4(email));

            if (ResourceUtilities.validateSignup(username, password, verify, firstName, lastName, email, userType, attributes)) {
                // good user
                System.out.println("Signup: Creating user with: " + username + " " + password);
                if (!userDAO.addUser(username, password, firstName, lastName, email, userType)) {
                    attributes.put("signup_error", "Username already in use, Please choose another");
                }
                else {
                    String sessionID = sessionDAO.startSession(username);
                    System.out.println("Session ID is" + sessionID);

                    response.raw().addCookie(new Cookie("session", sessionID));
                    response.redirect("/welcome");
                }
            }
            else {
                // bad signup
                attributes.put("signup_error", "User Registration did not validate");
            }

            return new ModelAndView(attributes, "signup.ftl");
        }, new FreeMarkerTemplateEngine());


        get("login", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();

            attributes.put("showSignUp", true);
            attributes.put("hdrLink", "signup");
            attributes.put("hdrLabel", "Need to Create an account?");

            attributes.put("showSignUp", true);
            attributes.put("username", "");
//            attributes.put("login_error", "");
            return new ModelAndView(attributes, "login.ftl");
        }, new FreeMarkerTemplateEngine());


        post("login", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();
            String username = request.queryParams("username");
            String password = request.queryParams("password");

            System.out.println("Login: User submitted: " + username + "  " + password);

            Document user = userDAO.validateLogin(username, password);

            if (user != null) {
                // valid user, let's log them in
                String sessionID = sessionDAO.startSession(user.get("_id").toString());

                if (sessionID == null) {
                    response.redirect("/internal_error");
                }
                else {
                    // set the cookie for the user's browser
                    response.raw().addCookie(new Cookie("session", sessionID));
                    response.redirect("/welcome");
                }
            }
            else {
                attributes.put("showSignUp", true);
                attributes.put("hdrLink", "signup");
                attributes.put("hdrLabel", "Need to Create an account?");

                attributes.put("username", StringEscapeUtils.escapeHtml4(username));
                attributes.put("password", "");
                attributes.put("login_error", "Unable to login. Please check the username/password.");
            }

            return new ModelAndView(attributes, "login.ftl");
        }, new FreeMarkerTemplateEngine());


        get("logout", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();
            String sessionID = ResourceUtilities.getSessionCookie(request);

            if (sessionID == null) {
                // no session to end
                response.redirect("/login");
            }
            else {
                // deletes from session table
                sessionDAO.endSession(sessionID);

                // this should delete the cookie
                Cookie c = ResourceUtilities.getSessionCookieActual(request);
                c.setMaxAge(0);

                response.raw().addCookie(c);
                response.redirect("/login");
            }

            return new ModelAndView(attributes, "signup.ftl");
        }, new FreeMarkerTemplateEngine());


        get("welcome", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();

            String sessionId = ResourceUtilities.getSessionCookie(request);
            String username = sessionDAO.findUserNameBySessionId(sessionId);
            attributes.put("sessionId", sessionId);

            if (username == null) {
                System.out.println("welcome() can't identify the user, redirecting to signup");
                response.redirect("/signup");
            }
            else {
                Document user = userDAO.getUserInfo(username);
                attributes.put("username", username);
                if(null!=user) {
                    String displayName = user.getString("firstName") + " " + user.getString("lastName");
                    attributes.put("hdrLink", "");
                    attributes.put("hdrLabel", "Welcome " + displayName);
                    attributes.put("userType", user.getString("userType"));

                    ArrayList<Document> userClasses =  (ArrayList) user.get("classes");
                    if(null!=userClasses){
                        System.out.println("has classes data");
                        for(Object o : userClasses){
                            System.out.println("[Class]: " + o.toString());
                        }
                    }
                    else {
                        System.out.println("there are no class data");
                    }

                    attributes.put("userClasses", userClasses);

                    if("T".equals(user.getString("userType"))){
                        //List<Document> userClasses = courseDAO.getAllClassesByTeacher(username);
                        //attributes.put("userClasses", userClasses);

                        List<Document> forApproval = courseEnrollmentDAO.getCourseRegistrationListForTeacher(username);
                        if(null!=forApproval && 0 < forApproval.size()) attributes.put("forApproval", forApproval);
                    }
                    else if("S".equals(user.getString("userType"))){
                        //TODO: Add List of Class enrolled.
                        //TODO: Add List of Active Quizzes not taken.
                    }
                }

            }
            return new ModelAndView(attributes, "welcome.ftl");
        }, new FreeMarkerTemplateEngine());


        get("/approvals", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();

            String sessionId = ResourceUtilities.getSessionCookie(request);
            String username = sessionDAO.findUserNameBySessionId(sessionId);
            attributes.put("sessionId", sessionId);

            if (username == null) {
                System.out.println("welcome() can't identify the user, redirecting to signup");
                response.redirect("/signup");
            }
            else {
                Document user = userDAO.getUserInfo(username);
                attributes.put("username", username);
                if(null!=user) {
                    if("T".equals(user.getString("userType"))){
                        String displayName = user.getString("firstName") + " " + user.getString("lastName");
                        attributes.put("hdrLink", "");
                        attributes.put("hdrLabel", "Welcome " + displayName);
                        attributes.put("userType", user.getString("userType"));

                        List<Document> forApproval = courseEnrollmentDAO.getCourseRegistrationListForTeacher(username);
                        if(null!=forApproval && 0 < forApproval.size()) attributes.put("forApproval", forApproval);
                    }
                }
            }

            return new ModelAndView(attributes, "approvals.ftl");
        }, new FreeMarkerTemplateEngine());

/*
        get("login", (request, response) -> {
                    Map<String, Object> attributes = new HashMap<>();
                    attributes.put("message", "Hello World!");

            return new ModelAndView(attributes, "home.ftl");
        }, new FreeMarkerTemplateEngine());
*/

        // will present the form used to process creation of new class
        get("newCourse", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();
            Document user = null;

            String sessionId = ResourceUtilities.getSessionCookie(request);
            String username = sessionDAO.findUserNameBySessionId(sessionId);
            attributes.put("sessionId", sessionId);

            if(null!=username)
                user = userDAO.getUserInfo(username);

            if (username == null) {
                // looks like a bad request. user is not logged in
                response.redirect("/login");
            }
            else if((null!=user && "S".equals(user.getString("userType")))){
                // Students should not be able to register a class
                response.redirect("/login?errors=Students are not allowed to register a class.");
            }
            else {
                String displayName = user.getString("firstName") + " " + user.getString("lastName");
                attributes.put("hdrLink", "");
                attributes.put("hdrLabel", "Welcome " + displayName);
                attributes.put("username", username);
                attributes.put("userType", user.getString("userType"));
            }

            return new ModelAndView(attributes, "course_template.ftl");
        }, new FreeMarkerTemplateEngine());


        // handle the new class registration
        post("saveCourseDetails", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();
            attributes.put("message", "Hello World!");

            String classCode = StringEscapeUtils.escapeHtml4(request.queryParams("classCode"));
            String className = StringEscapeUtils.escapeHtml4(request.queryParams("className"));
            String classDescription = StringEscapeUtils.escapeHtml4(request.queryParams("classDescription"));

            Document user = null;
            String sessionId = ResourceUtilities.getSessionCookie(request);
            String username = sessionDAO.findUserNameBySessionId(sessionId);
            attributes.put("sessionId", sessionId);

            if(null!=username) {
                user = userDAO.getUserInfo(username);

                if (classCode.equals("") || className.equals("") || classDescription.equals("")) {
                    // redisplay page with errors
                    attributes.put("errors", "Please complete class details.");
                    attributes.put("classCode", classCode);
                    attributes.put("className", className);
                    attributes.put("classDescription", classDescription);
                    attributes.put("username", username);
                }
                else {
                    String msg;
                    if(courseDAO.saveClass(username, classCode, className, classDescription, user.getString("firstName") + " " + user.getString("lastName")) && userDAO.addUserClasses(username, classCode, className))
                        msg = "Successfully saved class(course).";
                    else
                        msg = "Problem saving class(course).";

                    request.session().attribute("status_msg", msg);

                    // now redirect back to home
                    response.redirect("/");
                }
            }
            else
                response.redirect("/login");


            return new ModelAndView(attributes, "course_template.ftl");
        }, new FreeMarkerTemplateEngine());


        // will present the form used to process get and display class using class code
        get("course", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();
            String classCode = request.queryParams("code");

            Document user = null;
            String sessionId = ResourceUtilities.getSessionCookie(request);
            String username = sessionDAO.findUserNameBySessionId(sessionId);
            attributes.put("sessionId", sessionId);

            if(null!=username)
                user = userDAO.getUserInfo(username);

            if(null!=user){
                String displayName = user.getString("firstName") + " " + user.getString("lastName");
                attributes.put("userType", user.getString("userType"));
                attributes.put("hdrLink", "");
                attributes.put("hdrLabel", "Welcome " + displayName);
            }

            if(null!=classCode){
                Document docClass = courseDAO.findByClassCode(classCode);
                if(null!=docClass){
                    String className = docClass.getString("className");
                    String classDescription = docClass.getString("classDescription");

                    attributes.put("classCode", classCode);
                    attributes.put("className", className);
                    attributes.put("classDescription", classDescription);
                    attributes.put("username", username);

                    List<Document> forApproval = courseEnrollmentDAO.getCourseRegistrationList(classCode);
                    if(null!=forApproval && 0 < forApproval.size()) attributes.put("forApproval", forApproval);
                }
                else {
                    attributes.put("errors", "Class not found!");
                }
            }
            else
                attributes.put("errors", "Class code is blank!");

            return new ModelAndView(attributes, "course_template.ftl");
        }, new FreeMarkerTemplateEngine());



        get("classSearch", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();

            Document user = null;
            String sessionId = ResourceUtilities.getSessionCookie(request);
            String username = sessionDAO.findUserNameBySessionId(sessionId);
            attributes.put("sessionId", sessionId);

            if(null!=username)
                user = userDAO.getUserInfo(username);

            if(null!=user){
                String displayName = user.getString("firstName") + " " + user.getString("lastName");
                attributes.put("userType", user.getString("userType"));
                attributes.put("hdrLink", "");
                attributes.put("hdrLabel", "Welcome " + displayName);
            }

            if (username == null) {
                // looks like a bad request. user is not logged in
                response.redirect("/login");
            }
            else {
                attributes.put("username", username);
            }

            return new ModelAndView(attributes, "search_class.ftl");
        }, new FreeMarkerTemplateEngine());

        post("classSearch",(request, response) -> {
            Map<String, Object> attributes = new HashMap<>();

            Document user = null;
            String sessionId = ResourceUtilities.getSessionCookie(request);
            String username = sessionDAO.findUserNameBySessionId(sessionId);
            attributes.put("sessionId", sessionId);

            String searchKey = StringEscapeUtils.escapeHtml4(request.queryParams("searchKey"));
            List<Document> classes = courseDAO.findBySearchKey(searchKey);
            attributes.put("classes", classes);

            if(null!=username)
                user = userDAO.getUserInfo(username);

            if(null!=user){
                String displayName = user.getString("firstName") + " " + user.getString("lastName");
                attributes.put("userType", user.getString("userType"));
                attributes.put("hdrLink", "");
                attributes.put("hdrLabel", "Welcome " + displayName);
            }

            if (username == null) {
                // looks like a bad request. user is not logged in
                response.redirect("/login");
            }
            else {
                attributes.put("username", username);
            }

            return new ModelAndView(attributes, "search_class.ftl");
        }, new FreeMarkerTemplateEngine());



        // will present the form used to process new quiz posting
        get("postQuiz", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();

            Document user = null;
            String sessionId = ResourceUtilities.getSessionCookie(request);
            String username = sessionDAO.findUserNameBySessionId(sessionId);
            attributes.put("sessionId", sessionId);

            if(null!=username)
                user = userDAO.getUserInfo(username);

            if(null!=user){
                String displayName = user.getString("firstName") + " " + user.getString("lastName");
                attributes.put("hdrLink", "");
                attributes.put("hdrLabel", "Welcome " + displayName);
            }

            if (username == null) {
                // looks like a bad request. user is not logged in
                response.redirect("/login");
            }
            else {
                attributes.put("username", username);
                List<Document> userClasses = courseDAO.getAllClassesByTeacher(username);
                attributes.put("userClasses", userClasses);
            }

            return new ModelAndView(attributes, "new_quiz_template.ftl");
        }, new FreeMarkerTemplateEngine());


        // handle the new quiz posting submission
        post("postQuiz", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();
            attributes.put("message", "Hello World!");

            String title = StringEscapeUtils.escapeHtml4(request.queryParams("subject"));
            String post = StringEscapeUtils.escapeHtml4(request.queryParams("body"));
            String tags = StringEscapeUtils.escapeHtml4(request.queryParams("tags"));

            String sessionId = ResourceUtilities.getSessionCookie(request);
            String username = sessionDAO.findUserNameBySessionId(sessionId);
            attributes.put("sessionId", sessionId);

            if (username == null) {
                response.redirect("/login");    // only logged in users can post to blog
            }
            else if (title.equals("") || post.equals("")) {
                // redisplay page with errors
                attributes.put("errors", "post must contain a title and blog entry.");
                attributes.put("subject", title);
                attributes.put("username", username);
                attributes.put("tags", tags);
                attributes.put("body", post);
            }
            else {
                // extract tags
                ArrayList<String> tagsArray = ResourceUtilities.extractTags(tags);

                // substitute some <p> for the paragraph breaks
                post = post.replaceAll("\\r?\\n", "<p>");

                String permalink = postDAO.addPost(title, post, tagsArray, username);

                // now redirect to the blog permalink
                response.redirect("/post/" + permalink);
            }

            return new ModelAndView(attributes, "home.ftl");
        }, new FreeMarkerTemplateEngine());


        get("/quiz/:permalink", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();
            String permalink = request.params(":permalink");
            Document post = postDAO.findByPermalink(permalink);
            if (post == null) {
                response.redirect("/post_not_found");
            }
            else {
                // empty comment to hold new comment in form at bottom of blog entry detail page
                Map<String, String> new_comment = new HashMap<>();
                new_comment.put("name", "");
                new_comment.put("email", "");
                new_comment.put("body", "");

                attributes.put("post", post);
                attributes.put("comment", new_comment);
            }
            return new ModelAndView(attributes, "entry_template.ftl");
        }, new FreeMarkerTemplateEngine());






        // tells the user that the URL is dead
        get("post_not_found", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();
            return new ModelAndView(attributes, "post_not_found.ftl");
        }, new FreeMarkerTemplateEngine());


        // used to process internal errors
        get("internal_error", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();
            attributes.put("error", "System has encountered an error.");
            return new ModelAndView(attributes, "error_template.ftl");
        }, new FreeMarkerTemplateEngine());
    }

}