package com.thesis.project;

import com.thesis.project.controller.ProjectController;
import com.thesis.project.controller.ProjectRestController;

import java.io.IOException;

import static spark.Spark.externalStaticFileLocation;
import static spark.Spark.port;
import static spark.Spark.staticFiles;

public class CapstoneApplication {

    public static void main(String[] args) throws IOException {
        port(8082);
        externalStaticFileLocation("src/main/resources/public/");

        if (args.length == 0) {
            new ProjectController("mongodb://localhost");
            new ProjectRestController("mongodb://localhost");
        }
        else {
            new ProjectController(args[0]);
            new ProjectRestController(args[0]);
        }
    }

}
