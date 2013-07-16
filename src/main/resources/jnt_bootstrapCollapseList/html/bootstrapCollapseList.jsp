<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="bootstrap" uri="http://www.jahia.org/tags/bootstrapLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="propertyDefinition" type="org.jahia.services.content.nodetypes.ExtendedPropertyDefinition"--%>
<%--@elvariable id="type" type="org.jahia.services.content.nodetypes.ExtendedNodeType"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<bootstrap:addCSS/>
<template:addResources type="javascript" resources="bootstrap-collapse.js,bootstrap-transition.js"/>
<c:set var="subLists" value="${jcr:getChildrenOfType(currentNode, 'jnt:contentList')}"/>

<div class="accordion" id="jnt_bootstrapCollapseList${fn:replace(currentNode.identifier,'-','')}">

    <c:forEach items="${subLists}" var="subList" varStatus="status">

        <template:module node="${subList}" view="bootstrapCollapseList" editable="false">
            <template:param name="first" value="${status.first}"/>
            <template:param name="count" value="${status.count}"/>
            <template:param name="id" value="${currentNode.identifier}"/>
        </template:module>

    </c:forEach>

    <c:if test="${renderContext.editMode}">
        <template:module path="*"/>
    </c:if>

</div>