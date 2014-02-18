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
<jcr:nodeProperty node="${currentNode}" name="bootstrapColumnSize" var="bootstrapColumnSize" />
<c:set var="bootstrapColumnSize" value="${bootstrapColumnSize.long}"/>
<c:if test="${empty bootstrapColumnSize or bootstrapColumnSize lt 1}">
    <c:set var="bootstrapColumnSize" value="12"/>
</c:if>

<jcr:nodeProperty node="${currentNode}" name="j:columns" var="columns" />
<c:set var="columns" value="${columns.long}"/>
<c:if test="${empty columns or columns lt 2}">
    <c:set var="columns" value="2"/>
</c:if>
<c:if test="${columns gt bootstrapColumnSize}">
    <c:set var="columns" value="${bootstrapColumnSize}"/>
</c:if>

<c:set var="columnSize" value="${functions:round(functions:floor(bootstrapColumnSize / columns))}"/>
<%-- If number of columns in the row is not fully divided by the numbers of columns in this view we add an offset to the first column to center the row --%>
<c:if test="${bootstrapColumnSize / columns gt columnSize}">
    <c:set var="offset" value="${functions:round(functions:floor((bootstrapColumnSize - (columns * columnSize)) / 2))}"/>
</c:if>

<c:forEach items="${moduleMap.currentList}" var="subchild" begin="${moduleMap.begin}" end="${moduleMap.end}"
           varStatus="status">
    <c:choose>
        <c:when test="${(status.index mod columns) eq 0 and not empty offset}">
            <c:set var="offsetClass" value="offset${offset} " />
        </c:when>
        <c:otherwise>
            <c:set var="offsetClass" value="" />
        </c:otherwise>
    </c:choose>
    <c:if test="${(status.index mod columns) eq 0 }">
        <div class="row-fluid">
    </c:if>
    <div class="${offsetClass}span${columnSize}">
            <template:module node="${subchild}" view="${moduleMap.subNodesView}" editable="${moduleMap.editable}"/>
    </div>
    <c:if test="${(status.index mod columns) eq (columns-1) or status.last}">
        </div>
    </c:if>
</c:forEach>

<c:if test="${moduleMap.editable and renderContext.editMode}">
    <div class="row-fluid">
        <div class="span${bootstrapColumnSize}">
            <template:module path="*"/>
        </div>
    </div>
</c:if>

<template:include view="hidden.footer"/>
