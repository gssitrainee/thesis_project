package com.thesis.project.dao;

import com.mongodb.MongoWriteException;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Sorts;
import org.bson.Document;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CourseEnrollmentDAO {
    private final MongoCollection<Document> courseEnrollmentCollection;
    public static final String ENROLLMENT_STATUS_OPEN     = "OPEN";
    public static final String ENROLLMENT_STATUS_ACCEPTED = "ACCEPTED";
    public static final String ENROLLMENT_STATUS_DENIED   = "DENIED";

    public CourseEnrollmentDAO(final MongoDatabase projectDatabase){
        courseEnrollmentCollection = projectDatabase.getCollection("course_enrollment");
    }

    public boolean addCourseEnrollment(String username, String classCode, String teacher) {
        Document enrollment = new Document("student", username);
        enrollment.append("class", classCode);
        enrollment.append("teacher", teacher);
        enrollment.append("registrationDate", new Date());
        enrollment.append("status", ENROLLMENT_STATUS_OPEN);

        try {
            courseEnrollmentCollection.insertOne(enrollment);
            return true;
        } catch (MongoWriteException e) {
            return false;
        }
    }

    public List<Document> getCourseRegistrationList(String classCourse) {
        if(null!=classCourse){
            return courseEnrollmentCollection.find(Filters.eq("class", classCourse))
                    .sort(Sorts.ascending("class"))
                    .into(new ArrayList<>());
        }
        return null;
    }

    //List<Document> findCourseEnrollmentsForTeacher(teacherUsername)
    //List<Document> findCourseEnrollmentsByStudent(studentUsername)
    //Document courseEnrollment = findCourseEnrollment(teacherUsername, courseCode, studentUsername)
    //boolean updateCourseEnrollment(teacherUsername, courseCode, studentUsername, enrollmentStatus)
    //boolean removeCourseEnrollment(teacherUsername, courseCode, studentUsername)

}