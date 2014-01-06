<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<jcr:nodeProperty node="${currentNode}" name="jcr:title" var="title"/>
<jcr:nodeProperty node="${currentNode}" name="j:styleName" var="styleName"/>
<jcr:nodeProperty node="${currentNode}" name="option" var="option"/>
<jcr:nodeProperty node="${currentNode}" name="responsive" var="responsive"/>
<jcr:nodeProperty node="${currentNode}" name="inverse" var="inverse"/>
<c:set var="navbarClasses" value="navbar" />
<c:if test="${not empty option and not empty option.string}">
    <c:set var="navbarClasses" value="${navbarClasses} ${option.string}" />
</c:if>
<c:if test="${not empty inverse and inverse.boolean}">
    <c:set var="navbarClasses" value="${navbarClasses} navbar-inverse" />
</c:if>
<c:if test="${not empty styleName}">
    <c:set var="navbarClasses" value="${navbarClasses} ${styleName.string}" />
</c:if>
<div class="${navbarClasses}">
    <div class="navbar-inner">
    <c:if test="${not empty responsive and responsive.boolean}">
        <div class="container">
            <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </a>
    </c:if>

        <c:if test="${not empty title}">
            <a class="brand" href="${renderContext.site.home.url}">${fn:escapeXml(title.string)}</a>
        </c:if>

        <c:if test="${not empty responsive and responsive.boolean}">
            <div class="nav-collapse collapse">
        </c:if>

            <c:forEach items="${jcr:getChildrenOfType(currentNode, 'jmix:bootstrapNavBarItem')}" var="child" varStatus="status">
                <template:module node="${child}" />
            </c:forEach>

        <c:if test="${not empty responsive and responsive.boolean}">
            </div>
        </div>
    </c:if>
    </div>
</div>
<c:if test="${renderContext.editMode}">
    <template:module path="*"/>
</c:if>
