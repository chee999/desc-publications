<%-- 
    Document   : editPublication
    Created on : Aug 8, 2017, 12:30:24 PM
    Author     : chee
--%>
<%@tag pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@taglib prefix="gm" uri="http://srs.slac.stanford.edu/GroupManager"%>

<script src="js/jquery-1.11.1.min.js"></script>
<script src="js/jquery.validate.min.js"></script>

<%@attribute name="pubid" required="true"%>
<%@attribute name="projid" required="true"%>

<h1>PUBID=${pubid}, PROJID=${projid}</h1> 

 <sql:query var="pubs" dataSource="jdbc/config-dev">
    select dp.ID pubid,pj.id projid,dp.STATE,dp.TITLE,dp.JOURNAL,dp.ABSTRACT,to_char(dp.ADDED,'YYYY-MON-DD') ADDED,dp.BUILDER_ELIGIBLE,dp.COMMENTS,dp.KEYPUB,dp.CWR_END_DATE,
    dp.ASSIGNED_PB_READER,dp.CWR_COMMENTS,dp.ARXIV,dp.TELECON,dp.JOURNAL_REVIEW,dp.PUBLISHED_REFERENCE,dp.PROJECT_ID,pj.TITLE 
    FROM descpub_publication dp join descpub_project pj on pj.id = dp.project_id where pj.id = ? and dp.id = ?
   <sql:param value="${projid}"/>
   <sql:param value="${pubid}"/>
  </sql:query>  
    
    
<sql:query var="states" dataSource="jdbc/config-dev">
    select state from descpub_publication_states order by state
</sql:query>
 
<sql:query var="projinfo" dataSource="jdbc/config-dev">
    select title from descpub_project where id = ?
   <sql:param value="${projid}"/>
</sql:query>
<sql:query var="wgs" dataSource="jdbc/config-dev">
    select wg.name, wg.id, wg.convener_group_name, wg.profile_group_name from descpub_project_swgs jo join descpub_swg wg on jo.swg_id = wg.id
    where jo.project_id = ?
    <sql:param value="${projid}"/>
</sql:query>
    
<h3>Publication: [${param.pubid}] ${pubs.rows[0].title} </h3>
    Added: ${pubs.rows[0].added}<br/>
    Project: <a href="show_project.jsp?projid=${projid}&swgid=${pubs.rows[0].swgid}&name=${pubs.rows[0].projtitle}">${pubs.rows[0].projtitle}</a><br/>
    
<form action="modifyPublication.jsp">  
   <input type="hidden" name="pubid" value="${pubid}"/> 
   <input type="hidden" name="projid" value="${projid}"/> 
   Title: <input type="text" value="${pubs.rows[0].title}" size="35" name="title" required/><br/>
   State: 
   <select name="pubstate" id="pubstate">
       <c:forEach var="sta" items="${states.rows}">
           <c:if test="${fn:startsWith(pubs.rows[0].state,sta.state)}">
               <option value="${sta.state}" selected>${sta.state}</option>
           </c:if>
               <option value="${sta.state}">${sta.state}</option>
       </c:forEach>
   </select>
   <p/>
   Abstract: <br/>
   <textarea name="abs" rows="10" cols="60" required>${pubs.rows[0].ABSTRACT}</textarea><br/>
   Journal: <input type="text" value="${pubs.rows[0].JOURNAL}" size="35" name="journal"/><br/>
   Comments: <input type="text" value="${pubs.rows[0].COMMENTS}" size="35" name="comm"/><br/>
   Builder Eligible: <input type="text" value="${pubs.rows[0].BUILDER_ELIGIBLE}" size="3" name="builder_eligible"/><br/>
   Key Publication: <input type="text" value="${pubs.rows[0].KEYPUB}" size="3" name="keypub"/><br/>
   Assigned PB Reader: <input type="text" value="${pubs.rows[0].ASSIGNED_PB_READER}" size="35" name="assigned_pb_reader"/><br/>
   arXiv number: <input type="text" value="${pubs.rows[0].ARXIV}" size="35" name="arxiv"/><br/>
   Telecon: <input type="text" value="${pubs.rows[0].TELECON}" size="35" name="telecon"/><br/>
   <p/>
   <input type="submit" value="UpdatePub" name="action" />
</form>
 
 