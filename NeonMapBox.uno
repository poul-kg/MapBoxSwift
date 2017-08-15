using Uno;
using Uno.Time;
using Uno.Compiler.ExportTargetInterop;
using Fuse.Controls;
using Fuse.Controls.Native;
// Uno to JS event support
using Fuse.Scripting;
using Fuse.Reactive;

namespace Native 
{
	public interface NeonMapBoxDelegate 
	{
		void OnAnnotationClicked(int index);
	}

	public interface NeonMapBoxView
	{
		void AddAnnotation(double lat, double lng);
	}

	public partial class NeonMapBox : Panel, NeonMapBoxDelegate
	{
		NeonMapBoxView MapBoxView
		{
			get { return NativeView as NeonMapBoxView; }
		}

		void NeonMapBoxDelegate.OnAnnotationClicked(int index)
		{
			debug_log "Annotation Clicked " + index;
		}

		protected override IView CreateNativeView()
		{
			if defined(iOS)
			{
				return new Native.iOS.NeonMapBox(this);
			}
			else
			{
				return base.CreateNativeView();
			}
		}
	}
}
