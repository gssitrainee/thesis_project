<!DOCTYPE html>
<html>
<head>
    <title>Thesis: Homepage</title>
</head>
<body>

<#if username??>
    Welcome ${username} <a href="/logout">Logout</a><#if "T" == userType> | <a href="/newcourse">Register Class</a> | <a href="/newpost">New Quiz</a></#if>
    <p>
<#else>
    Welcome guest <a href="/signup"> Sign up </a> | <a href="/login">Log in</a>
</#if>

<h1>Home</h1>

<#if userClasses??>
    <ul>
        <#list userClasses as cls>
            <li><a href="/class?code=${cls["classCode"]}">${cls["className"]}<#if cls["classCode"]??> (${cls["classCode"]})</#if></a></li>
        </#list>
    </ul>
</#if>


<#--
    <#list myposts as post>
        <h2><a href="/post/${post["permalink"]}">${post["title"]}</a></h2>
        Posted ${post["date"]?datetime} <i>By ${post["author"]}</i><br>
        Comments:
        <#if post["comments"]??>
            <#assign numComments = post["comments"]?size>
                <#else>
                    <#assign numComments = 0>
        </#if>

        <a href="/post/${post["permalink"]}">${numComments}</a>
        <hr>
        ${post["body"]!""}
        <p>

        <p>
            <em>Filed Under</em>:
            <#if post["tags"]??>
                <#list post["tags"] as tag>
                    <a href="/tag/${tag}">${tag}</a>
                </#list>
            </#if>

        <p>
    </#list>
-->
</body>
</html>

