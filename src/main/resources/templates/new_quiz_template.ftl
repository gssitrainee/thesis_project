<!doctype HTML>
<html>
    <head>
        <title>Create a new Quiz</title>
        <style type="text/css">
            body { font-family: "Courier New", Georgia, Serif; }
            div.divContainer {
                border: 1px solid #ccc;
                width: 370px;
                padding: 20px 0px 20px 50px;
            }
            p > label {
                display: inline-block; width: 150px;
                font-weight: bold;
            }
            p > input[type='text'], p > textarea, select {
                font-family: "Courier New", Georgia, Serif;
                width: 300px;
                padding: 5px;
            }
            input[type=submit] {
                font-family: "Courier New", Georgia, Serif;
                font-weight: bolder;
                padding: 5px 20px;
            }
            span.status {
                font-family: "Courier New", Georgia, Serif;
                font-style: italic;
                font-size: 0.65em;
                padding: 5px;
                border: 1px solid #ddd;
                background-color: #eee;
            }
        </style>
    </head>
    <body>
        <#if username??>
            Welcome ${username} <a href="/logout">Logout</a> | <a href="/">Home</a>
            <p>
        </#if>

        <h1>Create a new Quiz</h1>

        <#if errors??>
            <span class="status">${errors}</span>
        </#if>

        <div class="divContainer">
            <form action="/newpost" method="POST">
            ${errors!""}

            <p>
                <label for="selClass">Class:</label>
                <select name="sel_class" id="selClass">
                <#if userClasses??>
                    <ul>
                        <#list userClasses as cls>
                            <option value="${cls["classCode"]}">${cls["className"]}</option>
                        </#list>
                    </ul>
                <#else>
                    <option value="N_A">No Class Available</option>
                </#if>
                </select>
            </p>

            <p>
                <label for="txtTitle">Title:</label>
                <input type="text" id="txtTitle" name="subject" size="120" value="${subject!""}"><br />
            </p>

            <p>
                <label for="txtContent">Content:</label>
                <textarea id="txtContent" name="body" cols="120" rows="20">${body!""}</textarea><br />
            </p>

            <p />
            <input type="submit" value="Submit">
            </form>
        </div>

    </body>
</html>

