using Uno;
using Uno.UX;
using Uno.Time;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.iOS;
// event support
using Fuse.Scripting;
using Fuse.Reactive;


namespace Native.iOS
{
	[Require("Source.Include", "UIKit/UIKit.h")]
	[Require("Xcode.Plist.Element", "<key>MGLMapboxAccessToken</key><string>pk.eyJ1IjoicGF2ZWxrb3N0ZW5rbyIsImEiOiJjajVmYWYwMW8xMWc0MzNvZGt1ajZhdHlzIn0.v3z5PDM8pAbRZZnCHWka5Q</string>")]

    [extern(iOS) Require("Source.Include", "Mapbox/Mapbox.h")]
	[ForeignInclude(Language.ObjC, "NeonMapBox-Swift.h")]
	extern(iOS) public class NeonMapBox : LeafView, NeonMapBoxView
	{
		NeonMapBoxDelegate _host;
		// NativeEvent _nativeEvent; // UNO to JS support

        [UXConstructor]
		public NeonMapBox([UXParameter("Host")]NeonMapBoxDelegate host) : base(Create())
		{
			_host = host;
			getCalback(Handle);
			// event support
			// _nativeEvent = new NativeEvent("onMessageReceived");
            // AddMember(_nativeEvent);
		}

		void onClickedButton(ObjC.Object sender, ObjC.Object args)
		{
			
		}

		void selectedAnnotation(string userName)
		{
			debug_log "Selected User " + userName;
		}

		[Foreign(Language.ObjC)]
		void getCalback(ObjC.Object handle)
		@{
			MapView* mapView =(MapView*)handle;
			mapView.annotationSelectCallback = ^(AnnotationObject* selectedAnnotation) {
				@{NeonMapBox:Of(_this).selectedAnnotation(string):Call(selectedAnnotation.userName)};
			};
		@}

		void NeonMapBoxView.AddAnnotation(double lat, double lng)
		{

		}

		[Foreign(Language.ObjC)]
		static ObjC.Object Create()
		@{
			MapView* mapView =[[MapView alloc] init];
			return mapView;
		@}

		[Foreign(Language.ObjC)]
		ObjC.Object CreateCoordinate(double lat, double lng)
		@{
			CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
			return coordinate
		@}

		[Foreign(Language.ObjC)]
		ObjC.Object CreateAnnotationObject(String username, String time, String id, String color, double lat, double lng)
		@{
		
		@}

		[Foreign(Language.ObjC)]
		void AddAnnotation(ObjC.Object handle, ObjC.Object arg)
		@{
			
		@}
	}
}