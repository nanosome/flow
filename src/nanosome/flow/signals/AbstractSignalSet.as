/**
 * Created by ${PRODUCT_NAME}.
 * User: Dmitry
 * Date: 01.11.10
 * Time: 18:43
 * To change this template use File | Settings | File Templates.
 */
package nanosome.flow.signals
{
    import flash.events.EventDispatcher;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;

    public class AbstractSignalSet extends EventDispatcher
    {
        public static const SIGNAL_ID_PREFIX:String = "signal.";

        public function AbstractSignalSet()
        {
            initiateSignals();
        }

		private function initiateSignals():void
		{
			var stateClassName:String = getQualifiedClassName(Signal);
			var typeDesc:XML = describeType(this);

			var vars:XMLList = typeDesc.child("variable");

			var typeAttr:String;
			var nameAttr:String;

			for each (var item:XML in vars)
			{
				typeAttr = item.attribute("type");
				nameAttr = item.attribute("name");

                if (this[nameAttr] != null) // exit, if this member already exists
                    return;

				else if (typeAttr == stateClassName)
					this[nameAttr] = new Signal(SIGNAL_ID_PREFIX + nameAttr, this);
			}
		}
    }

}
