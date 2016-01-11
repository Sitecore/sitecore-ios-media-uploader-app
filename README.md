![]
<br /> 
<br /> 
<br /> 

IOS Media Uploader FAQs
=======================
<br /> 
How do I start using the Media Uploader application?
----------------------------------------------------

Before you can use the Media Uploader application, you must add at least one site that you can upload media files to.

![][1]

To add a site, on the main screen of the application, on the navigation bar, tap the **Settings** button, and then in the **Sites** group, tap **Add new site...**

![][2]

Enter the URL of your Sitecore instance, a site path (for example, /sitecore/shell for a shell site), the Sitecore CMS domain, your user name, your password, and then tap **Save**.

![][3]
<br /> <br /> 
Who do I contact if I cannot add my site?
-----------------------------------------

Contact the Sitecore partner that created your Sitecore solution.
<br /> <br /> 
Which version of Sitecore CMS is required to use the application?
-----------------------------------------------------------------

Sitecore CMS 6.6 SP1 or later.

In addition, you should have the Sitecore Item Web API 1.2.0 rev. 140128 or later installed.
<br /> <br /> 
Can I add more than one site as an upload target?
-------------------------------------------------

Yes, you can add as many sites as you need.

However, there can only be one active upload target. To see which of your sites is currently selected as the upload target, go to **Settings,** and under the **Sites** group, you can view a list of sites. The target site is white and displayed with the **Upload** button ![][4]. Disabled sites are displayed with the **Upload disabled** button ![][5].

![][6]
<br /> <br /> 
How do I edit or delete my sites?
---------------------------------

Tap **Settings**, **Sites**, and then tap the site you want to edit or delete. In **Site settings,** make the necessary changes, and on the navigation bar, tap **Done**.

To delete the site, tap **Delete**.

![][7]
<br /> <br /> 
How do I select the site that I want to upload media files to?
--------------------------------------------------------------

If you only have one site, it is always used as the upload target.

If you have more than one site, you can select the upload destination site in **Settings**, **Sites**. In the sites list, you can see icons on the left of the site paths. The target site is white and displayed with the **Upload** button ![][4]. Disabled sites are displayed with the **Upload disabled** button ![][5].

To start using a disabled site as an upload destination, tap the **Upload disabled** button for the site. The button changes to the **Upload** button. The previous upload target becomes disabled. The application uploads the media files to the site that you select as the upload destination.

![][8]

When you add a new site, the application uses it as the upload destination by default until you specify another site.
<br /> <br /> 
How do I select a folder to upload media files to?
--------------------------------------------------

The root folder of the Media library is selected as the upload target by default. To change the folder, in the **Site settings** for the site, in the **Upload** group, tap the folder name and select another folder from the list of folders that appears.

![][9]
<br /> <br /> 
Can I use multiple folders from one site as individual upload targets?
----------------------------------------------------------------------

Yes.

To use multiple folders, you should add each of them to the sites list. Add the site as usual and then in **Site Settings**, in the **Upload** group, change the default media library folder to the desired target folder for each upload destination. Repeat these steps for each folder you want to upload to.
<br /> <br /> 
Can I upload media files to multiple sites?
-------------------------------------------

No.

Media files are only uploaded to the upload target. The upload target is displayed with the **Upload** button![][4] in the sites list.
<br /> <br /> 
What media formats can I upload?
--------------------------------

You can upload all of the image and video formats supported by your iOS device.
<br /> <br /> 
What settings can I apply to media files?
-----------------------------------------

You can only change the maximum size of uploaded images. This setting is not applicable to video files.

To change the maximum size of uploaded images, go to **Settings** and in the **Upload image size** setting, select one of available sizes:

-   *Small*: 800x600 px

-   *Medium*: 1024x768 px

-   *Actual*: the actual size of an image

![][10]

This setting only affects the maximum size of an image.

If the image is smaller than the maximum size, it is not resized.

If the image is larger than the maximum size, it is decreased proportionally to keep the aspect ratio of the image.
<br /> <br /> 
How can I upload a media file?
------------------------------

If you have already set up your sites, you can start uploading media files.

1.  On the main screen of the Media Uploader application, tap **Upload**.

    ![][11]

2.  In the **Photos** view, either select a file to upload or tap **Camera** ![][12] to take a photo and upload it to the Media library.

    ![][13]

3.  On the **Upload** screen, enter a name of the selected file and define a location.

    ![][14]

To start uploading immediately, tap **Upload** or to postpone uploading, tap **Upload later**.
<br /> <br /> 
Can I delay the upload of media files?
--------------------------------------

