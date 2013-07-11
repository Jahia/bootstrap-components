<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
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

<c:choose>

    <c:when test="${currentResource.moduleParams['type'] eq 'tab-content'}">

        <c:set var="tabPaneCSS" value="tab-pane"/>
        <c:if test="${currentResource.moduleParams.first}">
            <c:set var="tabPaneCSS" value="${tabPaneCSS} active"/>
        </c:if>
        <c:if test="${currentResource.moduleParams.fade && not renderContext.editMode}">
            <c:set var="tabPaneCSS" value="${tabPaneCSS} fade"/>
            <c:if test="${currentResource.moduleParams.first}">
                <c:set var="tabPaneCSS" value="${tabPaneCSS} in"/>
            </c:if>
        </c:if>

        <div class="${tabPaneCSS}" id="tab${currentResource.moduleParams.count}-${currentResource.moduleParams.id}">

            <template:module path="${currentNode.path}" view="default"/>

        </div>

    </c:when>

    <c:when test="${currentResource.moduleParams['type'] eq 'nav-tabs'}">

        <li ${currentResource.moduleParams.first ? 'class="active"' : ''}>
            <a href="#tab${currentResource.moduleParams.count}-${currentResource.moduleParams.id}" data-toggle="tab">${fn:escapeXml(currentNode.displayableName)}</a>
        </li>

    </c:when>

</c:choose>
