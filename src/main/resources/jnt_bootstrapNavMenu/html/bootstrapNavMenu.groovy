import org.apache.commons.lang.StringUtils
import org.jahia.services.content.JCRContentUtils
import org.jahia.services.render.RenderService
import org.jahia.services.render.Resource
import org.jahia.taglibs.jcr.node.JCRTagUtils

import javax.jcr.ItemNotFoundException
import javax.jcr.PathNotFoundException

baseline = currentNode.properties['j:baselineNode']
maxDepth = currentNode.properties['j:maxDepth']
startLevel = currentNode.properties['j:startLevel']
styleName = currentNode.properties['j:styleName']
layoutID = currentNode.properties['j:layoutID']
position = currentNode.properties['position']
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
def entries=0;
printMenu = { node, navMenuLevel, omitFormatting ->
//    System.out.println("Menu for node "+(entries++)+" "+node.path+"and nav menu level is "+navMenuLevel);
    firstEntry = true;

    if (node) {
        children = JCRContentUtils.getChildrenOfType(node, "jmix:navMenuItem", 0)
        def nbOfChilds = children.size();
        def closeUl = false;
        children.eachWithIndex() { menuItem, index ->
            itemPath = menuItem.path
            def pathMainResource = renderContext.mainResource.node.path
            inpath = pathMainResource == itemPath || StringUtils.substringBeforeLast(pathMainResource,"/").startsWith(itemPath)
            def referenceIsBroken = false;
            if (menuItem.isNodeType("jmix:nodeReference")) {
                try {
                    currentResource.dependencies.add(menuItem.properties['j:node'].string);
                } catch (ItemNotFoundException e) {
                }
                try {
                    if (menuItem.properties['j:node'].node != null) {
                        selected = renderContext.mainResource.node.path == menuItem.properties['j:node'].node.path;
                    } else {
                        selected = false;
                        referenceIsBroken = true;
                    }
                } catch (ItemNotFoundException e) {
                    selected = false;
                    referenceIsBroken = true;
                }
            } else {
                selected = renderContext.mainResource.node.path == itemPath
            }
            correctType = true
            if(menuItem.isNodeType("jmix:navMenu")){
                correctType = false
            }
            if (menuItem.properties['j:displayInMenuName']) {
                correctType = false
                menuItem.properties['j:displayInMenuName'].each() {
                    correctType |= (it.string == currentNode.name)
                }
            }
            // here we have to add <= to startLevel + maxDepth to be sure to go at least on the sub children at least once
            if (!referenceIsBroken && correctType && ( navMenuLevel <= (startLevelValue + maxDepth.long) || inpath)) {
                // Here we check that the current nav menu level is less than start + maxDepth so we do not display a dropdown menu entry without any entries in it
                hasChildren = navMenuLevel < (startLevelValue+maxDepth.long) && JCRTagUtils.hasChildrenOfType(menuItem, "jnt:page,jnt:nodeLink,jnt:externalLink")
//                System.out.println("Menu for node "+(entries++)+" "+menuItem.path+ " and has children is "+hasChildren);
                if (startLevelValue < navMenuLevel) {
                    def isCurrentMenuTopLevel = navMenuLevel == (startLevelValue + 1)
                    Resource resource = new Resource(menuItem, "html", (hasChildren && isCurrentMenuTopLevel ? "menuDropdown" : "menuElement"), currentResource.getContextConfiguration());
                    currentResource.getDependencies().add(menuItem.getCanonicalPath())
                    def render = RenderService.getInstance().render(resource, renderContext)
                    if (render != "") {
                        if (firstEntry) {
                            empty = false;
                            print("<ul");
                            if (isCurrentMenuTopLevel && layoutID) {
                                print(" id=\"${layoutID.string}\"");
                            }
                            print(" class=\"");
                            if (isCurrentMenuTopLevel) {
                                print("nav");
                                if (position && !"".equals(position.string)) {
                                    print(" pull-${position.string}");
                                }
                                if (styleName) {
                                    print(" ${styleName.string}");
                                }
                            } else {
                                print("dropdown-menu");
                            }
                            print("\">");
                            closeUl = true;
                        }
                        def listItemCssClass = "";
                        if (hasChildren) {
                            if (isCurrentMenuTopLevel) {
                                listItemCssClass = "dropdown";
                            } else {
                                listItemCssClass = "dropdown-submenu";
                            }
                        }
                        if (selected || inpath) {
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
            print "<ul class=\"nav";
            if (position) {
                print(" pull-${position.string}");
            }
            if (styleName) {
                print(" ${styleName.string}");
            }
            print "\"><li class=\"active\"><a onclick=\"return false;\" href=\"#\">Page1</a></li><li><a onclick=\"return false;\" href=\"#\">Page2</a></li><li><a onclick=\"return false;\" href=\"#\">Page3</a></li></ul>"
            empty = false;
        }
    }
}
// Add dependencies to parent of main resource so that we are aware of new pages at sibling level
try {
    currentResource.dependencies.add(renderContext.mainResource.node.getParent().getCanonicalPath());
} catch (ItemNotFoundException e) {
}
printMenu(base, 1, false)
print(RenderService.getInstance().render(new Resource(currentNode, "html", "addResources", currentResource.getContextConfiguration()), renderContext));
