package com.thesis.project.resource;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoDatabase;
import com.thesis.project.dao.ClassDAO;
import com.thesis.project.dao.PostDAO;
import com.thesis.project.dao.SessionDAO;
import com.thesis.project.dao.UserDAO;
import com.thesis.project.util.FreeMarkerTemplateEngine;
import com.thesis.project.util.ResourceUtilities;
import org.apache.commons.lang3.StringEscapeUtils;
import org.bson.Document;
import spark.ModelAndView;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static spark.Spark.get;
import static spark.Spark.post;

public class HomeResource {

    private final ClassDAO classDAO;
    private final PostDAO postDAO;
    private final UserDAO userDAO;
    private final SessionDAO sessionDAO;


    public HomeResource(String mongoURIString) throws IOException {
        final MongoClient mongoClient = new MongoClient(new MongoClientURI(mongoURIString));
        final MongoDatabase blogDatabase = mongoClient.getDatabase("db_capstone");

        classDAO = new ClassDAO(blogDatabase);
        postDAO = new PostDAO(blogDatabase);
        userDAO = new UserDAO(blogDatabase);
        sessionDAO = new SessionDAO(blogDatabase);

        setupEndPoints();
    }



    private void setupEndPoints() throws IOException {

/*
        get("login", (request, response) -> {
                    Map<String, Object> attributes = new HashMap<>();
                    attributes.put("message", "Hello World!");

            return new ModelAndView(attributes, "home.ftl");
        }, new FreeMarkerTemplateEngine());
*/

        // process a new comment
        post("newComment", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();
            attributes.put("message", "Hello World!");

            String name = StringEscapeUtils.escapeHtml4(request.queryParams("commentName"));
            String email = StringEscapeUtils.escapeHtml4(request.queryParams("commentEmail"));
            String body = StringEscapeUtils.escapeHtml4(request.queryParams("commentBody"));
            String permalink = request.queryParams("permalink");

            Document post = postDAO.findByPermalink(permalink);
            if (post == null) {
                response.redirect("/post_not_found");
            }
            // check that comment is good
            else if (name.equals("") || body.equals("")) {
                // bounce this back to the user for correction
                Map<String, String> comment = new HashMap<>();

                comment.put("name", name);
                comment.put("email", email);
                comment.put("body", body);

                attributes.put("comment", comment);
                attributes.put("post", post);
                attributes.put("errors", "Post must contain your name and an actual comment");
            }
            else {
                postDAO.addPostComment(name, email, body, permalink);
                response.redirect("/post/" + permalink);
            }

            return new ModelAndView(attributes, "entry_template.ftl");
        }, new FreeMarkerTemplateEngine());


        // Show the posts filed under a certain tag
        get("/tag/:thetag", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();
            attributes.put("message", "Hello World!");

            String username = sessionDAO.findUserNameBySessionId(ResourceUtilities.getSessionCookie(request));

            String tag = StringEscapeUtils.escapeHtml4(request.params(":thetag"));
            List<Document> posts = postDAO.findByTagDateDescending(tag);

            attributes.put("myposts", posts);
            if (username != null) {
                attributes.put("username", username);
            }

            return new ModelAndView(attributes, "home.ftl");
        }, new FreeMarkerTemplateEngine());

    }

}
