<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="bootstrap" uri="http://www.jahia.org/tags/bootstrapLib" %>
<template:addResources type="css" resources="event.css"/>
<bootstrap:addCSS/>

<div><!--start eventsListItem -->
    <div class="eventsListItem">
        <div class="eventsInfoDate">
            <div class="eventsDate">
                <span class="day"><fmt:formatDate pattern="dd" value="${currentNode.properties.startDate.time}"/></span>
                <span class="month"><fmt:formatDate pattern="MM"
                                                    value="${currentNode.properties.startDate.time}"/></span>
                <span class="year"><fmt:formatDate pattern="yyyy"
                                                   value="${currentNode.properties.startDate.time}"/></span>
            </div>
            <c:if test="${not empty currentNode.properties.endDate}">
                <div class="eventsTxtDate">
                    <span><fmt:message key='label.to'/></span>
                </div>
                <div class="eventsDate">
                    <span class="day"><fmt:formatDate pattern="dd"
                                                      value="${currentNode.properties.endDate.time}"/></span>
                    <span class="month"><fmt:formatDate pattern="MM"
                                                        value="${currentNode.properties.endDate.time}"/></span>
                <span class="year"><fmt:formatDate pattern="yyyy"
                                                   value="${currentNode.properties.endDate.time}"/></span>
                </div>
            </c:if>
        </div>
    </div>
    <div class="eventsBody"><!--start eventsBody -->
        <p class="text-right pull-right text-info"><i
                class="icon-map-marker"></i><span>${currentNode.properties.location.string}</span>
            <c:if test="${not empty currentNode.properties.eventsType.string}">
                <i class="icon-info-sign"></i>
            <span>
			<fmt:message key='jnt_event.eventsType.${currentNode.properties.eventsType.string}'/>
		</span>
            </c:if>
            <small><i class="icon-calendar"></i>&nbsp;<span class="info"><fmt:formatDate
                    value="${currentNode.properties.startDate.time}" type="both" dateStyle="long"
                    timeStyle="short"/></span></small>
            <c:if test="${not empty currentNode.properties.endDate}">
                <small>&nbsp;<fmt:message key="label.to"/>&nbsp;<span class="info"><fmt:formatDate
                        value="${currentNode.properties.endDate.time}" type="both" dateStyle="long"
                        timeStyle="short"/></span></small>
            </c:if>
        </p>
        <h4><jcr:nodeProperty node="${currentNode}" name="jcr:title"/></h4>

        <div class="eventsResume">
            ${currentNode.properties.body.string}
        </div>
        <jcr:nodeProperty node="${currentNode}" name="j:defaultCategory" var="cat"/>
        <c:if test="${cat != null}">
            <em>
            <span class="text-info text-left"><fmt:message key='label.categories'/>:&nbsp;</span>
            <c:forEach items="${cat}" var="category" varStatus="status">
                <c:if test="${not status.first}">,&nbsp;</c:if>
                <i class="icon-tag"></i> <span class="text-info">${category.node.displayableName}</span>
            </c:forEach>
            </em>
        </c:if>
    </div>
</div>