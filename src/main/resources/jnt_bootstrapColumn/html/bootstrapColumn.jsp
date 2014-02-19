<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="bootstrap" uri="http://www.jahia.org/tags/bootstrapLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<bootstrap:addCSS />
<jcr:nodeProperty node="${currentNode}" name="span" var="span"/>
<jcr:nodeProperty node="${currentNode}" name="offset" var="offset"/>
<c:if test="${editableModule}">
    <template:addResources type="javascript" resources="jquery.min.js,bootstrapConfig.js"/>
    <c:url var="currentNodeUrl" value="${url.base}${functions:escapePath(currentNode.path)}"/>
    <button class="btn btn-mini${span.long eq 1 ? ' disabled' : '' }" type="button"<c:if test="${span.long gt 1}"> onclick="updateCell('${currentNodeUrl}', ${span.long - 1}, null)"</c:if>><i class="icon-minus"></i></button>
    <button class="btn btn-mini" type="button" onclick="updateCell('${currentNodeUrl}', ${span.long + 1}, null)"><i class="icon-plus"></i></button>
    <button class="btn btn-mini${offset.long eq 0 ? ' disabled' : '' }" type="button"<c:if test="${offset.long gt 0}"> onclick="updateCell('${currentNodeUrl}', null, ${offset.long - 1})"</c:if>><i class="icon-indent-right"></i></button>
    <button class="btn btn-mini" type="button" onclick="updateCell('${currentNodeUrl}', null, ${offset.long + 1})"><i class="icon-indent-left"></i></button>
</c:if>
<template:area path="${currentNode.name}" areaAsSubNode="true"/>