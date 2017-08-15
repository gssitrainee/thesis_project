package com.thesis.project.dao;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Sorts;
import com.mongodb.client.model.UpdateOptions;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ClassDAO {
    private final MongoCollection<Document> classCollection;

    public ClassDAO(final MongoDatabase blogDatabase) {
        classCollection = blogDatabase.getCollection("classes");
    }

    public Document findByClassCode(String classCode) {
        Document docClass = classCollection.find(Filters.eq("classCode", classCode)).first();
        return docClass;
    }

    public boolean saveClass(String username, String classCode, String className, String classDescription){
        if(null!=username && null!=classCode && null!=className){
            ObjectId objId = null;
            Document document = findByClassCode(classCode);
            if(null!=document) {
                objId = document.getObjectId("_id");
            }
            else
                objId = ObjectId.get();

            Document docClass = new Document("teacher", username);
            docClass.append("teacher", username);
            docClass.append("classCode", classCode);
            docClass.append("className", className);

            if(null!=classDescription && !"".equals(classDescription)){
                docClass.append("classDescription", classDescription);
            }

            //docClass.append("creationDate", new Date());
            docClass.append("lastModifiedDate", new Date());

            Document docUpdate = new Document("$set", docClass);

            try {
                UpdateOptions options = new UpdateOptions();
                options.upsert(true);

                classCollection.updateOne(Filters.eq("_id", objId), docUpdate, options);

                //classCollection.insertOne(docClass);
                System.out.println("Saving class(course): " + docClass.toJson());
                return true;
            } catch (Exception e) {
                System.out.println("Error saving class(course)");
                return false;
            }
        }

        return false;
    }

    //We will use classCode for searching the specific class to update. We will only allow class name and description as updatable fields.
    public boolean updateClass(String classCode, String className, String classDescription){
        if( (null!=classCode && !"".equals(classCode.trim())) && (null!=className && !"".equals(className.trim())) ){
            try {
                Document docClass = new Document("className", className);

                if(null!=classDescription && !"".equals(classDescription.trim()))
                    docClass.append("classDescription", classDescription);

                docClass.append("lastModifiedDate", new Date());

                classCollection.updateOne(Filters.eq("classCode", classCode), docClass);
                System.out.println("Update class(course): " + classCode);
                return true;
            } catch (Exception e) {
                System.out.println("Error updating class(course)");
                return false;
            }
        }

        return false;
    }

    public boolean removeClass(String classCode){
        if(null!=classCode && !"".equals(classCode.trim())){
            try {
                classCollection.deleteOne(Filters.eq("classCode", classCode));
                System.out.println("Unregistering class(course): " + classCode);
                return true;
            } catch (Exception e) {
                System.out.println("Error unregistering class(course)");
                return false;
            }
        }
        return false;
    }


    public List<Document> getAllClassesByTeacher(String username){
        if(null!=username){
            return classCollection.find(Filters.eq("teacher", username))
                    .sort(Sorts.ascending("classCode"))
                    .into(new ArrayList<>());
        }
        return null;
    }
}
