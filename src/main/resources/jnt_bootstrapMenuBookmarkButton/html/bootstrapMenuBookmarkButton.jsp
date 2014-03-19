<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="bootstrap" uri="http://www.jahia.org/tags/bootstrapLib" %>
<template:addResources type="javascript" resources="jquery.min.js"/>
<bootstrap:addCSS/>

<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<c:if test="${renderContext.loggedIn}" >
    <jcr:nodeProperty node="${currentNode}" name="position" var="position"/>
    <c:set var="pullClass" value="" />
    <c:if test="${not empty position}">
        <c:set var="pullClass" value="pull-${position.string}" />
    </c:if>

    <div class="${pullClass}">
        <form action="/" method="post" name="bookmark" id="bookmarkForm">
            <p>
                <input type="hidden" name="jcr:title" value=""/>
                <input type="hidden" name="jcrNodeType" value="jnt:bookmark">
                <input type="hidden" name="url" value="">
                <input class="button btn" id="bookmark" type="submit" value="<fmt:message key="bookmark.add"/>"/>

                <jcr:node path="${renderContext.user.localPath}" var="user"/>
                <fmt:message var="i18nSuccess" key="bookmark.added"/><c:set var="i18nSuccess" value="${functions:escapeJavaScript(i18nSuccess)}"/>
                <fmt:message var="i18nAlreadyExist" key="bookmark.alreadyExist"/><c:set var="i18nAlreadyExist" value="${functions:escapeJavaScript(i18nAlreadyExist)}"/>
                <script type="text/javascript">
                    document.forms['bookmark'].elements['jcr:title'].value = document.title;
                    document.forms['bookmark'].elements['url'].value = document.location;



                    $(document).ready(function () {
                        var $bookMarkMessage = $("<div class='bookmark-alert alert'><a class='close' data-dismiss='alert'>x</a><span class='message'></span></div>");

                        $("#bookmarkForm").submit(function () {
                            $.ajax({
                                type: "POST",
                                dataType: "json",
                                data: $(this).serialize(),
                                url: "<c:url value='${url.baseLive}${renderContext.user.localPath}.addBookmark.do'/>"
                            }).done(function (data) {
                                if($("#pagecontent .container-fluid").length > 0){
                                    $(".bookmark-alert").remove();
                                    var $message = $bookMarkMessage;
                                    if (data.isNew) {
                                        $message.addClass("alert-success");
                                        $message.find("span").text("${i18nSuccess}");
                                        $("#pagecontent .container-fluid").prepend($message);
                                    } else {
                                        $message.addClass("alert-info");
                                        $message.find("span").text("${i18nAlreadyExist}");
                                        $("#pagecontent .container-fluid").prepend($message);
                                    }
                                }else {
                                    if (data.isNew) {
                                        alert("${i18nSuccess}");
                                    } else {
                                        alert("${i18nAlreadyExist}");
                                    }
                                }

                                $('#bookmarkList${user.identifier}').load('<c:url value="${url.baseLive}${user.path}.bookmarks.html.ajax"/>');
                            });
                            return false;
                        });
                    });
                </script>
            </p>
        </form>
    </div>
</c:if>