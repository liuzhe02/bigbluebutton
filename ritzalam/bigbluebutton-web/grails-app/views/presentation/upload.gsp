<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta name="layout" content="main" />
  <title>Login</title>
</head>
<body>
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <g:form controller="presentation" method="post" action="save" 
  		enctype="multipart/form-data">
    <input type="file" name="file"/>
    <input type="submit"/>
	</g:form>
</body>
</html>
