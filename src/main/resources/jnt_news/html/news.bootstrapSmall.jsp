<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="bootstrap" uri="http://www.jahia.org/tags/bootstrapLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="newsImage" type="org.jahia.services.content.JCRPropertyWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<bootstrap:addCSS/>

<jcr:nodeProperty node="${currentNode}" name="jcr:title" var="newsTitle"/>
<c:set var="newsTitleEscaped" value="${not empty newsTitle ? fn:escapeXml(newsTitle.string) : ''}"/>
<jcr:nodeProperty node="${currentNode}" name="date" var="newsDate"/>
<jcr:nodeProperty node="${currentNode}" name="desc" var="newsDesc"/>
<jcr:nodeProperty node="${currentNode}" name="image" var="newsImage"/>

<div class="media">
    <!--start newsListItem -->
    <c:url value="${newsImage.node.thumbnailUrls['thumbnail2']}" var="imageUrl"/>
    <a href="<c:url value='${url.base}${currentNode.path}.html'/>" class="pull-left">
        <img src="${imageUrl}" alt="${newsTitleEscaped}" class="img-rounded"/>
    </a>

    <div class="media-body">
        <h4 class="media-heading">
            <a href="<c:url value='${url.base}${currentNode.path}.html'/>">${newsTitleEscaped}</a>
        </h4>

        <p>${functions:abbreviate(functions:removeHtmlTags(newsDesc.string),400,420,'...')}</p>
        <small class="pull-right"><span class="muted"><fmt:formatDate value="${newsDate.time}" type="both" dateStyle="long" timeStyle="short"/></span></small>
    </div>
</div>