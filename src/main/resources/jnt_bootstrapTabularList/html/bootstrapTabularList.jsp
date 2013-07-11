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
<template:addResources type="javascript" resources="bootstrap-tab.js,bootstrap-transition.js"/>
<c:set var="tabsPosition"
       value="${currentNode.properties['tabsPosition'].string ne 'top' ? currentNode.properties['tabsPosition'].string : ''}"/>
<c:set var="fadeIn" value="${currentNode.properties['fadeIn'].boolean}"/>
<c:if test="${not empty tabsPosition}">
    <c:set var="tabsPositionCss" value=" tabs-${tabsPosition}"/>
</c:if>
<c:set var="subLists" value="${jcr:getChildrenOfType(currentNode, 'jnt:contentList')}"/>
<c:set var="activatedTab"
       value="${not empty cookie['bootstrapTabularList-activatedTab'] ? cookie['bootstrapTabularList-activatedTab'].value : ''}"/>

<c:if test="${renderContext.editMode}">
    <template:addResources type="inlinejavascript">

        <script type="text/javascript">

            $(document).ready(function () {

                $('a[data-toggle="tab"]').on('shown', function (e) {
                    // e.target is the activated tab
                    document.cookie = "bootstrapTabularList-activatedTab = " + e.target.attributes['href'].value;
                });

                <c:if test="${not empty activatedTab}">
                $('#jnt_bootstrapTabularList-${currentNode.identifier}').find('a[href="${activatedTab}"]').tab('show');
                </c:if>

            });

        </script>

    </template:addResources>
</c:if>

<c:if test="${not renderContext.editMode && not empty param['bootstrapTab']}">
    <template:addResources type="inlinejavascript">

        <script type="text/javascript">

            $(document).ready(function () {

                $('#jnt_bootstrapTabularList-${currentNode.identifier}').find('a[href="#${param['bootstrapTab']}"]').tab('show');
            });

        </script>

    </template:addResources>
</c:if>

<div class="tabbable ${not empty tabsPositionCss ? tabsPositionCss : ''}" id="jnt_bootstrapTabularList-${currentNode.identifier}">

    <c:if test="${tabsPosition ne 'below' and tabsPosition ne 'right'}">

        <%@include file="navTabsLoop.jspf" %>

    </c:if>

    <div class="tab-content">

        <c:forEach items="${subLists}" var="subList" varStatus="status">

            <template:module node="${subList}" view="bootstrapTabularList" editable="false">
                <template:param name="first" value="${status.first}"/>
                <template:param name="count" value="${status.count}"/>
                <template:param name="id" value="${currentNode.identifier}"/>
                <template:param name="fade" value="${fadeIn}"/>
                <template:param name="type" value="tab-content"/>
            </template:module>

        </c:forEach>

    </div>
    <!-- /tab-content -->

    <c:if test="${tabsPosition eq 'below' or tabsPosition eq 'right'}">

        <%@include file="navTabsLoop.jspf" %>

    </c:if>

    <c:if test="${renderContext.editMode}">
        <template:module path="*"/>
    </c:if>

</div>