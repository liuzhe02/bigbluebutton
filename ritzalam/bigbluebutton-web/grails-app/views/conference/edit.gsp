

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit Conference</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Conference List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New Conference</g:link></span>
        </div>
        <div class="body">
            <h1>Edit Conference</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${conferenceInstance}">
            <div class="errors">
                <g:renderErrors bean="${conferenceInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${conferenceInstance?.id}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="username">Username:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:conferenceInstance,field:'username','errors')}">
                                    <input type="text" id="username" name="username" value="${fieldValue(bean:conferenceInstance,field:'username')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="conferenceName">Conference Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:conferenceInstance,field:'conferenceName','errors')}">
                                    <input type="text" id="conferenceName" name="conferenceName" value="${fieldValue(bean:conferenceInstance,field:'conferenceName')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="conferenceNumber">Conference Number:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:conferenceInstance,field:'conferenceNumber','errors')}">
                                    <input type="text" id="conferenceNumber" name="conferenceNumber" value="${fieldValue(bean:conferenceInstance,field:'conferenceNumber')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="dateCreated">Date Created:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:conferenceInstance,field:'dateCreated','errors')}">
                                    <g:datePicker name="dateCreated" value="${conferenceInstance?.dateCreated}" ></g:datePicker>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="lastUpdated">Last Updated:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:conferenceInstance,field:'lastUpdated','errors')}">
                                    <g:datePicker name="lastUpdated" value="${conferenceInstance?.lastUpdated}" ></g:datePicker>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="schedules">Schedules:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:conferenceInstance,field:'schedules','errors')}">
                                    
<ul>
<g:each var="s" in="${conferenceInstance?.schedules?}">
    <li><g:link controller="schedule" action="show" id="${s.id}">${s?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="schedule" params="['conference.id':conferenceInstance?.id]" action="create">Add Schedule</g:link>

                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
