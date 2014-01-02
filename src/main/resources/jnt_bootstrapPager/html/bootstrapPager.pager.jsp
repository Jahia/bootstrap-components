<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="uiComponents" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="search" uri="http://www.jahia.org/tags/search" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="moduleMap" type="java.util.Map"--%>
<c:set var="boundComponent"
       value="${uiComponents:getBoundComponent(currentNode, renderContext, 'j:bindedComponent')}"/>
<c:if test="${not empty boundComponent and jcr:isNodeType(boundComponent, 'jmix:list')}">
    <template:addCacheDependency node="${boundComponent}"/>
    <c:set var="pagesizeid" value="pagesize${boundComponent.identifier}"/>
    <c:set var="beginid" value="begin${boundComponent.identifier}"/>
    <c:choose>
        <c:when test="${not empty param[pagesizeid]}">
            <c:set var="pageSize" value="${param[pagesizeid]}"/>
        </c:when>
        <c:when test="${not empty param.src_itemsPerPage}">
            <c:set var="pageSize" value="${param.src_itemsPerPage}"/>
        </c:when>
        <c:otherwise>
            <c:set var="pageSize" value="${currentNode.properties['pageSize'].long}"/>
        </c:otherwise>
    </c:choose>
    <c:set target="${moduleMap}" property="pageSize" value="${pageSize}"/>
    <c:set target="${moduleMap}" property="pageStart" value="${param[beginid]}"/>
    <template:option node="${boundComponent}" nodetype="${boundComponent.primaryNodeTypeName},jmix:list"
                     view="hidden.header"/>
    <c:set var="sizeNotExact"
           value="${moduleMap.listApproxSize > 0 && moduleMap.listApproxSize != moduleMap.listTotalSize}"/>
    <template:initPager totalSize="${sizeNotExact ? moduleMap.listApproxSize : moduleMap.listTotalSize}"
                        sizeNotExact="${sizeNotExact}" pageSize="${pageSize}" id="${boundComponent.identifier}"/>
    <jsp:useBean id="pagerLimits" class="java.util.HashMap" scope="request"/>
    <c:set target="${pagerLimits}" property="${boundComponent.identifier}" value="${moduleMap.end}"/>
    <c:if test="${currentNode.properties.displayPager.boolean}">
        <c:set var="id" value="${boundComponent.identifier}"/>
        <c:set var="beginid" value="begin${id}"/>
        <c:set var="endid" value="end${id}"/>
        <c:set var="pagesizeid" value="pagesize${id}"/>
        <c:set var="nbOfPages" value="${currentNode.properties.nbOfPages.string}"/>
        <c:if test="${not empty moduleMap.paginationActive and moduleMap.totalSize > 0 and moduleMap.nbPages > 0}">
            <c:set target="${moduleMap}" property="usePagination" value="true"/>
            <c:choose>
                <c:when test="${not empty moduleMap.displaySearchParams}">
                    <c:set var="searchUrl"><search:searchUrl/>&</c:set>
                    <c:url value="${searchUrl}" var="basePaginationUrl">
                        <c:if test="${not empty param}">
                            <c:forEach items="${param}" var="extraParam">
                                <c:if test="${extraParam.key ne beginid and extraParam.key ne endid and extraParam.key ne pagesizeid and !fn:startsWith(extraParam.key, 'src_')}">
                                    <c:param name="${extraParam.key}" value="${extraParam.value}"/>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </c:url>
                </c:when>
                <c:otherwise>
                    <c:set var="searchUrl"
                           value="${not empty moduleMap.pagerUrl ? moduleMap.pagerUrl : url.mainResource}${not empty moduleMap.pagerUrl ? '':'?'}"/>
                    <c:url value="${searchUrl}" var="basePaginationUrl">
                        <c:if test="${not empty param}">
                            <c:forEach items="${param}" var="extraParam">
                                <c:if test="${extraParam.key ne beginid and extraParam.key ne endid and extraParam.key ne pagesizeid}">
                                    <c:param name="${extraParam.key}" value="${extraParam.value}"/>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </c:url>
                </c:otherwise>
            </c:choose>


            <c:set target="${moduleMap}" property="basePaginationUrl" value="${basePaginationUrl}"/>
            <ul class="pager">

            <c:url value="${basePaginationUrl}" var="previousUrl" context="/">
                <c:param name="${beginid}" value="${(moduleMap.currentPage-2) * moduleMap.pageSize }"/>
                <c:param name="${endid}" value="${ (moduleMap.currentPage-1)*moduleMap.pageSize-1}"/>
                <c:param name="${pagesizeid}" value="${moduleMap.pageSize}"/>
            </c:url>
            <li <c:if test="${empty moduleMap.currentPage or moduleMap.currentPage le 1}">class="disabled"</c:if>>
                <a href="${fn:escapeXml(previousUrl)}"><fmt:message key="pagination.previous"/></a>
            </li>



            <c:url value="${basePaginationUrl}" var="nextUrl" context="/">
                <c:param name="${beginid}" value="${ moduleMap.currentPage * moduleMap.pageSize }"/>
                <c:param name="${endid}" value="${ (moduleMap.currentPage+1)*moduleMap.pageSize-1}"/>
                <c:param name="${pagesizeid}" value="${moduleMap.pageSize}"/>
            </c:url>
            <li <c:if test="${moduleMap.currentPage ge moduleMap.nbPages}"> class="disabled" </c:if>>
            <a href="${fn:escapeXml(nextUrl)}"><fmt:message key="pagination.next"/></a>
            </li>
        </ul>
        <c:set target="${moduleMap}" property="usePagination" value="false"/>
        <c:remove var="listTemplate"/>
        </c:if>
        <!--stop pagination-->
    </c:if>
</c:if>
