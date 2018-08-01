package coconut.gmaps.ref;

import google.maps.Event;

using tink.CoreApi;

class RefBase<T, Data> {
	public var ref(default, null):T;
	public var binding:CallbackLink;
	public var data:Data;
	var doClose:T->Void;
	var doReset:T->Void;
	
	public function new(ref, doClose, ?doReset) {
		this.ref = ref;
		this.doClose = doClose;
		this.doReset = doReset;
	}
	
	// this function makes sure there is at most only one listener for an event
	public function listen(name:String, f) {
		Event.clearListeners(this.ref, name);
		if(f != null) Event.addListener(this.ref, name, f);
	}
	
	public function reset(close = true) {
		Event.clearInstanceListeners(this.ref);
		if(doReset != null) doReset(ref); // type-specific reset code
		
		if(close) doClose(ref);
		
		this.binding.dissolve();
		this.binding = null;
	}
}