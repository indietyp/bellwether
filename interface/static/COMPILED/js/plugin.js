var e=e||{};e.scope={};e.findInternal=function(c,a,g){c instanceof String&&(c=String(c));for(var d=c.length,b=0;b<d;b++){var h=c[b];if(a.call(g,h,b,c))return{i:b,v:h}}return{i:-1,v:void 0}};e.ASSUME_ES5=!1;e.ASSUME_NO_NATIVE_MAP=!1;e.ASSUME_NO_NATIVE_SET=!1;e.defineProperty=e.ASSUME_ES5||"function"==typeof Object.defineProperties?Object.defineProperty:function(c,a,g){c!=Array.prototype&&c!=Object.prototype&&(c[a]=g.value)};
e.getGlobal=function(c){return"undefined"!=typeof window&&window===c?c:"undefined"!=typeof global&&null!=global?global:c};e.global=e.getGlobal(this);e.polyfill=function(c,a){if(a){var g=e.global;c=c.split(".");for(var d=0;d<c.length-1;d++){var b=c[d];b in g||(g[b]={});g=g[b]}c=c[c.length-1];d=g[c];a=a(d);a!=d&&null!=a&&e.defineProperty(g,c,{configurable:!0,writable:!0,value:a})}};e.polyfill("Array.prototype.find",function(c){return c?c:function(a,c){return e.findInternal(this,a,c).v}},"es6","es3");
(function(){$(function(){return c()});var c=function(a){a=void 0===a?document:a;$("[data-trigger='[dropdown/toggle]']",a).off("click");$("[data-trigger='[dropdown/toggle]']",a).on("click",function(a){a.stopImmediatePropagation();$(".expand").not($(".expand",this.parentElement)).slideUp();$(".menu > ul > li > a").not($(this)).removeClass("navActive");$(this).toggleClass("navActive");$(".expand",this.parentElement).slideToggle()});$("[data-trigger='[modal/open]']",a).off("click");$("[data-trigger='[modal/open]']",
a).on("click",function(){$(".overlay").fadeIn("fast");$("[data-component='"+this.getAttribute("data-trigger-target")+"']").fadeIn("fast")});$("[data-trigger='[server/item]']",a).off("click");$("[data-trigger='[server/item]']",a).on("click",function(){$(this).toggleClass("toggableListActive");$(this).find(".content").fadeToggle("fast")});$("[data-trigger='[modal/close]']",a).off("click");$("[data-trigger='[modal/close]']",a).on("click",function(){var a;$(".overlay").fadeOut("fast");for(a=this.parentElement;!$(a).hasClass("modal");)a=
a.parentElement;$(a).fadeOut("fast")});$(".overlay",a).off("click");$(".overlay",a).on("click",function(){$(".overlay").fadeOut("fast");$(".modal").fadeOut("fast")});$("[data-trigger='[system/messages/open]']",a).off("click");$("[data-trigger='[system/messages/open]']",a).on("click",function(){$(".notificationsArea",this).fadeToggle("fast");$($("a",this)[0]).toggleClass("userMenuActive")});$(".searchOverlay",a).off("click");$(".searchOverlay",a).on("click",function(){$(".searchOverlay").fadeOut("fast");
$(".searchArea").fadeOut("fast");$(".search").animate({width:"20%"},250)});$('[data-trigger="[announcement/expand]"]',a).off("click");$('[data-trigger="[announcement/expand]"]',a).on("click",function(){$(".announcement-expand",this).slideToggle()});$('[data-trigger="[user/toggle]"]',a).off("click");$('[data-trigger="[user/toggle]"]',a).on("click",function(){$(".dropdown",this).fadeToggle("fast")});$(".search input",a).off("click");$(".search input",a).on("click",function(){$(".modal").fadeOut("fast");
$(".searchOverlay").fadeIn("fast");$(".searchArea").fadeToggle("fast");$(".search").animate({width:"30%"},250)});$(".timeTable tbody tr td .checkmarkContainer",a).off("mousedown");$(".timeTable tbody tr td .checkmarkContainer",a).on("mousedown",function(){$(this.parentElement.parentElement).toggleClass("logSelected");$(".checkboxDialogue").not($(".checkboxDialogue",this.parentElement)).fadeOut("fast");$("input",this)[0].checked?$(".checkboxDialogue",this.parentElement).fadeOut("fast"):$(".checkboxDialogue",
this.parentElement).fadeIn("fast")});$(".timeTable tbody tr td .checkboxDialogue .paginationTabsDanger",a).off("click");$(".timeTable tbody tr td .checkboxDialogue .paginationTabsDanger",a).on("click",function(){$(this.parentElement).fadeOut("fast");var a=$(this).parent("tbody")[0];$("tr.logSelected",a).removeClass("logSelected");$("input:checked",a).forEach(function(a){return a.checked=!1})});$('[data-trigger="[composer/select/open]"]',a).off("click");$('[data-trigger="[composer/select/open]"]',
a).on("click",function(){var a=$(this).parent("._Dynamic_Select");var b=$("._Dynamic_Layer",a);a.toggleClass("_Dynamic_Select_Activated");$("._Select",a).toggleClass("selected");b.toggleClass("selected");b.hasClass("selected")&&(b.on("click",function(b){composer_select_open.call(this);var d=new MouseEvent(b.type,b);b=document.elementFromPoint(b.clientX,b.clientY);b.matches("input")&&b.focus();a=$(this).parent("._Dynamic_Select");$("._Title",a)[0]!==b&&b.dispatchEvent(d);return $(this).off("click")}),
$("._Select_Search input",a)[0].focus())});var c=[];$('[data-trigger="[composer/select/choose]"]',a).off("click");$('[data-trigger="[composer/select/choose]"]',a).on("click",function(){if($("._Title",$(this).parent("._Dynamic_Select"))[0].hasAttribute("data-select-multiple")){var a=$(this).find("p").text();var b=$(this).find(".checkmarkContainer input");if(b.is(":checked"))for(b.prop("checked",!1),b=0;b<c.length;){if(c[b]===a){c.splice(b,1);break}b+=1}else b.prop("checked",!0),c.push(a);$(this).closest("._Dynamic_Select").find("._Title").text("("+
c.length+") selections")}else $(this).parent("._Dynamic_Select").toggleClass("_Dynamic_Select_Activated"),$("._Select",$(this).parent("._Dynamic_Select")).toggleClass("selected"),$("._Title",$(this).parent("._Dynamic_Select"))[0].textContent=$("p",this)[0].textContent,$("._Title",$(this).parent("._Dynamic_Select"))[0].value=$("p",this)[0].value});$('[data-trigger="[composer/select/steam]"]',a).off("keyup");$('[data-trigger="[composer/select/steam]"]',a).on("keyup",function(){});$('[data-trigger="[composer/select/search]"]',
a).off("keyup");$('[data-trigger="[composer/select/search]"]',a).on("keyup",function(a){var b=[];var d=this.value;var c=$(this).parent("._Select");c=$("._Container",c);$("p",c).forEach(function(a){b.push(a)});if(""===this.value)b.forEach(function(a){return $(a).parent("li")[0].style.display="block"});else if(!(90<=a.which||48>=a.which)){var f=[];b.forEach(function(a){$(a).parent("li")[0].style.display="none";return f.push([a,distance(a.textContent,d)])});f.sort(function(a,b){return b[1]-a[1]});f=
f.slice(0,5);f.forEach(function(a){return $(a[0]).parent("li")[0].style.display="block"})}});$("[data-trigger='[ct/switch]']",a).off("click");$("[data-trigger='[ct/switch]']",a).on("click",function(){$(".paginationTabSelected",this.parentElement).removeClass("paginationTabSelected");var a=this.getAttribute("data");$(this).addClass("paginationTabSelected");history.replaceState({location:window._.location,scope:window._.scope},null,"#"+a);window.lazy(this.parentElement.getAttribute("data-target"),"")});
$("[data-trigger='[ct/toggle]']",a).off("change");$("[data-trigger='[ct/toggle]']",a).on("change",function(){var a;for(a=this.parentElement;"tr"!==a.nodeName.toLowerCase();)a=a.parentElement;var b=-1;window.batch.forEach(function(c){if(c.getAttribute("data-id")===a.getAttribute("data-id"))return b=window.batch.indexOf(c)});-1!==b&&window.batch.splice(b,1);if(this.checked)return window.batch.push(a)});$("[data-trigger='[table/choice]']",a).off("click");$("[data-trigger='[table/choice]']",a).on("click",
function(){var a=$(this).parent(".modalSelect");var b=this.getAttribute("data-mode");switch($("select",a)[0].value){case "delete":return window.api.remove(b,window.batch,!0)}});$("[data-trigger='[modal/action]']",a).off("click");$("[data-trigger='[modal/action]']",a).on("click",function(){var a=$(this).parent(".modal");var b=this.getAttribute("data-mode");switch(this.getAttribute("data-mode")){case "delete":return window.api.remove(b,a[0],!1)}});$("[data-trigger='[grid/delete]']",a).off("click");
$("[data-trigger='[grid/delete]']",a).on("click",function(){var a=$(this).parent(".serverGridItem");var b=this.getAttribute("data-mode");return window.api.remove(b,a[0],!1)});$('[data-trigger="[clip/copy]"]',a).off("click");$('[data-trigger="[clip/copy]"]',a).on("click",function(){return window.style.copy(this.getAttribute("data-clipboard-text"))});$('[data-trigger="[input/duration]"]',a).off("keypress");$('[data-trigger="[input/duration]"]',a).on("keypress",function(a){a.preventDefault();var b=this.selectionStart;
if(/[PTYDHMS0-9]/.test(a.key.toUpperCase()||1!==a.key.length)){var c=a.target.value;c=c.substr(0,b)+a.key+c.substr(b);c=c.toUpperCase();"P"!==c[0]&&(c="P"+c,b+=1);a.target.value=c;this.setSelectionRange(b+1,b+1);try{return $(this).removeClass("invalid"),new Duration(c)}catch(k){return $(this).addClass("invalid")}}});$('[data-trigger="[input/range]"]',a).off("keypress");$('[data-trigger="[input/range]"]',a).on("keypress",function(a){a.preventDefault();var b=this.selectionStart;var c=this.getAttribute("data-min");
var d=this.getAttribute("data-max");if(/[0-9]/.test(a.key.toUpperCase()||1!==a.key.length)){var f=a.target.value;f=f.substr(0,b)+a.key+f.substr(b);f=parseInt(f);f>parseInt(d)&&(f=d);f<parseInt(c)&&(f=c);a.target.value=f;return this.setSelectionRange(b+1,b+1)}})};window._={init:c,menu:function(){$(".paginationTabs").forEach(function(a){var c;var d=a.children;var b=[];var h=0;for(c=d.length;h<c;h++)a=d[h],window.location.hash&&window.location.hash.substring(1)===a.getAttribute("data")?b.push($(a).addClass("paginationTabSelected")):
b.push(void 0);return b})}};window.batch=[]}).call(this);