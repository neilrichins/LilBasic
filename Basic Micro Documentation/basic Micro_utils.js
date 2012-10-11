//------------------------------------------------------------------------
// application
//------------------------------------------------------------------------

var g_theApp = parent.g_theApp;

var isNav, isIE;
var layerRef="";
var layerStyleRef = "";
var styleSwitch = "";

if (navigator.appName == "Netscape")
	{
	isNav = true;	
	layerStyleRef="layer.";
	layerRef="document.layers"; 
	styleSwitch=""; 
	}
else
	{ 
	isIE = true;
	layerStyleRef="layer.style."; 
	layerRef="document.all"; 
	styleSwitch=".style"; 
	}

//------------------------------------------------------------------------
// CImage Object
//------------------------------------------------------------------------

function CImage(id)
	{
	this.id = id;
	
	if ( isIE )
		this.image = eval('document.images.' + this.id);
	else
		this.image = eval('document.images[\"' + this.id + '\"]');
	
	this.put_Source = SetSource;
	this.get_Source = GetSource;
	this.put_Title = put_Title;
	this.get_Title = get_Title;
	}

function SetSource(newsrc)
	{
	if ( this.image )
		this.image.src = newsrc;
	}
	
function GetSource()
	{
	if ( this.image )
		return this.image.src;
	}

function put_Title(txt)
	{
	if ( this.image && isIE )
		this.image.title = txt;
	}
	
function get_Title(txt)
	{
	if ( this.image && isIE )
		return this.image.title;
	}

//------------------------------------------------------------------------
// CDiv Object
//------------------------------------------------------------------------

function CDiv(id, doc)
	{
	this.id = id;
	this.layer = FindLayer(id, doc);	

	this.Show = Show;
	this.Hide = Hide;
	this.IsHidden = IsHidden;
	this.put_innerHTML = put_innerHTML;
	}
	
function Show()
	{
	if ( this.layer )
		eval('this.' + layerStyleRef + 'visibility' + '= "visible"');
	}
	
function Hide()
	{
	if ( this.layer )
		eval('this.' + layerStyleRef + 'visibility' + '= "hidden"');
	}
	
function IsHidden()
	{
	if ( this.layer && 
		 (-1 != eval('this.' + layerStyleRef + 'visibility').indexOf("hid")) )
		return true;
	
	return false;
	}

function put_innerHTML(txt)
	{
	if ( this.layer )
		{
		if ( isIE )
			this.layer.innerHTML = txt;
		else
			{
			this.layer.document.writeln(txt);
			this.layer.document.close();
			}
		}
	}
	
//------------------------------------------------------------------------
// Page View Window Size/Zoom
//------------------------------------------------------------------------

// zoom_onchange - Handles zoom list box change events.  This list box is
// assumed to be in a different frame than the content we're zooming, 
// so he zoom call is dispatched back to the content frame.

function SetZoomControl(f)
	{
	if ( !parent.g_NavBarLoaded )
		return;
		
	var s = parent.frmNavBar.document.all.zoomForm.zoomFactor;
	
	if ( -1 != f )
		f *= 100;
	
	for ( i = 0 ; i < s.options.length ; i++ )
		{
		if ( s.options[i].value == f )
			{
			s.selectedIndex = i;
			break;
			}
		}
	}

function zoom_onchange(val)
	{
	if ( g_theApp.ActiveViewMgr )
		g_theApp.ActiveViewMgr.put_Zoom(parseInt(val));
	}
	
// The following methods are intended to be called in the context
// of the drawing frame.

//------------------------------------------------------------------------
// CViewMgr Object
//------------------------------------------------------------------------

function CViewMgr()
	{
	this.onLoad = ViewMgrOnLoad;
	this.onResize = ViewMgrOnResize;
	this.put_Zoom = ViewMgrSetZoom;
	this.get_Zoom = ViewMgrGetZoom;
	this.ApplyZoom = ViewMgrApplyZoom;
	}

