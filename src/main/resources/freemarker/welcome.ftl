<!DOCTYPE html>
<html>
    <head>
        <title>Welcome</title>
        <style type="text/css">
            .label {text-align: right}
            .error {color: red}
        </style>
    </head>
    <body>
        Welcome ${username}
        <p>
        <ul>
            <li><a href="/">Home</a></li>
            <li>
                <a href="/logout">Logout</a>
            </li>
            <#if 'T'==userType>
                <li>
                    <a href="/newcourse">Register Class (Course)</a>
                </li>
                <li>
                    <a href="/newpost">Post a Quiz</a>
                </li>
            </#if>

            <!-- TODO: Load Classes here -->
            <!-- TODO: Load Class Active Quizes -->

        </ul>
    </body>
</html>
