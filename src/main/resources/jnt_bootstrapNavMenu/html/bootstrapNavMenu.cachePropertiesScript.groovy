import org.jahia.taglibs.jcr.node.JCRTagUtils

// currentNode is not available here in 7.2 with cache refactoring
// because this script will be call for key generation before the cache Filter
// we need to use currentResource.node to load the current node
baseline = currentResource.node.properties['j:baselineNode']
maxDepth = currentResource.node.properties['j:maxDepth']

def base;
if (!baseline || baseline.string == 'home') {
    base = renderContext.site.home
} else if (baseline.string == 'currentPage') {
    base = JCRTagUtils.getMeAndParentsOfType(renderContext.mainResource.node, "jnt:page")[0]
}
if (!base) {
    base = renderContext.mainResource.node
}

def v = base.path;

1.upto(maxDepth.long, {
    v += "(/[^/]+)?"
})

cacheProperties.put("cache.dependsOnVisibilityOf", v)