function ViewMgrOnLoad()
	{
	this.id = "ConvertedImage";
	this.zoomFactor = -1;
	this.zoomLast = -1;
	this.origWH = 1;
	this.origWidth = 100;
	
	if ( isIE )
		{
		this.s = document.all(this.id).style;

		if ( this.s )
			{
			this.s.position = "absolute";
			this.origWidth = this.s.pixelWidth;
			this.origWH = this.s.pixelWidth / this.s.pixelHeight;
			}
		}
	else
		this.s = null;
		
	this.onResize = ViewMgrOnResize;
	this.put_Zoom = ViewMgrSetZoom;
	this.get_Zoom = ViewMgrGetZoom;
	this.ApplyZoom = ViewMgrApplyZoom;
	
	SetZoomControl(this.zoomFactor);
	this.onResize();
	}

function ViewMgrSetZoom(val)
	{
	if ( !this.s )
		return;
		
	if ( val == this.zoomFactor )
		return;
		
	if ( (2 <= val) && (3000 >= val) )
		{
		this.zoomLast = this.zoomFactor;
		this.zoomFactor = (val / 100);
		document.body.scroll= "yes";
		this.ApplyZoom();
		}
	else if ( -1 == val )
		{
		this.zoomLast = this.zoomFactor;
		this.zoomFactor = val;
		document.body.scroll= "no";
		this.onResize();
		}
	}
	
function ViewMgrGetZoom()
	{
	return this.zoomFactor;
	}

var cxmgn = 10;
var cymgn = 10;
	
function ViewMgrApplyZoom()
	{
	var f, cx, cy, pw, ph, vw, vh;
	
	f = this.zoomFactor / (this.s.pixelWidth / this.origWidth);
	
	vw = document.body.clientWidth;
	vh = document.body.clientHeight;
	
	cx = f * (document.body.scrollLeft + (vw / 2) - this.s.posLeft);
	cy = f * (document.body.scrollTop + (vh / 2) - this.s.posTop);
	
	pw = f * this.s.pixelWidth;
	ph = f * this.s.pixelHeight;
	
	this.s.pixelWidth = pw;
	this.s.pixelHeight = ph;

	if ( pw <= vw )
		this.s.posLeft = (vw / 2) - cx;
	else
		{
		var left = cx - (vw / 2);
		
		if ( left >= 0 )
			{
			this.s.posLeft = 0;
			window.scrollBy(-document.body.scrollLeft, 0);
			window.scrollBy(left - document.body.scrollLeft, 0);
			}
		else
			{
			this.s.posLeft = -left;
			window.scrollBy(-document.body.scrollLeft, 0);
			}
		}

	if ( ph <= vh )
		this.s.posTop = (vh / 2) - cy;
	else
		{
		var top = cy - (vh / 2);
		
		if ( top >= 0 )
			{
			this.s.posTop = 0;
			window.scrollBy(0, -document.body.scrollTop);
			window.scrollBy(0, top - document.body.scrollTop);
			}
		else
			{
			this.s.posTop = -top;
			window.scrollBy(0, -document.body.scrollTop);
			}
		}
	}
	
function ViewMgrOnResize()
	{
	if ( -1 != this.zoomFactor )
		return;
		
	var w, h;
	
	cltWidth = document.body.clientWidth - (2 * cxmgn);
	cltHeight = document.body.clientHeight - (2 * cymgn);
	
	cltWH = document.body.clientWidth / document.body.clientHeight;
	
	if ( cltWH < this.origWH )
		{
		w = cltWidth;
		h = w / this.origWH;
		}
	else
		{
		h = cltHeight
		w = h * this.origWH;
		}
		
	this.s.pixelWidth = w;
	this.s.pixelHeight = h;
	this.s.posLeft = cxmgn + (cltWidth - w) / 2;
	this.s.posTop = cymgn + (cltHeight - h) / 2;
	}
	
	
//------------------------------------------------------------------------
// page movement
//------------------------------------------------------------------------

function handleResize()
	{
	location.reload();
	return false;
	}

function IsFrame(frameName)
	{
	return window.name == frameName;
	}

function SupportsVML()
	{
	var appVer=navigator.appVersion
	var msie=appVer.indexOf("MSIE ")
	var ver=0
	
	if( msie >= 0 )
		ver=parseFloat( appVer.substring( msie+5, appVer.indexOf(";",msie) ) )
	else
		ver=parseInt(appVer)

	return( ver >= 5 && msie >= 0 )
	}

function UpdNavBar()
	{
	if ( parent.g_NavBarLoaded )
		parent.frmNavBar.UpdateNavBar();
	}
