<%-- 
    Document   : all_publications
    Created on : Aug 22, 2017, 5:12:47 PM
    Author     : chee
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@taglib uri="http://srs.slac.stanford.edu/displaytag" prefix="displayutils" %>
<%@taglib prefix="f" uri="http://lsstdesc.org/functions" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="tg"%>
<!DOCTYPE html>

<html>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%--  <link rel="stylesheet" href="css/site-demos.css"> --%>
          <link rel="stylesheet" type="text/css" href="css/pubstyles.css">
      <title>DESC Documents</title>
    </head>
    <body>
        <tg:underConstruction/>
        
        <%--
        <sql:query var="pubs" >
            select paperid, to_char(added,'yyyy-Mon-dd') added, state, keypub, title, project_id, pubtype, to_char(date_modified,'yyyy-Mon-dd') moddate from descpub_publication order by paperid
        </sql:query> --%>
            
        <sql:query var="vers" >
            select p.title, p.paperid, to_char(v.tstamp,'yyyy-Mon-dd'), version, location from descpub_publication p left join descpub_publication_versions v on v.paperid=p.paperid
            order by v.paperid
        </sql:query>
          
        <c:if test="${vers.rowCount>0}">    
        <display:table class="datatable" id="record" name="${vers.rows}">
            <display:column title="DESC ID" group="1">
                 DESC-${record.paperid}
            </display:column>
            <display:column title="Title" style="text-align:left;" group="2">
                ${record.title}
            </display:column>
                 
            <display:column title="Links" style="text-align:left;">
                <c:if test="${!empty record.version}">
                <a href="download?paperId=${record.paperid}&version=${record.version}">Download version ${record.version}</a>
                </c:if>
            </display:column>
        </display:table>
        </c:if>
          
                <%--
        <display:table class="datatable" id="Row" name="${pubs.rows}">
            <display:column title="DESC ID">
                <a href="show_pub.jsp?paperid=${Row.paperid}&projid=${Row.project_id}">DESC-${Row.paperid}</a>
            </display:column>
            <display:column title="Title" style="text-align:left;">
                <a href="show_pub.jsp?paperid=${Row.paperid}&projid=${Row.project_id}">${Row.title}</a>
            </display:column>
            <display:column title="Key Publication">
                ${Row.keypub}
            </display:column>  
            <display:column title="State">
                ${Row.state}
            </display:column>  
            <display:column title="Created">
                ${Row.added}
            </display:column>  
            <display:column title="Last Modified">
                ${Row.moddate}
            </display:column> 
        </display:table> --%>
            
    </body>
</html>
