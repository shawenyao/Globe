window.onload = function(){

    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    const date = urlParams.get("date");

    if(date == null){
        var today = new Date();
        var year = today.getFullYear();
        var month = today.getMonth() + 1;
        var day = today.getDate();
    }else{
        year_month_date = date.split("-");
        var year = Number(year_month_date[0]);
        var month =  Number(year_month_date[1]);
        var day =  Number(year_month_date[2]);
    }

    phase = getMoonPhase(year, month, day) + 1;
    document.getElementById("moon").src = "Output/Moon_" + phase + ".html";

    // console.log(year + "/" + month + "/" + day);
    // console.log(phase);
}
