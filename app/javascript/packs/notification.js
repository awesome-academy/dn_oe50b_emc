$(document).ready(function()
{
    $("#open_notification").click(function()
    {
        $("#notificationContainer").fadeToggle(300);
        $("#notification_count").fadeOut("fast");
        return false;
    });

    $(document).click(function()
    {
        $("#notificationContainer").hide();
    });


    $("#notificationContainer").click(function()
    {
        return true;
    });

});
