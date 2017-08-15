<!doctype HTML>
<html>
<head>
    <title>Register a Class (Course)</title>
    <style type="text/css">
        body { font-family: "Courier New", Georgia, Serif; }
        div.divContainer {
            border: 1px solid #ccc;
            width: 450px;
            padding: 20px 0px 20px 50px;
        }
        p > label {
            display: inline-block; width: 150px;
            font-weight: bold;
        }
        p > input[type='text'], p > textarea {
            font-family: "Courier New", Georgia, Serif;
            width: 200px;
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

    <h2>Class Information</h2>

    <#if errors??>
        <span class="status">${errors}</span>
    </#if>

    <div class="divContainer">
        <form action="/save_class" method="POST">
            <p>
                <label for="txtClassCode">Code:</label>
                <input type="text" id="txtClassCode" name="classCode" value="${classCode!""}" placeholder="Class or Course Code" title="Enter Class or Course Code" />
            </p>

            <p>
                <label for="txtClassName">Name:</label>
                <input type="text" id="txtClassName" name="className" value="${className!""}" placeholder="Class or Course Name" title="Enter Class or Course Name" />
            </p>

            <p>
                <label for="txtClassDescription">Description:</label>
                <textarea id="txtClassDescription" name="classDescription"  placeholder="Class or Course Description" title="Enter Class or Course Description" cols="30" rows="3">${classDescription!""}</textarea>
            </p>

            <p>
                <input type="submit" value="Submit">
            </p>
        </form>
    </div>
</body>
</html>

