package com.thesis.project.model;

import com.google.gson.Gson;

import java.util.Date;
import java.util.List;

public class Topic {

    public Topic(){}

    private String _id;
    private String className;
    private String topic;
    private String videoLink;
    private String summary;
    private List<Item> items;
    private Date creationDate;


    public String get_id() {
        return _id;
    }

    public void set_id(String _id) {
        this._id = _id;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }

    public String getVideoLink() {
        return videoLink;
    }

    public void setVideoLink(String videoLink) {
        this.videoLink = videoLink;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public List<Item> getItems() {
        return items;
    }

    public void setItems(List<Item> items) {
        this.items = items;
    }

    public Date getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(Date creationDate) {
        this.creationDate = creationDate;
    }



    @Override
    public String toString() {
        Gson gson = new Gson();
        return gson.toJson(this);
    }


    private class Item {

        private String id;
        private String question;
        private String answerType;
        private String choiceA;
        private String choiceB;
        private String choiceC;
        private String choiceD;
        private String choiceE;
        private String singleAnswer;
        private String booleanValue;
        private String answerA;
        private String answerB;
        private String answerC;
        private String answerD;
        private String answerE;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getQuestion() {
            return question;
        }

        public void setQuestion(String question) {
            this.question = question;
        }

        public String getAnswerType() {
            return answerType;
        }

        public void setAnswerType(String answerType) {
            this.answerType = answerType;
        }

        public String getChoiceA() {
            return choiceA;
        }

        public void setChoiceA(String choiceA) {
            this.choiceA = choiceA;
        }

        public String getChoiceB() {
            return choiceB;
        }

        public void setChoiceB(String choiceB) {
            this.choiceB = choiceB;
        }

        public String getChoiceC() {
            return choiceC;
        }

        public void setChoiceC(String choiceC) {
            this.choiceC = choiceC;
        }

        public String getChoiceD() {
            return choiceD;
        }

        public void setChoiceD(String choiceD) {
            this.choiceD = choiceD;
        }

        public String getChoiceE() {
            return choiceE;
        }

        public void setChoiceE(String choiceE) {
            this.choiceE = choiceE;
        }

        public String getSingleAnswer() {
            return singleAnswer;
        }

        public void setSingleAnswer(String singleAnswer) {
            this.singleAnswer = singleAnswer;
        }

        public String getBooleanValue() {
            return booleanValue;
        }

        public void setBooleanValue(String booleanValue) {
            this.booleanValue = booleanValue;
        }

        public String getAnswerA() {
            return answerA;
        }

        public void setAnswerA(String answerA) {
            this.answerA = answerA;
        }

        public String getAnswerB() {
            return answerB;
        }

        public void setAnswerB(String answerB) {
            this.answerB = answerB;
        }

        public String getAnswerC() {
            return answerC;
        }

        public void setAnswerC(String answerC) {
            this.answerC = answerC;
        }

        public String getAnswerD() {
            return answerD;
        }

        public void setAnswerD(String answerD) {
            this.answerD = answerD;
        }

        public String getAnswerE() {
            return answerE;
        }

        public void setAnswerE(String answerE) {
            this.answerE = answerE;
        }

    }
}
