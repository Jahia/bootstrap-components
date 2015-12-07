<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="bootstrap" uri="http://www.jahia.org/tags/bootstrapLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="currentAliasUser" type="org.jahia.services.usermanager.JahiaUser"--%>

<bootstrap:addCSS/>
<template:addResources type="javascript" resources="jquery.js,alert.js,modal.js,transition.js,collapse.js"/>
<template:addResources type="css" resources="bootstrapComponents.css"/>
<c:if test="${! renderContext.editMode}">
    <c:if test="${! renderContext.loggedIn}">
        <c:set var="siteNode" value="${currentNode.resolveSite}"/>

        <div class="login"><a class="btn btn-primary" href="#loginForm" role="button" data-toggle="modal"><i class="glyphicon-user glyphicon-white"></i>&nbsp;<fmt:message
                key="bootstrapComponents.login.title"/></a>
        </div>

        <div id="loginForm" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
             aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
                <h3 id="myModalLabel"><fmt:message key="bootstrapComponents.login.title"/></h3>
            </div>
            <div class="modal-body">
                <ui:loginArea>
                    <c:if test="${not empty param['loginError']}">
                        <div class="alert alert-danger"><fmt:message
                                key="${param['loginError'] == 'account_locked' ? 'message.accountLocked' : 'message.invalidUsernamePassword'}"/></div>
                    </c:if>

                    <p>
                        <label for="username" class="control-label"><fmt:message
                                key="bootstrapComponents.login.username"/></label>

                        <input type="text" value="" id="username" name="username"
                               class="input-icon input-glyphicon-first-name"
                               placeholder="<fmt:message key="bootstrapComponents.login.username"/>">
                    </p>

                    <p>
                        <label for="password" class="control-label"><fmt:message
                                key="bootstrapComponents.login.password"/></label>
                        <input type="password" name="password" id="password"
                               class="input-icon input-glyphicon-password"
                               placeholder="<fmt:message key="bootstrapComponents.login.password"/>" autocomplete="off">
                    </p>

                    <p>
                        <label for="useCookie" class="checkbox">
                            <input type="checkbox" id="useCookie" name="useCookie"/>
                            <fmt:message key="bootstrapComponents.login.rememberMe"/>
                        </label>
                    </p>

                    <p class="text-right">
                        <button class="btn btn-primary"><i class="glyphicon-ok glyphicon-white"></i> <fmt:message
                                key='bootstrapComponents.login.title'/>
                        </button>
                    </p>

                </ui:loginArea>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" data-dismiss="modal" aria-hidden="true"><i class="glyphicon-remove glyphicon-white"></i> Close</button>
            </div>
        </div>

        <script type="text/javascript">
            $(document).ready(function () {
                <c:set var="modalOption" value="${empty param['loginError'] ? 'hide' : 'show'}"/>
                $('#loginForm').modal('${modalOption}');
                $('#loginForm').appendTo("body");
            })
        </script>
    </c:if>
</c:if>
<c:if test="${renderContext.loggedIn}">
    <div class="user-box dropdown">

        <jcr:node var="userNode" path="${currentUser.localPath}" />
        <jcr:nodeProperty var="picture" node="${userNode}" name="j:picture"/>
        <c:set var="firstname" value="${userNode.properties['j:firstName'].string}"/>
        <c:set var="lastname" value="${userNode.properties['j:lastName'].string}"/>

        <a class="dropdown-toggle" data-toggle="dropdown" href="#">
            <c:if test="${not empty picture}">
                <template:addCacheDependency flushOnPathMatchingRegexp="${userNode.path}/files/profile/.*"/>
                <img class='user-photo' src="${picture.node.thumbnailUrls['avatar_120']}" alt="${fn:escapeXml(firstname)} ${fn:escapeXml(lastname)}" width="60" height="32"/>
            </c:if>
            <c:if test="${empty picture}">
                <img class='user-photo' src="<c:url value="${url.currentModule}/images/user.png"/>" alt="${fn:escapeXml(firstname)} ${fn:escapeXml(lastname)}" width="60"
                     height="32"/>
            </c:if>
                ${fn:escapeXml(empty firstname and empty lastname ? userNode.name : firstname)}&nbsp;${fn:escapeXml(lastname)} <span class="caret"></span>
        </a>
        <ul class="dropdown-menu">
            <c:if test="${!renderContext.settings.distantPublicationServerMode
and not jcr:isNodeType(renderContext.mainResource.node.resolveSite, 'jmix:remotelyPublished')
}">
                <c:choose>
                    <c:when test="${renderContext.mainResource.node.properties['j:originWS'].string ne 'live'}">
                        <c:set var="liveUrl" value="${url.live}"/>
                        <c:set var="editUrl" value="${url.edit}"/>
                        <c:set var="previewUrl" value="${url.preview}"/>
                        <c:set var="contributeUrl" value="${url.preview}"/>
                    </c:when>
                    <c:when test="${renderContext.mainResource.node.properties['j:originWS'].string eq 'live'}">
                        <c:set var="liveUrl" value="${url.live}.html"/>
                        <c:set var="editUrl" value="${url.baseEdit}${renderContext.site.home.path}.html"/>
                        <c:set var="previewUrl" value="${url.basePreview}${renderContext.site.home.path}.html"/>
                        <c:set var="contributeUrl" value="${url.baseContribute}${renderContext.site.home.path}.html"/>
                    </c:when>
                </c:choose>
                <c:if test="${! renderContext.liveMode}">
                    <li>
                        <a href="<c:url value='${liveUrl}'/>">
                            <i class="glyphicon-globe"></i>
                            <fmt:message key="bootstrapComponents.login.gotoLive"/>
                        </a>
                    </li>
                </c:if>
                <c:if test="${! renderContext.previewMode && jcr:hasPermission(renderContext.mainResource.node, 'editModeAccess')}">
                    <li>
                        <a href="<c:url value='${previewUrl}'/>">
                            <i class="glyphicon-eye-open"></i>
                            <fmt:message key="bootstrapComponents.login.gotoPreview"/>
                        </a>
                    </li>
                </c:if>
                <c:if test="${! renderContext.editMode && jcr:hasPermission(renderContext.mainResource.node, 'editModeAccess')}">
                    <li>
                        <a href="<c:url value='${editUrl}'/>">
                            <i class="glyphicon-edit"></i>
                            <fmt:message key="bootstrapComponents.login.gotoEdit"/>
                        </a>
                    </li>
                </c:if>
                <c:if test="${! renderContext.editMode && !jcr:hasPermission(renderContext.mainResource.node, 'editModeAccess') && jcr:hasPermission(renderContext.mainResource.node, 'contributeModeAccess')}">
                    <li>
                        <a href="<c:url value='${contributeUrl}'/>">
                            <i class="glyphicon-edit"></i>
                            <fmt:message key="bootstrapComponents.login.gotoContribute"/>
                        </a>
                    </li>
                </c:if>
            </c:if>
                <%--
                <li>
                    <a href="#">
                        <i class="fa fa-fw fa-cog"></i>
                        Settings
                    </a>
                </li>
                --%>
            <li class="divider"></li>
            <li>
                <a href="<c:url value='${url.myProfile}'/>">
                    <i class="glyphicon-user"></i>
                    <fmt:message key="bootstrapComponents.login.profile"/>
                </a>
            </li>

            <li class="divider"></li>

            <li>
                <a href="<c:url value='${url.logout}'/>">
                    <i class="glyphicon-off"></i>
                    <fmt:message key="bootstrapComponents.login.logout"/>
                </a>
            </li>
        </ul>
    </div>
</c:if>
