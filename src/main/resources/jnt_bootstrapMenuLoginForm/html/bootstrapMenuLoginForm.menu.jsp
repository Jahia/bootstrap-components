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
<template:addResources type="javascript" resources="jquery.js,bootstrap-alert.js,bootstrap-modal.js,bootstrap-transition.js,bootstrap-collapse.js"/>
<template:addResources type="css" resources="bootstrapComponents.css"/>
<c:if test="${! renderContext.editMode}">
    <c:if test="${! renderContext.loggedIn}">
        <c:set var="siteNode" value="${currentNode.resolveSite}"/>

        <c:if test="${! jcr:isNodeType(siteNode, 'genericmix:hideLoginButton')}">
            <div class="login"><a class="btn btn-primary" href="#loginForm" role="button" data-toggle="modal"><i class="icon-user icon-white"></i>&nbsp;<fmt:message
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
                            <div class="alert alert-error"><fmt:message
                                    key="${param['loginError'] == 'account_locked' ? 'genericnt_login.accountLocked' : 'genericnt_login.invalidLogin'}"/></div>
                        </c:if>

                        <p>
                            <label for="username" class="control-label"><fmt:message
                                    key="bootstrapComponents.login.username"/></label>

                            <input type="text" value="" id="username" name="username"
                                   class="input-icon input-icon-first-name"
                                   placeholder="<fmt:message key="bootstrapComponents.login.username"/>">
                        </p>

                        <p>
                            <label for="password" class="control-label"><fmt:message
                                    key="bootstrapComponents.login.password"/></label>
                            <input type="password" name="password" id="password"
                                   class="input-icon input-icon-password"
                                   placeholder="<fmt:message key="bootstrapComponents.login.password"/>">
                        </p>

                        <p>
                            <label for="useCookie" class="checkbox">
                                <input type="checkbox" id="useCookie" name="useCookie"/>
                                <fmt:message key="bootstrapComponents.login.rememberMe"/>
                            </label>
                        </p>

                        <p class="text-right">
                            <button class="btn btn-primary"><i class="icon-ok"></i> <fmt:message
                                    key='bootstrapComponents.login.title'/>
                            </button>
                        </p>

                    </ui:loginArea>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary" data-dismiss="modal" aria-hidden="true">Close</button>
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
</c:if>
<c:if test="${renderContext.loggedIn}">
    <div class="user-box dropdown">

        <jcr:node var="userNode" path="${currentUser.localPath}" />
        <jcr:nodeProperty var="picture" node="${userNode}" name="j:picture"/>
        <c:set var="firstname" value="${userNode.properties['j:firstName'].string}"/>
        <c:set var="lastname" value="${userNode.properties['j:lastName'].string}"/>

        <a class="dropdown-toggle" data-toggle="dropdown" href="#">
            <c:if test="${not empty picture}">
                <img class='user-photo' src="${picture.node.thumbnailUrls['avatar_120']}" alt="${fn:escapeXml(firstname)} ${fn:escapeXml(lastname)}" width="60"
                     height="32"/>
            </c:if>
            <c:if test="${empty picture}">
                <img class='user-photo' src="${url.currentModule}/images/user.png" alt="${fn:escapeXml(firstname)} ${fn:escapeXml(lastname)}" width="60"
                     height="32"/>
            </c:if>
                ${fn:escapeXml(empty firstname and empty lastname ? userNode.name : firstname)}&nbsp;${fn:escapeXml(lastname)} <span class="caret"></span>
        </a>
        <ul class="dropdown-menu">
            <c:if test="${!renderContext.settings.distantPublicationServerMode
and renderContext.mainResource.node.properties['j:originWS'].string ne 'live'
and not jcr:isNodeType(renderContext.mainResource.node.resolveSite, 'jmix:remotelyPublished')
}">
                <c:if test="${! renderContext.liveMode}">
                    <li>
                        <a href="<c:url value='${url.live}'/>">
                            <i class="icon-globe"></i>
                            <fmt:message key="bootstrapComponents.login.gotoLive"/>
                        </a>
                    </li>
                </c:if>
                <c:if test="${! renderContext.previewMode && jcr:hasPermission(renderContext.mainResource.node, 'editModeAccess')}">
                    <li>
                        <a href="<c:url value='${url.preview}'/>">
                            <i class="icon-eye-open"></i>
                            <fmt:message key="bootstrapComponents.login.gotoPreview"/>
                        </a>
                    </li>
                </c:if>
                <c:if test="${! renderContext.editMode && jcr:hasPermission(renderContext.mainResource.node, 'editModeAccess')}">
                    <li>
                        <a href="<c:url value='${url.edit}'/>">
                            <i class="icon-edit"></i>
                            <fmt:message key="bootstrapComponents.login.gotoEdit"/>
                        </a>
                    </li>
                </c:if>
                <c:if test="${! renderContext.editMode && !jcr:hasPermission(renderContext.mainResource.node, 'editModeAccess') && jcr:hasPermission(renderContext.mainResource.node, 'contributeModeAccess')}">
                    <li>
                        <a href="<c:url value='${url.contribute}'/>">
                            <i class="icon-edit"></i>
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
                <a href="<c:url value='${url.baseLive}${currentUser.localPath}.html?jsite=${renderContext.site.identifier}'/>">
                    <i class="icon-user"></i>
                    <fmt:message key="bootstrapComponents.login.profile"/>
                </a>
            </li>

            <li class="divider"></li>

            <li>
                <a href="<c:url value='${url.logout}'/>">
                    <i class="icon-off"></i>
                    <fmt:message key="bootstrapComponents.login.logout"/>
                </a>
            </li>
        </ul>
    </div>
</c:if>