function UpdTitleBar()
	{
	if ( parent.g_TitleBarLoaded )
		parent.frmTitleBar.UpdateTitleBar();
	}

function GetCurPageNum()	{ return g_theApp.CurrentPageIX; }
function GetNumPages()		{ return g_theApp.FileList.length; }
	
function GoToNextPage()		{ GoToPage(g_theApp.CurrentPageIX + 1); }
function GoToPrevPage()		{ GoToPage(g_theApp.CurrentPageIX - 1); }
function GoToFirstPage()	{ GoToPage(0); }
function GoToLastPage()		{ GoToPage(gDocTable.length - 1) };

function GoToPage(ix)
	{
	var entry;
	
	if ( (ix != g_theApp.CurrentPageIX) && 
		 (null != (entry = g_theApp.FileList[ix])) )
		{
		var newPage;

		if ( g_theApp.UseVML )
			{
			newPage = entry.VMLImage;

			if ( "" == newPage )
				newPage = newPage = entry.RasterImage;
			}
		else
			newPage = entry.RasterImage;

		parent.frmPageView.location = newPage;
			
		g_theApp.CurrentPageIX = ix;
		PageUpdated(ix);
		}
	}

function ZoomAvailable()
	{
	return g_theApp.UseVML && (g_theApp.FileList[0].VMLImage != "");
	}

function PageUpdated(ix)
	{
	UpdNavBar();
	UpdTitleBar();
	}

function HasPrevSld()	{ return (GetCurPageNum() > 0); }
function HasNextSld()	{ return ((GetCurPageNum() + 1) < GetNumPages()); }

function CancelDrag()
	{
	window.event.cancelBubble=true;
	window.event.returnValue=false
	}

//------------------------------------------------------------------------
// string table
//------------------------------------------------------------------------

var IDS_DISPLAY				= 0;
var IDS_PAGE				= 1;
var IDS_OF					= 2;
var IDS_TITLE_PREVPAGE		= 3;
var IDS_TITLE_NEXTPAGE		= 4;
var IDS_ZOOM				= 5;
var IDS_WINDOW				= 6;

var g_rgStringTable = new Array();

g_rgStringTable[IDS_DISPLAY]		= "Display";
g_rgStringTable[IDS_PAGE]			= "Page";
g_rgStringTable[IDS_OF]				= " of ";
g_rgStringTable[IDS_TITLE_PREVPAGE]	= "Previous Page";
g_rgStringTable[IDS_TITLE_NEXTPAGE]	= "Next Page";
g_rgStringTable[IDS_ZOOM]			= "Zoom";
g_rgStringTable[IDS_WINDOW]			= "Fit In Window";
	
	
function jsLoadString(id)
	{
	var entry;
	
	if ( null != (entry = g_rgStringTable[id]) )
		return entry;
	
	return "";
	}
	
//------------------------------------------------------------------------
// Util
//------------------------------------------------------------------------

function html_escape(txt)
	{
	var result = "";

	for ( var i = 0 ; i < txt.length ; i++ )
		{
		switch ( txt.charAt(i) )
			{
			case '&': result += "&amp;"; break;
			case '<': result += "&lt;"; break;
			case '>': result += "&gt;"; break;
			default : result += txt.charAt(i); break;
			}
		}
	
	return result;
	}

function FindForm(form, doc)
	{
	if ( isIE )
		return doc.forms[form];
	else if ( null != doc )
		{
		if ( null != doc.forms )
			{
			for ( i = 0 ; i < doc.forms.length ; i++ )
				{
				if ( form == doc.forms[i].name )
					return doc.forms[i];
				}
			}

		if ( null != doc.layers )
			{
			for ( i = 0 ; i < doc.layers.length ; i++ )
				{
				result = FindForm(form, doc.layers[i].document);

				if ( null != result )
					return result;
				}
			}
		}

	return null;
	}

function FindLayer(layer, doc)
	{
	var result = null;

	if ( isIE )
		return doc.all(layer);
	else if ( (null != doc) && (null != doc.layers) )
		{
		for ( i = 0 ; i < doc.layers.length ; i++ )
			{
			result = doc.layers[i];

			if ( layer == result.name )
				return result;

			result = FindLayer(layer, result.document);

			if ( null != result )
				return result;
			}
		}

	return null;
	}



