import org.apache.taglibs.standard.functions.Functions
import org.jahia.services.content.JCRContentUtils
import org.jahia.services.render.RenderService
import org.jahia.services.render.Resource
import org.jahia.taglibs.jcr.node.JCRTagUtils

import javax.jcr.ItemNotFoundException

title = currentNode.properties['jcr:title']
baseline = currentNode.properties['j:baselineNode']
maxDepth = currentNode.properties['j:maxDepth']
startLevel = currentNode.properties['j:startLevel']
styleName = currentNode.properties['j:styleName']
layoutID = currentNode.properties['j:layoutID']
option = currentNode.properties['option']
responsive = currentNode.properties['responsive']
inverse = currentNode.properties['inverse']
// menuItemView = currentNode.properties['j:menuItemView'] ignored

def base;
if (!baseline || baseline.string == 'home') {
    base = renderContext.site.home
} else if (baseline.string == 'currentPage') {
    base = JCRTagUtils.getMeAndParentsOfType(renderContext.mainResource.node, "jnt:page")[0]
}
if (!base) {
    base = renderContext.mainResource.node
}
startLevelValue = startLevel ? startLevel.long : 0

def empty = true
def printMenu;
printMenu = { node, navMenuLevel, omitFormatting ->
    if (navMenuLevel == 1) {
        print("<div");
        if (layoutID) {
            print(" id=\"${layoutID.string}\"");
        }
        print(" class=\"navbar");
        if (option && !"".equals(option.string)) {
            print(" " + option.string);
        }
        if (inverse && inverse.boolean) {
            print(" navbar-inverse");
        }
        if (styleName) {
            print(" ${styleName.string}");
        }
        print("\">");
        print("<div class=\"navbar-inner\">");

        if (responsive && responsive.boolean) {
            print("<div class=\"container\">");
            print("<a class=\"btn btn-navbar\" data-toggle=\"collapse\" data-target=\".nav-collapse\">");
            print("<span class=\"icon-bar\"></span>");
            print("<span class=\"icon-bar\"></span>");
            print("<span class=\"icon-bar\"></span>");
            print("<span class=\"icon-bar\"></span>");
            print("</a>");
        }

        if (title) {
            print("<a class=\"brand\" href=\"" + node.url + "\">${Functions.escapeXml(title.string)}</a>")
        }

        if (responsive && responsive.boolean) {
            print("<div class=\"nav-collapse collapse\">");
        }
    }

    firstEntry = true;

    if (node) {
        children = JCRContentUtils.getChildrenOfType(node, "jmix:navMenuItem")
        def nbOfChilds = children.size();
        def closeUl = false;
        children.eachWithIndex() { menuItem, index ->
            itemPath = menuItem.path
            inpath = renderContext.mainResource.node.path == itemPath || renderContext.mainResource.node.path.startsWith(itemPath)
            selected = menuItem.isNodeType("jmix:nodeReference") ?
                renderContext.mainResource.node.path == menuItem.properties['j:node'].node.path :
                renderContext.mainResource.node.path == itemPath
            correctType = true
            if(menuItem.isNodeType("jmix:navMenu")){
                correctType = false
            }
            if (menuItem.properties['j:displayInMenu']) {
                correctType = false
                menuItem.properties['j:displayInMenu'].each() {
                    if (it.node != null) {
                        correctType |= (it.node.identifier == currentNode.identifier)
                    }
                }
            }
            if ((startLevelValue < navMenuLevel || inpath) && correctType) {
                hasChildren = navMenuLevel < maxDepth.long && JCRTagUtils.hasChildrenOfType(menuItem, "jnt:page,jnt:nodeLink,jnt:externalLink")
                if (startLevelValue < navMenuLevel) {
                    Resource resource = new Resource(menuItem, "html", (hasChildren && navMenuLevel == 1 ? "menuDropdown" : "menuElement"), currentResource.getContextConfiguration());
                    def render = RenderService.getInstance().render(resource, renderContext)
                    if (render != "") {
                        if (firstEntry) {
                            empty = false;
                            print("<ul class=\"" + (navMenuLevel == 1 ? "nav": "dropdown-menu") + "\">");
                            if (navMenuLevel == 2) {
                                Resource parentResource = new Resource(node, "html", "menuElement", currentResource.getContextConfiguration());
                                def parentRender = RenderService.getInstance().render(parentResource, renderContext);
                                if (parentRender != "") {
                                    print("<li>" + parentRender + "</li>");
                                    print("<li class=\"divider\"></li>");
                                }
                            }
                            closeUl = true;
                        }
                        def listItemCssClass = "";
                        if (hasChildren) {
                            if (navMenuLevel == 1) {
                                listItemCssClass = "dropdown";
                            } else {
                                listItemCssClass = "dropdown-submenu";
                            }
                        }
                        if (selected) {
                            if (!"".equals(listItemCssClass)) {
                                listItemCssClass += " ";
                            }
                            listItemCssClass += "active";
                        }
                        print "<li";
                        if (!"".equals(listItemCssClass)) {
                            print " class=\"${listItemCssClass}\"";
                        }
                        print ">";
                        print render
                    }
                    if (hasChildren) {
                        printMenu(menuItem, navMenuLevel + 1, true)
                    }
                    if (render != "") {
                        print "</li>"
                        firstEntry = false;
                    }
                } else if (hasChildren) {
                    printMenu(menuItem, navMenuLevel + 1, true)
                }
            }
            if (closeUl && index == (nbOfChilds - 1)) {
                print("</ul>");
                closeUl = false;
            }
        }

        if (empty && renderContext.editMode) {
            print "<ul class=\"nav\"><li class=\"active\"><a onclick=\"return false;\" href=\"#\">Page1</a></li><li><a onclick=\"return false;\" href=\"#\">Page2</a></li><li><a onclick=\"return false;\" href=\"#\">Page3</a></li></ul>"
            empty = false;
        }
    }

    if (navMenuLevel == 1) {
        if (responsive && responsive.boolean) {
            print("</div></div>");
        }
        print("</div></div>");
    }

}
// Add dependencies to parent of main resource so that we are aware of new pages at sibling level
try {
    currentResource.dependencies.add(renderContext.mainResource.node.getParent().getCanonicalPath());
} catch (ItemNotFoundException e) {
}
printMenu(base, 1, false)
print(RenderService.getInstance().render(new Resource(currentNode, "html", "addResources", currentResource.getContextConfiguration()), renderContext));
