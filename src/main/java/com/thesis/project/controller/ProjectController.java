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
    private final TopicDAO topicDAO;
    private final TopicQuizDAO topicQuizDAO;
    private final UserDAO userDAO;
    private final SessionDAO sessionDAO;

    private final static String NOT_AVAILABLE = "N/A";
    private final static String BLANK_VALUE = "";

    public ProjectController(String mongoURIString) throws IOException {
        final MongoClient mongoClient = new MongoClient(new MongoClientURI(mongoURIString));
        final MongoDatabase projectDatabase = mongoClient.getDatabase("db_capstone");

        courseDAO = new CourseDAO(projectDatabase);
        courseEnrollmentDAO = new CourseEnrollmentDAO(projectDatabase);
        topicDAO = new TopicDAO(projectDatabase);
        topicQuizDAO = new TopicQuizDAO(projectDatabase);
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

                    List<String> classes = new ArrayList<>();
                    List<Document> lstUserClasses = new ArrayList<>();
                    ArrayList<Document> userClassCodes =  (ArrayList) user.get("classes");
                    if(null!=userClassCodes){
                        System.out.println("has classes data");
                        for(Object o : userClassCodes){
                            String classCode = o.toString();
                            System.out.println("[Class]: " + classCode);
                            classes.add(classCode);
                            lstUserClasses.add(courseDAO.findById(classCode));
                        }
                    }
                    else {
                        System.out.println("there are no class data");
                    }

                    attributes.put("userClasses", lstUserClasses);

                    if("T".equals(user.getString("userType"))){
                        List<Document> forApproval = courseEnrollmentDAO.getCourseRegistrationListForTeacher(username);
                        if(null!=forApproval && 0 < forApproval.size()) attributes.put("forApproval", forApproval);
                    }
                    else if("S".equals(user.getString("userType"))){
                        List<Document> displayableTopics = new ArrayList<>();
                        List<Document> listTopicQuiz = topicQuizDAO.findByStudentDateDescending(username);

                        String[] arClasses = classes.toArray(new String[0]);
                        List<Document> topics = topicDAO.findByClassesLatest(arClasses);
                        if(null!=topics){
                            for(Document docTopics : topics){
                                String id = docTopics.getString("_id");
                                //if(!studentTakenTopicQuiz(listTopicQuiz, id)) displayableTopics.add(docTopics);
                                if(studentTakenTopicQuiz(listTopicQuiz, id)){
                                    System.out.println("[taken]: " + id);
                                    docTopics.append("taken", true);
                                }
                            }
                        }

                        attributes.put("topics", topics);
                        //attributes.put("topics", displayableTopics);
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

                    List<String> classes = new ArrayList<>();
                    List<Document> lstUserClasses = new ArrayList<>();
                    ArrayList<Document> userClassCodes =  (ArrayList) user.get("classes");
                    if(null!=userClassCodes){
                        System.out.println("has classes data");
                        for(Object o : userClassCodes){
                            String classCode = o.toString();
                            System.out.println("[Class]: " + classCode);
                            classes.add(classCode);
                            lstUserClasses.add(courseDAO.findById(classCode));
                        }
                    }
                    else {
                        System.out.println("there are no class data");
                    }

                    attributes.put("userClasses", lstUserClasses);

                    if("T".equals(user.getString("userType"))){
                        List<Document> forApproval = courseEnrollmentDAO.getCourseRegistrationListForTeacher(username);
                        if(null!=forApproval && 0 < forApproval.size()) attributes.put("forApproval", forApproval);
                    }
                    else if("S".equals(user.getString("userType"))){
                        List<Document> displayableTopics = new ArrayList<>();
                        List<Document> listTopicQuiz = topicQuizDAO.findByStudentDateDescending(username);

                        String[] arClasses = classes.toArray(new String[0]);
                        List<Document> topics = topicDAO.findByClassesLatest(arClasses);
                        if(null!=topics){
                            for(Document docTopics : topics){
                                String id = docTopics.getString("_id");
                                //if(!studentTakenTopicQuiz(listTopicQuiz, id)) displayableTopics.add(docTopics);
                                if(studentTakenTopicQuiz(listTopicQuiz, id)){
                                    System.out.println("[taken]: " + id);
                                    docTopics.append("taken", true);
                                }
                            }
                        }

                        attributes.put("topics", topics);
                        //attributes.put("topics", displayableTopics);
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
                Document docClass = courseDAO.findById(classCode);
                if(null!=docClass){
                    String className = docClass.getString("className");
                    String classDescription = docClass.getString("classDescription");

                    attributes.put("classCode", classCode);
                    attributes.put("className", className);
                    attributes.put("classDescription", classDescription);
                    attributes.put("username", username);

                    List<Document> forApproval = courseEnrollmentDAO.getCourseRegistrationList(classCode);
                    if(null!=forApproval && 0 < forApproval.size()) attributes.put("forApproval", forApproval);

                    int topicsCount = topicDAO.getCourseTopicsCount(classCode);
                    //System.out.println("\n[topicsCount]: " + topicsCount);

                    List<Document> listTopicQuiz = topicQuizDAO.findByCourseCodeDateDescending(classCode);
                    List<Document> classList = userDAO.getClassStudents(classCode);
                    if(null!=classList && 0 < classList.size()){
                        for(Document s : classList){
                            String student = s.getString("_id");
                            //System.out.println("\n[student]: " + student);

                            double totalScore = 0.0;
                            for(Document tq : listTopicQuiz){
                                if(tq.getString("student").equalsIgnoreCase(student)){
                                    //System.out.println("[topic-id]: " + tq.getString("topicId"));
                                    double score = tq.getInteger("topicScore");
                                    double itemCount = 0.0;
                                    //System.out.println("[score]: " + score);
                                    if(null!=tq.get("questions")){
                                        ArrayList<Document> questions =  (ArrayList) tq.get("questions");
                                        itemCount = questions.size();
                                    }

                                    double topicAverage = score/itemCount * 100;
                                    //System.out.println("[topicAverage]: " + topicAverage);
                                    totalScore+=topicAverage;
                                }
                            }

                            double totalAverage = totalScore/topicsCount;
                            s.append("totalScore", totalScore).append("totalAverage", totalAverage);
                            //System.out.println("[totalScore]: " + totalScore);
                            //System.out.println("[totalAverage]: " + totalAverage);
                        }
                        attributes.put("classList", classList);
                    }

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

            if (username == null) {
                // looks like a bad request. user is not logged in
                response.redirect("/login");
            }
            else {
                attributes.put("username", username);

                user = userDAO.getUserInfo(username);
                if(null!=user){
                    attributes.put("userType", user.getString("userType"));
                    attributes.put("hdrLink", "");
                    attributes.put("hdrLabel", "Welcome " + (user.getString("firstName") + " " + user.getString("lastName")));
                }

                List<Document> userClasses = courseDAO.getAllClassesByTeacher(username);
                attributes.put("userClasses", userClasses);
            }

            return new ModelAndView(attributes, "new_topic_template.ftl");
        }, new FreeMarkerTemplateEngine());


        get("/viewTopic", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();

            Document user = null;
            String sessionId = ResourceUtilities.getSessionCookie(request);
            String username = sessionDAO.findUserNameBySessionId(sessionId);
            attributes.put("sessionId", sessionId);

            if (username == null)
                response.redirect("/login");
            else {
                attributes.put("username", username);

                user = userDAO.getUserInfo(username);
                if(null!=user){
                    attributes.put("userType", user.getString("userType"));
                    attributes.put("hdrLink", "");
                    attributes.put("hdrLabel", "Welcome " + (user.getString("firstName") + " " + user.getString("lastName")));
                    attributes.put("student", username);
                    attributes.put("studentName", (user.getString("firstName") + " " + user.getString("lastName")));
                }

                String topicId = StringEscapeUtils.escapeHtml4(request.queryParams("tid"));

//                System.out.println("\n\n");
//                System.out.println("VIEW-TOPIC");
//                System.out.println("---------------------------------------------");
//                System.out.println("[TOPIC-ID]: " + topicId);
//                System.out.println("---------------------------------------------");
//                System.out.println("\n\n");
                boolean allowTopicSubmit = false;
                if(null!=topicId){
                    Document docTopic = topicDAO.findById(topicId);
//                    System.out.println("TOPIC: " + docTopic.toJson());
                    if(null!=docTopic){
                        attributes.put("topicId", docTopic.getString("_id"));

                        String classCode = docTopic.getString("classCode");
                        if(null!=classCode){
                            Document docCourse = courseDAO.findById(classCode);
                            if(null!=docCourse){
                                String course = docCourse.getString("className");
                                attributes.put("courseCode", classCode);
                                attributes.put("course", course);
                            }
                        }

//                        System.out.println("[topic]: " + docTopic.getString("topic"));
//                        System.out.println("[videoLink]: " + docTopic.getString("videoLink"));
//                        System.out.println("[summary]: " + docTopic.getString("summary"));


                        attributes.put("topic", docTopic.getString("topic"));
                        attributes.put("summary", docTopic.getString("summary"));
                        attributes.put("videoLink", docTopic.getString("videoLink"));
                        attributes.put("showVideoPlayer", true);

                        ArrayList<Document> items =  (ArrayList) docTopic.get("items");
//                        System.out.println("items.count: " + items.size());

                        attributes.put("items", items);

                        //If student has taken the topic quiz, it should show the list of top student scores for this topic
                        if(null!=topicQuizDAO.findByTopicIdAndCourseAndStudent(topicId, username, classCode)){
                            List<Document> listTopScores = topicQuizDAO.findByTopicIdOrderByScoreAndDateDescending(topicId);
                            attributes.put("listTopScores", listTopScores);
                        }
                        else
                            allowTopicSubmit = true;

                    }
                    else {
                        System.out.println("Topic not found!");

                        attributes.put("topicId", NOT_AVAILABLE);
                        attributes.put("courseCode", BLANK_VALUE);
                        attributes.put("course", BLANK_VALUE);

                        attributes.put("topic", NOT_AVAILABLE);
                        attributes.put("summary", NOT_AVAILABLE);
                        attributes.put("videoLink", BLANK_VALUE);
                        attributes.put("showVideoPlayer", false);
                    }
                }

                attributes.put("allowTopicSubmit", allowTopicSubmit);
            }

            return new ModelAndView(attributes, "view_topic_template.ftl");
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

    public boolean studentTakenTopicQuiz(List<Document> list, String id){
        if(null!=list && null!=id){
            for(Document d : list){
                String topicId = d.getString("topicId");
                if(null!=topicId && id.equalsIgnoreCase(topicId)) return true;
            }
        }
        return false;
    }
}