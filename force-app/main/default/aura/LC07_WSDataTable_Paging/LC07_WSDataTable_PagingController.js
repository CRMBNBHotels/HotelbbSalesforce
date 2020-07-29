({
    onPageLoad : function(component, event, helper) {
        var currentPageNumber = component.get("v.pageNumber");
        var listRecords = component.get("v.listRecords");
        var mapPages = component.get('v.mapPages');
        if(currentPageNumber == 1) {
            mapPages[1] = null;
        }
        component.set('v.mapPages', mapPages);
        var currentPageKey = component.get('v.pageKey');
    },
    nextPage : function(component, event, helper) {
        var listRecords = component.get("v.listRecords");
        component.set("v.bDataLoaded", false);
        var currentPageNumber = component.get("v.pageNumber");
        currentPageNumber++;
        var mapPages = component.get('v.mapPages');
        var currentPageKey;
        if(mapPages[currentPageNumber] != undefined) {             
            currentPageKey = mapPages[currentPageNumber];
        } else {
           currentPageKey = component.get("v.pageKey");
           mapPages[currentPageNumber] = currentPageKey;
        }
        component.set('v.mapPages', mapPages); 
        component.set("v.pageNumber",currentPageNumber );
        if(currentPageNumber > 1) {
            component.set('v.bDisableLeftButton', false);
        } else {
            component.set('v.bDisableLeftButton', true);
        }
        if(currentPageKey == null || currentPageKey.length == 0 || listRecords.length == 0) {
            component.set('v.bDisableRightButton', true);
        } else {
            component.set('v.bDisableRightButton', false);
        }
    },
    previousPage : function(component, event, helper) {
        component.set("v.bDataLoaded", false);
        var mapPages = component.get('v.mapPages');
        var currentPageNumber = component.get("v.pageNumber");
        currentPageNumber--;
        if(currentPageNumber > 1) {
            component.set('v.bDisableLeftButton', false);
        } else {
            component.set('v.bDisableLeftButton', true);
        }
        var currentPageKey = component.get("v.pageKey");
        if(currentPageKey == null || currentPageKey.length == 0) {
            component.set('v.bDisableRightButton', true);
        } else {
            component.set('v.bDisableRightButton', false);
        }
        component.set('v.pageKey', mapPages[currentPageNumber]);
        component.set("v.pageNumber",currentPageNumber );
    }
})