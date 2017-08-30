package com.thesis.project.controller;

import com.google.gson.Gson;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoDatabase;
import com.thesis.project.dao.ClassDAO;
import com.thesis.project.dao.PostDAO;
import com.thesis.project.dao.SessionDAO;
import com.thesis.project.dao.UserDAO;

import java.io.IOException;

import static com.thesis.project.util.JsonUtil.json;
import static spark.Spark.after;
import static spark.Spark.get;

public class ProjectRestController implements Mapper {

    private final ClassDAO classDAO;
    private final PostDAO postDAO;
    private final UserDAO userDAO;
    private final SessionDAO sessionDAO;

    public ProjectRestController(String mongoURIString) throws IOException {
        final MongoClient mongoClient = new MongoClient(new MongoClientURI(mongoURIString));
        final MongoDatabase projectDatabase = mongoClient.getDatabase("db_capstone");

        classDAO = new ClassDAO(projectDatabase);
        postDAO = new PostDAO(projectDatabase);
        userDAO = new UserDAO(projectDatabase);
        sessionDAO = new SessionDAO(projectDatabase);

        setupEndPoints();
    }

    @Override
    public void setupEndPoints() {
        get("/users", (request, response) -> userDAO.getTeachers(), json());

        get("/teachersList", (request, response) -> userDAO.getTeacherAccounts(), json());

        get("/searchCourse", (request, response) -> {
            String searchKey = request.queryParams("searchKey");
            return classDAO.findBySearchKey(searchKey);
        }, json());

/*
        after((request, response) -> {
            response.type("application/json");
        });
*/


    }
}
