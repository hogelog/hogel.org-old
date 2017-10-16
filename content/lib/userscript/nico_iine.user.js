// ==UserScript==
// @name           NicoNico Iine
// @namespace      http://hogel.org/
// @include        http://www.nicovideo.jp/watch/*
// ==/UserScript==
var url = encodeURI(location.href);
var node = document.createElement("iframe");
node.setAttribute("src", 'http://www.facebook.com/plugins/like.php?href='+url+'&amp;layout=standard&amp;show_faces=true&amp;width=450&amp;action=like&amp;colorscheme=light&amp;height=80');
node.setAttribute("scrolling", "no");
node.setAttribute("frameborder", "0");
node.setAttribute("style", "border:none; overflow:hidden; width:100%; height:80px;");
node.setAttribute("allowTransparency", "true");
var video_article = document.getElementById("video_article");
if (video_article) {
    video_article.parentNode.appendChild(node);
} else {
    var h1 = document.getElementsByTagName("h1")[0];
    h1.parentNode.appendChild(node);
}
