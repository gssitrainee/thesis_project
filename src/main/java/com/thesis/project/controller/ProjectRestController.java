package com.thesis.project.controller;

import com.google.gson.Gson;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoDatabase;
import com.mongodb.util.JSON;
import com.thesis.project.dao.*;
import com.thesis.project.model.Topic;
import com.thesis.project.util.ResourceUtilities;
import org.apache.commons.lang3.StringEscapeUtils;
import org.bson.Document;

import java.io.IOException;
import java.util.ArrayList;

import static com.thesis.project.util.JsonUtil.json;
import static spark.Spark.after;
import static spark.Spark.get;
import static spark.Spark.post;

public class ProjectRestController implements Mapper {

    private final CourseDAO courseDAO;
    private final CourseEnrollmentDAO courseEnrollmentDAO;
    private final TopicDAO topicDAO;
    private final UserDAO userDAO;
    private final SessionDAO sessionDAO;

    public ProjectRestController(String mongoURIString) throws IOException {
        final MongoClient mongoClient = new MongoClient(new MongoClientURI(mongoURIString));
        final MongoDatabase projectDatabase = mongoClient.getDatabase("db_capstone");

        courseDAO = new CourseDAO(projectDatabase);
        courseEnrollmentDAO = new CourseEnrollmentDAO(projectDatabase);
        topicDAO = new TopicDAO(projectDatabase);
        userDAO = new UserDAO(projectDatabase);
        sessionDAO = new SessionDAO(projectDatabase);

        setupEndPoints();
    }

    @Override
    public void setupEndPoints() {
        get("/users", (request, response) -> userDAO.getTeachers(), json());

        get("/teachersList", (request, response) -> userDAO.getTeacherAccounts(), json());
        get("/studentsList", (request, response) -> userDAO.getStudents(), json());

        get("/searchCourse", (request, response) -> {
            String searchKey = request.queryParams("searchKey");
            return courseDAO.findBySearchKey(searchKey);
        }, json());

        get("/courseRegistrations", (request, response) -> {
            String sessionId = ResourceUtilities.getSessionCookie(request);
            String usr = sessionDAO.findUserNameBySessionId(sessionId);

            String username = request.queryParams("su");
            String classCode = request.queryParams("cc");

            if(null!=username && null!=classCode)
                return courseEnrollmentDAO.getCourseRegistrationListForTeacherAndClass(username, classCode);
            else if(null!=classCode)
                return courseEnrollmentDAO.getCourseRegistrationList(classCode);
            else {
                return courseEnrollmentDAO.getCourseRegistrationListForTeacher(usr);
            }
        }, json());

        post("/enrollClass", (request, response) -> {
            String statusMsg = "";

            String sessionId = ResourceUtilities.getSessionCookie(request);
            String username = sessionDAO.findUserNameBySessionId(sessionId);

            if(null!=username) {
                Document user = userDAO.getUserInfo(username);

                if(null!=user){
                    String studentName = user.getString("firstName") + " " + user.getString("lastName");
                    boolean allowClassEnrollment = false;
                    ArrayList enrolledClasses =  (ArrayList) user.get("classes");
                    if(null!=enrolledClasses){
                        System.out.println("there are enrolled classes");
                        for(Object o : enrolledClasses){
                            System.out.println("[Class]: " + o.toString());
                        }
                    }
                    else {
                        System.out.println("student not enrolled in any class.");
                        allowClassEnrollment = true;
                    }

                    if(allowClassEnrollment){
                        String classCode = StringEscapeUtils.escapeHtml4(request.queryParams("cc"));
                        //TODO: Check if student is currently enrolled in selected class, if not ENROLL to class. Otherwise, return error "Currently Enrolled to Class".

                        System.out.println("[class-code]: " + classCode);
                        Document course = courseDAO.findById(classCode);
                        String teacher = "n/a";

                        if(null!=course) teacher = course.getString("teacher");

                        courseEnrollmentDAO.addCourseEnrollment(username, studentName, classCode, course.getString("className"), teacher, course.getString("instructor"));

                        statusMsg = "Class registration submitted. Please wait for teacher s approval.";
                    }
                    else {
                        statusMsg = "Student is already enrolled to the selected class.";
                    }
                }
            }
            else
                response.redirect("/login");

            return statusMsg;
        }, json());

        post("/approveEnrollment", (request, response) -> {
            String statusMsg = "";
            String sessionId = ResourceUtilities.getSessionCookie(request);
            String username = sessionDAO.findUserNameBySessionId(sessionId);

            if(null!=username){
                String student = StringEscapeUtils.escapeHtml4(request.queryParams("su"));
                String classCode = StringEscapeUtils.escapeHtml4(request.queryParams("cc"));

                boolean success = false;
                if(null!=student && null!=classCode){
                    Document course = courseDAO.findById(classCode);
                    System.out.println("[student]: " + student);
                    System.out.println("[classCode]: " + classCode);

                    success = userDAO.addUserClasses(student, course.getString("_id"), course.getString("className")) && courseEnrollmentDAO.removeCourseEnrollment(classCode, student);
                }

                if(success)
                    statusMsg = "Student Class Registration Approved.";
                else
                    statusMsg = "Unable to process student registration.";
            }
            else
                response.redirect("/login");

            return statusMsg;
        }, json());

        post("/denyEnrollment", (request, response) -> {
            String student = StringEscapeUtils.escapeHtml4(request.queryParams("su"));
            String classCode = StringEscapeUtils.escapeHtml4(request.queryParams("cc"));

            boolean success = false;
            if(null!=student && null!=classCode){
                //Remove student class registration
                success = courseEnrollmentDAO.removeCourseEnrollment(classCode, student);
            }

            if(success)
                return "Student Class Registration Denied.";
            else
                return "Unable to process student registration.";

        }, json());

        post("/saveCourseDetails", (request, response) -> {
            String classCode = StringEscapeUtils.escapeHtml4(request.queryParams("classCode"));
            String className = StringEscapeUtils.escapeHtml4(request.queryParams("className"));
            String classDescription = StringEscapeUtils.escapeHtml4(request.queryParams("classDescription"));

            Document user = null;
            String sessionId = ResourceUtilities.getSessionCookie(request);
            String username = sessionDAO.findUserNameBySessionId(sessionId);

            String msg = "Unknown User!";
            if(null!=username) {
                user = userDAO.getUserInfo(username);
                boolean successCourseSave = courseDAO.saveClass(username, classCode, className, classDescription, user.getString("firstName") + " " + user.getString("lastName"));
                if(successCourseSave) {
                    msg = "Successfully saved class(course).";
                    userDAO.addUserClasses(username, classCode, className);
                }
                else
                    msg = "Problem saving class(course).";
            }

            return msg;
        }, json());


        post("/saveTopic", (request, response) -> {
            String json = request.queryParams("jtopic");

            boolean success = false;
            Topic topic = null;
            if(null!=json){
                Document docTopic = Document.parse(json);
                success = topicDAO.addTopic(docTopic);
            }

            if(success)
                return "Topic successfully posted!";
            else
                return "Unable to save topic.";
        }, json());


        /*
            after((request, response) -> {
                response.type("application/json");
            });
        */
    }
}
