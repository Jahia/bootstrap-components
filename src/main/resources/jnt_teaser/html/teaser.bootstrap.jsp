<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="bootstrap" uri="http://www.jahia.org/tags/bootstrapLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<bootstrap:addCSS/>
<jcr:nodeProperty node="${currentNode}" name="image" var="image"/>

<div class="thumbnail">
    <img src="${image.node.thumbnailUrls['thumbnail2']}" class="img-polaroid" alt=""/>

    <div class="caption">
        <h3><jcr:nodeProperty node="${currentNode}" name="jcr:title"/></h3>

        <p> ${currentNode.properties.abstract.string}</p>
        <template:addCacheDependency uuid="${currentNode.properties.link.string}"/>
        <c:if test="${not empty currentNode.properties.link.node}">
            <p><a href="<c:url value='${url.base}${currentNode.properties.link.node.path}.html'/>" class="btn btn-link">
                <fmt:message key="jnt_teaser.readMore"/>
            </a></p>
        </c:if>
    </div>
</div>
