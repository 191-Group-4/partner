function hideLoading() {
    // other code can be placed here 
    $("#loading").hide();
    // other code can be placed here
}

function showLoading() {
    // other code can be placed here 
    $("#loading").show();
    // other code can be placed here
}

function dosomething() {
    showLoading();
    // simulate a task that can take 3 seconds
    // afterwards show hide the loading GIF
    setTimeout("hideLoading()", 3000);
    return false;
}