package com.thesis.project.controller;

import com.mongodb.BasicDBList;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoDatabase;
import com.thesis.project.dao.*;
import com.thesis.project.util.ResourceUtilities;
import org.apache.commons.lang3.StringEscapeUtils;
import org.bson.Document;

import java.io.IOException;

import static com.thesis.project.util.JsonUtil.json;
import static spark.Spark.after;
import static spark.Spark.get;
import static spark.Spark.post;

public class ProjectRestController implements Mapper {

    private final CourseDAO courseDAO;
    private final CourseEnrollmentDAO courseEnrollmentDAO;
    private final PostDAO postDAO;
    private final UserDAO userDAO;
    private final SessionDAO sessionDAO;

    public ProjectRestController(String mongoURIString) throws IOException {
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
        get("/users", (request, response) -> userDAO.getTeachers(), json());

        get("/teachersList", (request, response) -> userDAO.getTeacherAccounts(), json());
        get("/studentsList", (request, response) -> userDAO.getStudents(), json());

        get("/searchCourse", (request, response) -> {
            String searchKey = request.queryParams("searchKey");
            return courseDAO.findBySearchKey(searchKey);
        }, json());

        get("/courseRegistrations", (request, response) -> {
            String classCode = request.queryParams("classCode");
            return courseEnrollmentDAO.getCourseRegistrationList(classCode);
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
                    BasicDBList enrolledClasses = (BasicDBList) user.get("classes");
                    if(null!=enrolledClasses){
                        System.out.println("there are enrolled classes");
                        for(Object o : enrolledClasses){
                            String s = (String) o;
                            System.out.println("[Class]: " + s);
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
                        Document course = courseDAO.findByClassCode(classCode);
                        String teacher = "n/a";

                        if(null!=course) teacher = course.getString("teacher");

                        courseEnrollmentDAO.addCourseEnrollment(username, studentName, classCode, course.getString("className"), teacher, course.getString("instructor"));

                        // userDAO.addEnrolledClasses(username, classCode);

                        //Document student = new Document("$set", new Document("classes", ))
                        //db.users.updateOne({"username": username}, {"$set": {"classes": ["cs123", "cs234"] }})

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

/*
        after((request, response) -> {
            response.type("application/json");
        });
*/


    }
}
