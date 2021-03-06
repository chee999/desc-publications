<%-- 
    Document   : editLink
    Created on : Dec 19, 2017, 12:45:41 PM
    Author     : chee
--%>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@taglib uri="http://srs.slac.stanford.edu/displaytag" prefix="displayutils" %>
<%@taglib tagdir="/WEB-INF/tags" prefix="tg"%>
<%@taglib prefix="gm" uri="http://srs.slac.stanford.edu/GroupManager"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Document DESC-${param.paperid}</title>
        <link rel="stylesheet" href="css/pubstyles.css">
    </head>
    <body>
        <c:if test="${!gm:isUserInGroup(pageContext,'lsst-desc-members')}">  
            <c:redirect url="noPermission.jsp?errmsg=7"/>
        </c:if>
        
        <sql:query var="getproj">
            select project_id from descpub_publication where paperid = ?
            <sql:param value="${param.paperid}"/>
        </sql:query>
        
        <sql:query var="countpapers">
            select count(*) from descpub_publication where project_id = ?
            <sql:param value="${getproj.rows[0].project_id}"/>
        </sql:query>  
            
        <sql:query var="conven">
            select s.convener_group_name from descpub_swg s join descpub_project_swgs ps on s.id = ps.swg_id
            join descpub_project p on p.id = ps.project_id where ps.project_id = ?
            <sql:param value="${getproj.rows[0].project_id}"/>
        </sql:query>

        <tg:editPublication paperid="${param.paperid}"/> 
        <p></p>
        <c:set var="paperleads" value="paper_leads_${param.paperid}"/>
        <c:set var="paperreviewers" value="paper_reviewers_${param.paperid}"/>
        <c:set var="papermembers" value="paper_${param.paperid}"/>
        <c:set var="convenergrp" value="${conven.rows[0].convener_group_name}"/>
      
        <c:if test="${gm:isUserInGroup(pageContext,'lsst-desc-publications-admin') || gm:isUserInGroup(pageContext,convenergrp) || gm:isUserInGroup(pageContext,'GroupManagerAdmin' )}">
             Add or Remove Reviewers
            <p></p>
            <tg:groupMemberEditor groupname="${paperreviewers}" returnURL="editLink.jsp?paperid=${param.paperid}"/>  
            <p>   
        </c:if>
        
        <c:if test="${gm:isUserInGroup(pageContext,'lsst-desc-publications-admin') || gm:isUserInGroup(pageContext,paperleads) || gm:isUserInGroup(pageContext,'GroupManagerAdmin' )}">
            Add or Remove Lead Authors
            <p></p>
           <tg:groupMemberEditor groupname="${paperleads}" returnURL="editLink.jsp?paperid=${param.paperid}"/>  
            <p>   
            Add or Remove Eligible Authors
            <p></p>
            <tg:groupMemberEditor groupname="${papermembers}" returnURL="editLink.jsp?paperid=${param.paperid}"/>  
            <p>   
                
            <c:if test="${countpapers.rowCount > 0}">     
               <a href="uploadPub.jsp?paperid=${param.paperid}">Upload Draft of paper ${param.paperid}</a> &nbsp;&nbsp;&nbsp;&nbsp;
            </c:if>
            </p>
        </c:if> 
    </body>
    
    
</html>
