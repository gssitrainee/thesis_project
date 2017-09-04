<#macro headerMetaTags>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
</#macro>

<#macro bootstrapCoreJS>
    <!-- Bootstrap core JavaScript -->
    <script src="js/jquery.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bootbox.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
</#macro>




<#macro navigationDiv>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">

            <#if username??>
                <a class="navbar-brand" href="/${hdrLink!"login"}">${hdrLabel!"Already a user?"}</a>
            <#else>
                <a class="navbar-brand" href="/login">Already a user?</a>
            </#if>

            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ml-auto">
                    <#if sessionId?? && userType??>
                        <#if 'T'==userType>
                            <li class="nav-item">
                                <a class="nav-link" href="/newCourse">Class Registration</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/approvals">Approvals</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/postQuiz">Post a Quiz</a>
                            </li>
                        <#elseif 'S'==userType>
                            <li class="nav-item">
                                <a class="nav-link" href="/classSearch">Search for Class</a>
                            </li>
                        </#if>
                        <#if sessionId??>
                            <li class="nav-item">
                                <a class="nav-link" href="/logout">Logout</a>
                            </li>
                        </#if>
                    <#else>
                        <#if showSignUp?? && showSignUp>
                            <li class="nav-item">
                                <a class="nav-link" href="/signup">Sign up</a>
                            </li>
                        </#if>
                        <li class="nav-item">
                            <a class="nav-link" href="/login">Log in</a>
                        </li>
                    </#if>
                </ul>
            </div>
        </div>
    </nav>
</#macro>






<#macro masterTemplate title="">
<!DOCTYPE html
        PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>${title}</title>

    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <style>
        body {
            padding-top: 54px;
        }
        @media (min-width: 992px) {
            body {
                padding-top: 56px;
            }
        }
    </style>
</head>
<body>
<div>
    <h1>${title}</h1>
    <div>
        <#nested />
    </div>
</div>

<!-- Bootstrap core JavaScript -->
<script src="js/jquery.min.js"></script>
<script src="js/popper.min.js"></script>
<script src="js/bootbox.min.js"></script>
<script src="js/bootstrap.min.js"></script>

</body>
</html>
</#macro>