Yes.

To delay uploading media files, follow all the steps described for the regular upload, but tap the **Upload later** button instead of the **Upload** button. The selected file is added to the **Pending** list and you can upload it when it is convenient.
<br /> <br /> 
How do I know if there are files pending upload?
------------------------------------------------

The **Pending** button on the main screen of the application displays the status of file uploads. When it is inactive, there are no items pending upload. When it is active, a label with a number indicates the number of files that are pending upload. You can upload these files by tapping the **Pending** button.\
![][15]
<br /> <br /> 
How do I manage files in the Pending list?
------------------------------------------

To open the **Pending** list, on the main screen of the application, tap the **Pending** button. You have the following options:

-   To delete a file that you don’t want to upload, tap the **Delete** button ![][16] on the selected file.

-   To upload all the files that are pending upload in the **Pending** list, tap the **Upload** button.

    ![][17]

-   To cancel uploading, tap the **Cancel** button while the upload is in progress. Note that this only cancels the currently in-progress and pending file uploads – it does not remove successfully completed uploads.

    ![][18]

    You can apply filters to media files that you upload using controls on the navigation bar. Tap *Completed* to show only the files that have been successfully uploaded. Tap *Not Completed* to show in-progress and cancelled file uploads. Tap *All* to clear the filter and show all files.
    
    ![][19]
<br /> <br /> 

From where can I upload a media file?
-------------------------------------

You can upload media files from any of the photo and video albums on your iOS device, or you can take photos and videos using your device camera and upload these directly.
<br /> <br /> 
How do I browse the Media library of the selected site?
-------------------------------------------------------

To open the **Media browser**, on the main screen of the application, tap the **Browse** button. The **Media browser** has the same structure as the Media library of your site. You can view files and folders as thumbnails. Video files are not displayed in the **Media browser**.

![][20]
<br /> <br /> 
Can I select a custom top-level folder for the Media browser?
-------------------------------------------------------------

When you open the Media Browser, the folder that you have selected as your upload destination is used as the default entry point. However, you can navigate to other folders, including the root folder of the Media library, which is the top-level folder of the Media Browser.
<br /> <br /> 
How do I switch between sites in the Media browser?
---------------------------------------------------

In the **Media browser**, tap the **Browse** button ![][21] and select the relevant site from the list.
<br /> <br /> 
How do I refresh the data of the Media browser?
-----------------------------------------------

To refresh the folder data, in the **Media browser**, on the navigation bar, tap the **Refresh** button 

![][22].
<br /> <br /> 
Can I perform any actions on files in the Media library?
--------------------------------------------------------

No.

You can only browse existing media files or upload new ones.
<br /> <br /> 
Can I use the Media Uploader when I am offline?
-----------------------------------------------

Yes, but when you are offline, you only have the *Upload later* functionality available.

![][23]

As soon as the application can connect to the server, the selected files are added to the **Pending** list and you can upload them.
<br /> <br /> 
Is the Media Uploader application available for all iOS devices?
----------------------------------------------------------------

The application is designed for use on iPhone and iPad with iOS 7.0 and later.
<br /> <br /> 
Where can I found out more about the Media Uploader application?
----------------------------------------------------------------

For more information about the Media Uploader application, please refer to the [Media Uploader iOS app] section on the SDN.

  []: resources-readme/image1.jpg
  [1]: resources-readme/image2.png
  [2]: resources-readme/image3.png
  [3]: resources-readme/image4.png
  [4]: resources-readme/image5.png
  [5]: resources-readme/image6.png
  [6]: resources-readme/image7.png
  [7]: resources-readme/image8.png
  [8]: resources-readme/image9.PNG
  [9]: resources-readme/image10.png
  [10]: resources-readme/image11.png
  [11]: resources-readme/image12.png
  [12]: resources-readme/image13.png
  [13]: resources-readme/image14.png
  [14]: resources-readme/image15.png
  [15]: resources-readme/image16.png
  [16]: resources-readme/image17.png
  [17]: resources-readme/image18.png
  [18]: resources-readme/image19.png
  [19]: resources-readme/image20.png
  [20]: resources-readme/image21.png
  [21]: resources-readme/image22.png
  [22]: resources-readme/image23.png
  [23]: resources-readme/image24.jpeg
  [Media Uploader iOS app]: http://sdn.sitecore.net/Products/Sitecore%20Mobile%20Apps/Apple%20iOS%20Apps/Media%20Uploader%20iOS%20app.aspx
