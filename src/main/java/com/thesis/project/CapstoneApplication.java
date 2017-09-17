package com.thesis.project;

import com.thesis.project.controller.ProjectController;
import com.thesis.project.controller.ProjectRestController;

import java.io.IOException;

import static spark.Spark.externalStaticFileLocation;
import static spark.Spark.port;
import static spark.Spark.staticFiles;

public class CapstoneApplication {

    private final static String DB_CONNSTR_ATLAST = "mongo \"mongodb://cluster0-shard-00-00-2xw8u.mongodb.net:27017,cluster0-shard-00-01-2xw8u.mongodb.net:27017,cluster0-shard-00-02-2xw8u.mongodb.net:27017/db_capstone?replicaSet=Cluster0-shard-0\" --authenticationDatabase admin --ssl --username borgymanotoy --password P@sudl@k0_123";
    private final static String DB_CONNSTR_LOCAL = "mongodb://localhost";

    public static void main(String[] args) throws IOException {
        port(8082);
        externalStaticFileLocation("src/main/resources/public/");


        if (args.length == 0) {
            new ProjectController(DB_CONNSTR_LOCAL);
            new ProjectRestController(DB_CONNSTR_LOCAL);
        }
        else {
            new ProjectController(args[0]);
            new ProjectRestController(args[0]);
        }
    }

}
