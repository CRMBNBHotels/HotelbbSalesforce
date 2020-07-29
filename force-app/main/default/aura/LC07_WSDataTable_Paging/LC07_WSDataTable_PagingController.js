({
    onPageLoad : function(component, event, helper) {
        
        var currentPageNumber = component.get("v.pageNumber");
        var listRecords = component.get("v.listRecords");
        var mapPages = component.get('v.mapPages');
        var mapPagesDate = component.get('v.mapPagesDate');
        if(currentPageNumber == 1) {
            mapPages[1] = null;
        }
        if(currentPageNumber == 1) {
            mapPagesDate[1] = null;
        }
        component.set('v.mapPages', mapPages);
        component.set('v.mapPagesDate', mapPagesDate);
        var currentPageKey = component.get('v.pageKey');
        var currentPageDateKey = component.get('v.pageDateKey');
    },
    nextPage : function(component, event, helper) {
        var listRecords = component.get("v.listRecords");
        component.set("v.bDataLoaded", false);
        var currentPageNumber = component.get("v.pageNumber");
        currentPageNumber++;
        var mapPages = component.get('v.mapPages');
        var mapPagesDate = component.get('v.mapPagesDate');
        var currentPageKey;
        var currentPageDateKey;
        if(mapPages[currentPageNumber] != undefined) {             
            currentPageKey = mapPages[currentPageNumber];
          
        } else {
           currentPageKey = component.get("v.pageKey");
           mapPages[currentPageNumber] = currentPageKey;
        }
        if(mapPagesDate[currentPageNumber] != undefined) {             
            currentPageDateKey = mapPagesDate[currentPageNumber];
          
        } else {
           currentPageDateKey = component.get("v.pageDateKey");
           mapPagesDate[currentPageNumber] = currentPageDateKey;
        }
        component.set('v.mapPages', mapPages); 
        component.set('v.mapPagesDate', mapPagesDate); 
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
        console.log('Map page key ');
        console.log(component.get('v.mapPages'));
        console.log('Map page Date key ');
        console.log(component.get('v.mapPagesDate'));
    },
    previousPage : function(component, event, helper) {
        component.set("v.bDataLoaded", false);
        var mapPages = component.get('v.mapPages');
        var mapPagesDate = component.get('v.mapPagesDate');
        var currentPageNumber = component.get("v.pageNumber");
        currentPageNumber--;
        if(currentPageNumber > 1) {
            component.set('v.bDisableLeftButton', false);
        } else {
            component.set('v.bDisableLeftButton', true);
        }
        var currentPageKey = component.get("v.pageKey");
        var currentPageDateKey = component.get("v.pageDateKey");
        if(currentPageKey == null || currentPageKey.length == 0) {
            component.set('v.bDisableRightButton', true);
        } else {
            component.set('v.bDisableRightButton', false);
        }
        component.set('v.pageKey', mapPages[currentPageNumber]);
        component.set('v.pageDateKey', mapPagesDate[currentPageNumber]);
        //component.set('v.pageDateKey', '');
        component.set("v.pageNumber",currentPageNumber );
    }
})