<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<template:addResources type="css" resources="Columns.css"/>

<template:include view="hidden.header"/>
<c:if test="${!empty currentNode.properties['j:columns'].string}">
    <c:set var="columns" value="${currentNode.properties['j:columns'].string}"/>
</c:if>
<c:if test="${empty currentNode.properties['j:columns'].string}">
    <c:set var="columns" value="2"/>
</c:if>
<c:if test="${functions:length(moduleMap.currentList) lt columns}">
    <c:set var="columns" value="${functions:length(moduleMap.currentList)}"/>
</c:if>


<c:set var="columnSize" value="${functions:round(functions:floor((bootstrapColumnSize*1.0)/(columns*1.0)))}"/>
<c:set var="addOneToCenterColumn" value="0"/>
<%-- If number of columns in the row is not fully divided by the numbers of columns in this view we add one to the center columns--%>
<c:if test="${(bootstrapColumnSize*1.0)/(columns*1.0) gt columnSize}">
    <c:set var="addOneToCenterColumn" value="1"/>
</c:if>

<c:forEach items="${moduleMap.currentList}" var="subchild" begin="${moduleMap.begin}" end="${moduleMap.end}"
           varStatus="status">
    <c:choose>
        <c:when test="${(status.index mod columns) eq 0 or (status.index mod columns) eq (columns-1)}">
            <c:set var="currentColumnSize" value="${columnSize}"/>
        </c:when>
        <c:otherwise>
            <c:set var="currentColumnSize" value="${columnSize + addOneToCenterColumn}"/>
        </c:otherwise>
    </c:choose>
    <c:if test="${(status.index mod columns) eq 0 }">
        <ul class="thumbnails">
    </c:if>
    <li class="span${currentColumnSize}">
        <template:module node="${subchild}" view="${moduleMap.subNodesView}" editable="${moduleMap.editable}"/>
    </li>
    <c:if test="${(status.index mod columns) eq (columns-1) or status.last}">
        </ul>
    </c:if>
</c:forEach>

<c:if test="${moduleMap.editable and renderContext.editMode}">
    <ul class="thumbnails">
        <li class="span${bootstrapColumnSize}">
            <template:module path="*"/>
        </li>
    </ul>
</c:if>

<template:include view="hidden.footer"/>
