<#import "masterTemplate.ftl" as layout />

<@layout.masterTemplate title="Home">
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">

            <#if username??>
                <a class="navbar-brand" href="#">Welcome ${displayName}</a>
            <#else>
                <a class="navbar-brand" href="#">Welcome guest</a>
            </#if>

            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ml-auto">
                    <#if username??>
                        <li class="nav-item">
                            <a class="nav-link" href="/newCourse">Class Registration</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/postQuiz">Post a Quiz</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/logout">Logout</a>
                        </li>
                    <#else>
                        <li class="nav-item">
                            <a class="nav-link" href="/signup">Sign up</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/login">Log in</a>
                        </li>
                    </#if>
                </ul>
            </div>
        </div>
    </nav>


    <!-- Page Content -->
    <div class="container">
        <div class="row">
            <div class="col-lg-12 text-left">
                <h1 class="mt-5">Capstone Project</h1>
                <p class="lead">A Quiz Bank Web Application using Java Spark Framework, Freemarker, MongoDB</p>
                <#if userClasses??>
                    <ul class="list-unstyled">
                        <#list userClasses as cls>
                            <li><a href="/course?code=${cls["classCode"]}">${cls["className"]}<#if cls["classCode"]??> (${cls["classCode"]})</#if></a></li>
                        </#list>
                    </ul>
                </#if>
            </div>
        </div>
    </div>
</@layout.masterTemplate>