<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<template:addCacheDependency uuid="${currentNode.properties.result.string}"/>
<c:if test="${not empty currentNode.properties.result.node}">
    <c:url value='${url.base}${currentNode.properties.result.node.path}.html' var="searchUrl"/>
    <jcr:nodeProperty node="${currentNode}" name="position" var="position"/>
    <c:set var="pullClass" value="" />
    <c:if test="${not empty position}">
        <c:set var="pullClass" value=" pull-${position.string}" />
    </c:if>
    <s:form method="post" class="navbar-search${pullClass}" action="${searchUrl}">
        <fmt:message key='search.startSearching' var="startSearching"/>
        <s:term match="all_words" id="searchTerm" value="${startSearching}" searchIn="siteContent,tags"
                onfocus="if(this.value=='${startSearching}')this.value='';"
                onblur="if(this.value=='')this.value='${startSearching}';" class="search-query"/>
        <s:site value="${renderContext.site.name}" includeReferencesFrom="systemsite" display="false"/>
        <s:language value="${renderContext.mainResource.locale}" display="false"/>
    </s:form>
</c:if>