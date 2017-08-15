/*
 * Copyright 2012-2016 MongDB, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package com.thesis.project.controllers;


import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoDatabase;
import com.thesis.project.dao.ClassDAO;
import com.thesis.project.dao.PostDAO;
import com.thesis.project.dao.SessionDAO;
import com.thesis.project.dao.UserDAO;
import freemarker.template.Configuration;
import freemarker.template.SimpleHash;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import org.apache.commons.lang3.StringEscapeUtils;
import org.bson.Document;
import spark.Request;
import spark.Response;
import spark.Route;

import javax.servlet.http.Cookie;
import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import static spark.Spark.get;
import static spark.Spark.post;
import static spark.Spark.setPort;

/**
 * This class encapsulates the controllers for the blog web application.  It delegates all interaction with MongoDB
 * to three Data Access Objects (DAOs).
 * <p/>
 * It is also the entry point into the web application.
 */
public class ProjectController {
    private final Configuration cfg;
    private final ClassDAO classDAO;
    private final PostDAO postDAO;
    private final UserDAO userDAO;
    private final SessionDAO sessionDAO;

    public static void main(String[] args) throws IOException {
        if (args.length == 0) {
            new ProjectController("mongodb://localhost");
        }
        else {
            new ProjectController(args[0]);
        }
    }

    public ProjectController(String mongoURIString) throws IOException {
        final MongoClient mongoClient = new MongoClient(new MongoClientURI(mongoURIString));
        final MongoDatabase blogDatabase = mongoClient.getDatabase("thesis");

        classDAO = new ClassDAO(blogDatabase);
        postDAO = new PostDAO(blogDatabase);
        userDAO = new UserDAO(blogDatabase);
        sessionDAO = new SessionDAO(blogDatabase);

        cfg = createFreemarkerConfiguration();
        setPort(8082);
        initializeRoutes();
    }

    abstract class FreemarkerBasedRoute extends Route {
        final Template template;

        /**
         * Constructor
         *
         * @param path The route path which is used for matching. (e.g. /hello, users/:name)
         */
        protected FreemarkerBasedRoute(final String path, final String templateName) throws IOException {
            super(path);
            template = cfg.getTemplate(templateName);
        }

        @Override
        public Object handle(Request request, Response response) {
            StringWriter writer = new StringWriter();
            try {
                doHandle(request, response, writer);
            } catch (Exception e) {
                e.printStackTrace();
                response.redirect("/internal_error");
            }
            return writer;
        }

        protected abstract void doHandle(final Request request, final Response response, final Writer writer)
                throws IOException, TemplateException;

    }

    private void initializeRoutes() throws IOException {
        // this is the blog home page
        get(new FreemarkerBasedRoute("/", "home.ftl") {
            @Override
            public void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                Document user = null;
                SimpleHash root = new SimpleHash();
                String username = sessionDAO.findUserNameBySessionId(getSessionCookie(request));
                String statusMsg = getFlashMessage(request, "status_msg");

                if(null!=statusMsg && !"".equals(statusMsg))
                    root.put("statusMsg", statusMsg);

                if(null!=username){
                    root.put("username", username);

                    user = userDAO.getUserInfo(username);

                    if(null!=user){
                        root.put("userType", user.getString("userType"));
                        if("T".equals(user.getString("userType"))){
                            List<Document> userClasses = classDAO.getAllClassesByTeacher(username);
                            root.put("userClasses", userClasses);
                        }
                        else if("S".equals(user.getString("userType"))){
                            //TODO: Add List of Class enrolled.
                            //TODO: Add List of Active Quizzes not taken.
                        }
                    }

                }

                template.process(root, writer);
            }
        });

