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

package com.thesis.project.dao;

import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;
import com.mongodb.MongoWriteException;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.thesis.project.model.User;
import org.bson.Document;
import sun.misc.BASE64Encoder;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;

public class UserDAO {
    private final MongoCollection<Document> usersCollection;
    private Random random = new SecureRandom();

    public UserDAO(final MongoDatabase projectDatabase) {
        usersCollection = projectDatabase.getCollection("users");
    }

    // validates that username is unique and insert into db
    public boolean addUser(String username, String password, String firstName, String lastName, String email, String userType) {

        String passwordHash = makePasswordHash(password, Integer.toString(random.nextInt()));

        Document user = new Document();

        user.append("_id", username).append("password", passwordHash);

        if(null!=firstName && !firstName.equals("")){
            user.append("firstName", firstName);
        }

        if(null!=lastName && !lastName.equals("")){
            user.append("lastName", lastName);
        }

        if (email != null && !email.equals("")) {
            // the provided email address
            user.append("email", email);
        }

        if (userType != null && !userType.equals("")) {
            // the selected user type (T or S)
            user.append("userType", userType);
        }

        user.append("isActive", true);

        try {
            usersCollection.insertOne(user);
            return true;
        } catch (MongoWriteException e) {
            System.out.println("Username already in use: " + username);
            return false;
        }
    }

    //TODO: For testing if it will work
    public boolean deactivateUser(String username){
        boolean status = false;
        if(null!=username){
            Document docClass = new Document();
            docClass.append("isActive", false);
            docClass.append("lastModifiedDate", new Date());

            Document docUpdate = new Document("$set", docClass);
            usersCollection.updateOne(eq("username", username), docUpdate);
            return true;
        }
        return status;
    }

    //TODO: Create method of updating user information
    public boolean addUserClasses(String username, String classCode, String className){
        if(null!=username && null!=classCode){
            //db.users.find({"_id": "borgymanotoy", "classes" : "CS56"});
            //Document userClass = usersCollection.find(and(eq("_id", username), eq("classes", classCode))).first();
            Document userClass = usersCollection.find(and(eq("_id", username), eq("classes", classCode))).first();
            if(null==userClass){
                Document updateQuery = new Document("$push", new Document("classes", classCode));
                usersCollection.updateOne(eq("_id", username), updateQuery);
                return true;
            }
            else
                System.out.println("User-Class already exists. Cannot proceed adding user-class.");
        }
        return false;
    }


    public List<Document> getTeachers(){
        //db.users.find({userType: "T"}).pretty();
        return usersCollection.find(eq("userType", "T")).into(new ArrayList<>());
    }

    public List<Document> getStudents(){
        //db.users.find({userType: "T"}).pretty();
        return usersCollection.find(eq("userType", "S")).into(new ArrayList<>());
    }

    public List<Document> getClassStudents(String classCode){
        //db.users.find({"userType":"S","classes.code": "CS21"}).pretty();
        return usersCollection.find(and(eq("userType", "S"), eq("classes", classCode))).into(new ArrayList<>());
    }


    public List<User> getTeacherAccounts(){
        //db.users.find({userType: "T"}).pretty();
        List<User> users = new ArrayList<>();
        List<Document> lstDocUsers = usersCollection.find(eq("userType", "T")).into(new ArrayList<>());
        for(Document d : lstDocUsers)
            users.add(new User(d));
        return users;
    }

    public List<User> getStudentAccounts(){
        //db.users.find({userType: "T"}).pretty();
        List<User> users = new ArrayList<>();
        List<Document> lstDocUsers = usersCollection.find(eq("userType", "S")).into(new ArrayList<>());
        for(Document d : lstDocUsers)
            users.add(new User(d));
        return users;
    }

    public Document getUserInfo(String username){
        if(null!=username){
            return usersCollection.find(eq("_id", username)).first();
        }

        return null;
    }

    public Document validateLogin(String username, String password) {
        Document user = usersCollection.find(eq("_id", username)).first();

        if (user == null) {
            System.out.println("User not in database");
            return null;
        }

        String hashedAndSalted = user.get("password").toString();

        String salt = hashedAndSalted.split(",")[1];

        if (!hashedAndSalted.equals(makePasswordHash(password, salt))) {
            System.out.println("Submitted password is not a match");
            return null;
        }

        return user;
    }


    private String makePasswordHash(String password, String salt) {
        try {
            String saltedAndHashed = password + "," + salt;
            MessageDigest digest = MessageDigest.getInstance("MD5");
            digest.update(saltedAndHashed.getBytes());
            BASE64Encoder encoder = new BASE64Encoder();
            byte hashedBytes[] = (new String(digest.digest(), "UTF-8")).getBytes();
            return encoder.encode(hashedBytes) + "," + salt;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5 is not available", e);
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("UTF-8 unavailable?  Not a chance", e);
        }
    }
}
