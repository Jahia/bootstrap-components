<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="bootstrap" uri="http://www.jahia.org/tags/bootstrapLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<bootstrap:addCSS />
<div class="row${currentNode.properties.fluid.boolean ? '-fluid' : ''}">
    <c:forEach items="${jcr:getChildrenOfType(currentNode, 'jnt:bootstrapCell')}" var="child" varStatus="status">
        <c:set var="offsetClass" value=""/>
        <c:if test="${child.properties.offset.long gt 0}">
            <c:set var="offsetClass" value=" offset${child.properties.offset.long}"/>
        </c:if>
        <div class="span${child.properties.span.long}${offsetClass}">
            <template:module node="${child}"/>
        </div>
    </c:forEach>
</div>
<c:if test="${renderContext.editMode}">
    <template:module path="*"/>
</c:if>