        // used to display actual blog post detail page
        get(new FreemarkerBasedRoute("/post/:permalink", "entry_template.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                String permalink = request.params(":permalink");

                System.out.println("/post: get " + permalink);

                Document post = postDAO.findByPermalink(permalink);
                if (post == null) {
                    response.redirect("/post_not_found");
                }
                else {
                    // empty comment to hold new comment in form at bottom of blog entry detail page
                    SimpleHash newComment = new SimpleHash();
                    newComment.put("name", "");
                    newComment.put("email", "");
                    newComment.put("body", "");

                    SimpleHash root = new SimpleHash();

                    root.put("post", post);
                    root.put("comment", newComment);

                    template.process(root, writer);
                }
            }
        });

        // handle the signup post
        post(new FreemarkerBasedRoute("/signup", "signup.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                String email = request.queryParams("email");
                String username = request.queryParams("username");
                String password = request.queryParams("password");
                String verify = request.queryParams("verify");
                String userType = request.queryParams("userType");

                HashMap<String, String> root = new HashMap<>();
                root.put("username", StringEscapeUtils.escapeHtml4(username));
                root.put("email", StringEscapeUtils.escapeHtml4(email));

                if (validateSignup(username, password, verify, email, userType, root)) {
                    // good user
                    System.out.println("Signup: Creating user with: " + username + " " + password);
                    if (!userDAO.addUser(username, password, email, userType)) {
                        // duplicate user
                        root.put("username_error", "Username already in use, Please choose another");
                        template.process(root, writer);
                    }
                    else {
                        // good user, let's start a session
                        String sessionID = sessionDAO.startSession(username);
                        System.out.println("Session ID is" + sessionID);

                        response.raw().addCookie(new Cookie("session", sessionID));
                        response.redirect("/welcome");
                    }
                }
                else {
                    // bad signup
                    System.out.println("User Registration did not validate");
                    template.process(root, writer);
                }
            }
        });

        // present signup form for blog
        get(new FreemarkerBasedRoute("/signup", "signup.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer)
                    throws IOException, TemplateException {

                SimpleHash root = new SimpleHash();

                // initialize values for the form.
                root.put("username", "");
                root.put("password", "");
                root.put("email", "");
                root.put("password_error", "");
                root.put("username_error", "");
                root.put("email_error", "");
                root.put("verify_error", "");
                root.put("userType_error", "");

                template.process(root, writer);
            }
        });

        // will present the form used to process new blog posts
        get(new FreemarkerBasedRoute("/class", "course_template.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                String classCode = request.queryParams("code");

                // get cookie
                String username = sessionDAO.findUserNameBySessionId(getSessionCookie(request));

                HashMap<String, String> root = new HashMap<>();

                if(null!=classCode){
                    Document docClass = classDAO.findByClassCode(classCode);
                    if(null!=docClass){
                        String className = docClass.getString("className");
                        String classDescription = docClass.getString("classDescription");

                        root.put("classCode", classCode);
                        root.put("className", className);
                        root.put("classDescription", classDescription);
                        root.put("username", username);
                    }
                    else {
                        root.put("errors", "Class not found!");
                    }
                }
                else
                    root.put("errors", "Class code is blank!");

                template.process(root, writer);
            }
        });

        // will present the form used to process creation of new class
        get(new FreemarkerBasedRoute("/newcourse", "course_template.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                Document user = null;

                // get cookie
                String username = sessionDAO.findUserNameBySessionId(getSessionCookie(request));
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
                    SimpleHash root = new SimpleHash();
                    root.put("username", username);
                    template.process(root, writer);
                }
            }
        });



        // handle the new class registration
        post(new FreemarkerBasedRoute("/save_class", "course_template.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {

                String classCode = StringEscapeUtils.escapeHtml4(request.queryParams("classCode"));
                String className = StringEscapeUtils.escapeHtml4(request.queryParams("className"));
                String classDescription = StringEscapeUtils.escapeHtml4(request.queryParams("classDescription"));

                String username = sessionDAO.findUserNameBySessionId(getSessionCookie(request));

                if (username == null) {
                    response.redirect("/login");    // only logged in users can post to blog
                }
                else if (classCode.equals("") || className.equals("") || classDescription.equals("")) {
                    // redisplay page with errors
                    HashMap<String, String> root = new HashMap<String, String>();
                    root.put("errors", "Please complete class details.");
                    root.put("classCode", classCode);
                    root.put("className", className);
                    root.put("classDescription", classDescription);
                    root.put("username", username);
                    template.process(root, writer);
                }
                else {

                    String msg;
                    if(classDAO.saveClass(username, classCode, className, classDescription))
                        msg = "Successfully saved class(course).";
                    else
                        msg = "Problem saving class(course).";

                    request.session().attribute("status_msg", msg);

                    // now redirect back to home
                    response.redirect("/");
                }
            }
        });



        // will present the form used to process new blog posts
        get(new FreemarkerBasedRoute("/newpost", "new_quiz_template.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {

                // get cookie
                String username = sessionDAO.findUserNameBySessionId(getSessionCookie(request));

                if (username == null) {
                    // looks like a bad request. user is not logged in
                    response.redirect("/login");
                }
                else {
                    SimpleHash root = new SimpleHash();
                    root.put("username", username);

                    List<Document> userClasses = classDAO.getAllClassesByTeacher(username);
                    root.put("userClasses", userClasses);

                    template.process(root, writer);
                }
            }
        });

        // handle the new post submission
        post(new FreemarkerBasedRoute("/newpost", "new_quiz_template.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer)
                    throws IOException, TemplateException {

                String title = StringEscapeUtils.escapeHtml4(request.queryParams("subject"));
                String post = StringEscapeUtils.escapeHtml4(request.queryParams("body"));
                String tags = StringEscapeUtils.escapeHtml4(request.queryParams("tags"));

                String username = sessionDAO.findUserNameBySessionId(getSessionCookie(request));

                if (username == null) {
                    response.redirect("/login");    // only logged in users can post to blog
                }
                else if (title.equals("") || post.equals("")) {
                    // redisplay page with errors
                    HashMap<String, String> root = new HashMap<String, String>();
                    root.put("errors", "post must contain a title and blog entry.");
                    root.put("subject", title);
                    root.put("username", username);
                    root.put("tags", tags);
                    root.put("body", post);
                    template.process(root, writer);
                }
                else {
                    // extract tags
                    ArrayList<String> tagsArray = extractTags(tags);

                    // substitute some <p> for the paragraph breaks
                    post = post.replaceAll("\\r?\\n", "<p>");

                    String permalink = postDAO.addPost(title, post, tagsArray, username);

                    // now redirect to the blog permalink
                    response.redirect("/post/" + permalink);
                }
            }
        });

        get(new FreemarkerBasedRoute("/welcome", "welcome.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {

                String cookie = getSessionCookie(request);
                String username = sessionDAO.findUserNameBySessionId(cookie);

                if (username == null) {
                    System.out.println("welcome() can't identify the user, redirecting to signup");
                    response.redirect("/signup");

                }
                else {
                    Document user = userDAO.getUserInfo(username);

                    SimpleHash root = new SimpleHash();

                    root.put("username", username);
                    if(null!=user)
                        root.put("userType", user.getString("userType"));

                    template.process(root, writer);
                }
            }
        });

        // process a new comment
        post(new FreemarkerBasedRoute("/newcomment", "entry_template.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer)
                    throws IOException, TemplateException {
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
                    SimpleHash root = new SimpleHash();
                    SimpleHash comment = new SimpleHash();

                    comment.put("name", name);
                    comment.put("email", email);
                    comment.put("body", body);
                    root.put("comment", comment);
                    root.put("post", post);
                    root.put("errors", "Post must contain your name and an actual comment");

                    template.process(root, writer);
                }
                else {
                    postDAO.addPostComment(name, email, body, permalink);
                    response.redirect("/post/" + permalink);
                }
            }
        });

        // present the login page
        get(new FreemarkerBasedRoute("/login", "login.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                SimpleHash root = new SimpleHash();

                root.put("username", "");
                root.put("login_error", "");

                template.process(root, writer);
            }
        });

        // process output coming from login form. On success redirect folks to the welcome page
        // on failure, just return an error and let them try again.
        post(new FreemarkerBasedRoute("/login", "login.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {

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
                    SimpleHash root = new SimpleHash();


                    root.put("username", StringEscapeUtils.escapeHtml4(username));
                    root.put("password", "");
                    root.put("login_error", "Invalid Login");
                    template.process(root, writer);
                }
            }
        });

        // Show the posts filed under a certain tag
        get(new FreemarkerBasedRoute("/tag/:thetag", "home.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer)
                    throws IOException, TemplateException {

                String username = sessionDAO.findUserNameBySessionId(getSessionCookie(request));
                SimpleHash root = new SimpleHash();

                String tag = StringEscapeUtils.escapeHtml4(request.params(":thetag"));
                List<Document> posts = postDAO.findByTagDateDescending(tag);

                root.put("myposts", posts);
                if (username != null) {
                    root.put("username", username);
                }

                template.process(root, writer);
            }
        });



        // tells the user that the URL is dead
        get(new FreemarkerBasedRoute("/post_not_found", "post_not_found.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                SimpleHash root = new SimpleHash();
                template.process(root, writer);
            }
        });

        // allows the user to logout of the blog
        get(new FreemarkerBasedRoute("/logout", "signup.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {

                String sessionID = getSessionCookie(request);

                if (sessionID == null) {
                    // no session to end
                    response.redirect("/login");
                }
                else {
                    // deletes from session table
                    sessionDAO.endSession(sessionID);

                    // this should delete the cookie
                    Cookie c = getSessionCookieActual(request);
                    c.setMaxAge(0);

                    response.raw().addCookie(c);

                    response.redirect("/login");
                }
            }
        });


        // used to process internal errors
        get(new FreemarkerBasedRoute("/internal_error", "error_template.ftl") {
            @Override
            protected void doHandle(Request request, Response response, Writer writer) throws IOException, TemplateException {
                SimpleHash root = new SimpleHash();

                root.put("error", "System has encountered an error.");
                template.process(root, writer);
            }
        });
    }

    // helper function to get session cookie as string
    private String getSessionCookie(final Request request) {
        if (request.raw().getCookies() == null) {
            return null;
        }
        for (Cookie cookie : request.raw().getCookies()) {
            if (cookie.getName().equals("session")) {
                return cookie.getValue();
            }
        }
        return null;
    }

    // helper function to get session cookie as string
    private Cookie getSessionCookieActual(final Request request) {
        if (request.raw().getCookies() == null) {
            return null;
        }
        for (Cookie cookie : request.raw().getCookies()) {
            if (cookie.getName().equals("session")) {
                return cookie;
            }
        }
        return null;
    }

    // tags the tags string and put it into an array
    private ArrayList<String> extractTags(String tags) {

        // probably more efficent ways to do this.
        //
        // whitespace = re.compile('\s')

        tags = tags.replaceAll("\\s", "");
        String tagArray[] = tags.split(",");

        // let's clean it up, removing the empty string and removing dups
        ArrayList<String> cleaned = new ArrayList<String>();
        for (String tag : tagArray) {
            if (!tag.equals("") && !cleaned.contains(tag)) {
                cleaned.add(tag);
            }
        }

        return cleaned;
    }

    // validates that the registration form has been filled out right and username conforms
    public boolean validateSignup(String username, String password, String verify, String email, String userType, HashMap<String, String> errors) {
        String USER_RE = "^[a-zA-Z0-9_-]{3,20}$";
        String PASS_RE = "^.{3,20}$";
        String EMAIL_RE = "^[\\S]+@[\\S]+\\.[\\S]+$";
        String TYPE_RE = "^[TS]*$";

        errors.put("username_error", "");
        errors.put("password_error", "");
        errors.put("verify_error", "");
        errors.put("email_error", "");
        errors.put("userType_error", "");

        if (!username.matches(USER_RE)) {
            errors.put("username_error", "invalid username. try just letters and numbers");
            return false;
        }

        if (!password.matches(PASS_RE)) {
            errors.put("password_error", "invalid password.");
            return false;
        }


        if (!password.equals(verify)) {
            errors.put("verify_error", "password must match");
            return false;
        }

        if (!email.equals("")) {
            if (!email.matches(EMAIL_RE)) {
                errors.put("email_error", "Invalid Email Address");
                return false;
            }
        }

        if(null==userType || (!userType.equals("") && !userType.matches(TYPE_RE))) {
            errors.put("userType_error", "Please select user type");
            return false;
        }

        return true;
    }

    private Configuration createFreemarkerConfiguration() {
        Configuration retVal = new Configuration();
        retVal.setClassForTemplateLoading(ProjectController.class, "/freemarker");
        return retVal;
    }

    public String getFlashMessage(Request request, String attribute) {
        String message = request.session().attribute(attribute);
        request.session().removeAttribute(attribute);
        return message;
    }

    private Document getUser(String username){
        if(null!=username){
            return userDAO.getUserInfo(username);
        }
        return null;
    }
}
