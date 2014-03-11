<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<c:set var="pageNode" value="${jcr:getParentOfType(currentNode, 'jnt:page')}"/>
<c:if test="${empty pageNode}">
    <c:choose>
        <c:when test="${jcr:isNodeType(renderContext.mainResource.node, 'jnt:page')}">
            <c:set var="pageNode" value="${renderContext.mainResource.node}"/>
        </c:when>
        <c:otherwise>
            <c:set var="pageNode" value="${jcr:getParentOfType(renderContext.mainResource.node, 'jnt:page')}"/>
        </c:otherwise>
    </c:choose>
</c:if>
<c:set var="isHome" value="${pageNode.path == renderContext.site.home.path}"/>
${(currentNode.properties['hideInHomePage'].boolean)}
<c:if test="${not empty pageNode && (!isHome || empty currentNode.properties['hideInHomePage'] || currentNode.properties['hideInHomePage'].boolean)}">
    <div class="page-header">
        <h1 class="pageTitle">
                <c:out value="${pageNode.displayableName}" />
            <c:if test="${not jcr:isNodeType(renderContext.mainResource.node, 'jnt:page')}">
        <smalL>&nbsp;>&nbsp;<c:out value="${functions:abbreviate(renderContext.mainResource.node.displayableName,15,30,'...')}" /></small></c:if></h1>
    </div>
</c:if>
