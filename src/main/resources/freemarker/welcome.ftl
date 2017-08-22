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
<<<<<<< HEAD
            <li>
                <a href="/newpost">New Post(Quiz)</a>
            </li>
            <li>
                <a href="/newpost">About us</a>
            </li>
            <li>
                <a href="/newpost">Map Selection</a>
            </li>
            <li>
                <a href="/newpost">Quiz</a>
            </li>
            <li>
                <a href="/newpost">Scoreboard</a>
            </li>
=======
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

>>>>>>> b8fd5e4188aa562c9cbb8e70670ad2ca0de104ad
        </ul>
    </body>
</html>
