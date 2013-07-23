<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="uiComponents" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="acl" type="java.lang.String"--%>
<template:addResources type="css" resources="commentable.css"/>
<c:set var="boundComponent"
       value="${uiComponents:getBindedComponent(currentNode, renderContext, 'j:bindedComponent')}"/>
<c:if test="${not empty boundComponent}">
    <jcr:node var="boundComponent" path="${boundComponent.path}/comments"/>
    <c:if test="${not empty boundComponent}">
        <template:addResources type="javascript" resources="jquery.min.js,jquery.cuteTime.js"/>
        <script>
            function initCuteTime() {
                $('.timestamp').cuteTime({ refresh: 60000 });
            }
            $(document).ready(function () {
                $('.timestamp').cuteTime({ refresh: 60000 });
            });
        </script>
        <query:definition var="numberOfPostsQuery"
                 statement="select * from [jnt:post] as post  where isdescendantnode(post, ['${functions:sqlencode(boundComponent.path)}']) order by post.[jcr:lastModified] desc"/>
        <c:set target="${moduleMap}" property="listQuery" value="${numberOfPostsQuery}" />
    </c:if>
    <c:if test="${empty boundComponent}">
        <template:addCacheDependency node="${boundComponent}"/>
    </c:if>
</c:if>
